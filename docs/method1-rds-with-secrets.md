### Method 1 — RDS Created With Secrets Manager
 
When creating an RDS instance, select **Managed in AWS Secrets Manager** under Credential Management. AWS automatically:
- Stores credentials in Secrets Manager
- Links the RDS instance to the secret
- Enables rotation configuration immediately
**Configure rotation:**
1. Navigate to Secrets Manager → locate the RDS secret
2. Click **Edit rotation** → enable **Automatic rotation**
3. Set schedule expression: `rate(30 days)`
4. Click **Rotate secret immediately** to test
**Before rotation:**
```
Secret value: d-WC36aBgvn0l~O)$0eGObMT>wJn
```
 
**After rotation:**
```
Secret value: UduJPvV20ZB.?]6!xgVVbl5]Cx6M
```
 
---
