## Lambda Rotation Handler

import boto3
import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    secret_arn = event['SecretId']
    step = event['Step']
    
    client = boto3.client('secretsmanager')
    rds_client = boto3.client('rds')
    
    if step == 'createSecret':
        create_secret(client, secret_arn)
    elif step == 'setSecret':
        set_secret(client, rds_client, secret_arn)
    elif step == 'testSecret':
        test_secret(client, secret_arn)
    elif step == 'finishSecret':
        finish_secret(client, secret_arn)

def create_secret(client, secret_arn):
    import string, secrets
    alphabet = string.ascii_letters + string.digits + "!@#$%^&*()"
    new_password = ''.join(secrets.choice(alphabet) for _ in range(32))
    
    current = json.loads(
        client.get_secret_value(SecretId=secret_arn, VersionStage='AWSCURRENT')['SecretString']
    )
    current['password'] = new_password
    
    client.put_secret_value(
        SecretId=secret_arn,
        ClientRequestToken=context.aws_request_id,
        SecretString=json.dumps(current),
        VersionStages=['AWSPENDING']
    )
    logger.info(f"New secret version created for {secret_arn}")

def set_secret(client, rds_client, secret_arn):
    pending = json.loads(
        client.get_secret_value(SecretId=secret_arn, VersionStage='AWSPENDING')['SecretString']
    )
    rds_client.modify_db_instance(
        DBInstanceIdentifier=pending['dbInstanceIdentifier'],
        MasterUserPassword=pending['password'],
        ApplyImmediately=True
    )
    logger.info("RDS password updated successfully")

def test_secret(client, secret_arn):
    import pymysql
    secret = json.loads(
        client.get_secret_value(SecretId=secret_arn, VersionStage='AWSPENDING')['SecretString']
    )
    conn = pymysql.connect(
        host=secret['host'],
        user=secret['username'],
        password=secret['password'],
        db=secret['dbname'],
        connect_timeout=5
    )
    conn.close()
    logger.info("Secret rotation test successful — connection verified")

def finish_secret(client, secret_arn):
    metadata = client.describe_secret(SecretId=secret_arn)
    current_version = next(
        v for v, stages in metadata['VersionIdsToStages'].items()
        if 'AWSCURRENT' in stages
    )
    client.update_secret_version_stage(
        SecretId=secret_arn,
        VersionStage='AWSCURRENT',
        MoveToVersionId=context.aws_request_id,
        RemoveFromVersionId=current_version
    )
    logger.info("Secret rotation complete")
