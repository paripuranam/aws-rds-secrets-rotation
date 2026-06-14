# AWS Database Secrets Rotation — Automated Credential Management

Automated RDS password rotation using AWS Secrets Manager and Lambda — eliminates manual credential management, enforces rotation every 30 days, and maintains a full audit trail through CloudTrail.

---

## Architecture

```
RDS Instance
      │
      ▼
AWS Secrets Manager
  ├── Stores credentials (username + password)
  ├── Rotation schedule: rate(30 days)
  ├── Auto-rotation trigger → Lambda function
  │         └── Updates RDS password
  │         └── Updates secret value
  └── CloudTrail logs every secret access
```

---

## Two Integration Methods

### Method 1 — RDS Created With Secrets Manager

📄 See detailed setup guide: [method1-rds-with-secrets.md](docs/method1-rds-with-secrets.md)

---

### Method 2 — Existing RDS Without Secrets Manager

📄 See detailed setup guide: [method2-existing-rds.md](docs/method2-existing-rds.md)

---


## Cost

| Resource | Monthly Cost |
|---|---|
| Secrets Manager | USD 0.40 per secret |
| Lambda invocations | Negligible (free tier) |
| CloudTrail logging | Free for management events |
| **Total per database** | **~USD 0.40/month** |

---

## Repository Structure

```
aws-database-secrets-rotation/
├── README.md
├── lambda/
│   └── rotation-handler.py        # Full rotation Lambda
├── iam/
│   └── lambda-rotation-policy.json
├── docs/
│   ├── method1-rds-with-secrets.md
│   └── method2-existing-rds.md
└── terraform/
    ├── providers.tf
    ├── variables.tf
    ├── rds.tf
    ├── secrets-manager.tf
    └── lambda-rotation.tf
```

---

## Skills Demonstrated

- AWS Secrets Manager — credential storage, versioning (AWSCURRENT/AWSPENDING/AWSPREVIOUS), auto-rotation
- Lambda — rotation lifecycle handler (createSecret, setSecret, testSecret, finishSecret)
- RDS — password update via ModifyDBInstance API
- IAM — least-privilege rotation role, resource-scoped permissions
- CloudTrail — audit trail for every GetSecretValue call

---
