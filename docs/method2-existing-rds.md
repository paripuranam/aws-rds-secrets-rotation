### Method 2 — Existing RDS Without Secrets Manager
 
For RDS instances not originally configured with Secrets Manager:
 
1. Navigate to **Secrets Manager → Store a new secret**
2. Select secret type: **Credentials for Amazon RDS database**
3. Enter database credentials (username + password)
4. Select the RDS database → provide a secret name
5. In **Rotation configuration** → enable automatic rotation
6. **Provide a Lambda function** — required because AWS lacks the original setup metadata
**Why Lambda is required here:**
When manually integrating an existing RDS instance, AWS cannot securely manage the rotation without your input. The Lambda function handles the full rotation lifecycle and requires IAM permissions to update both the secret and the RDS password.
 
---
