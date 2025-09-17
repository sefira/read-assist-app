# Deployment Guide

## Prerequisites

1. AWS CLI configured with appropriate permissions
2. AWS account with access to:
   - Lambda
   - API Gateway
   - S3
   - Polly
   - Translate
   - CloudFormation
   - IAM

## Quick Deploy

### Option 1: Using AWS CLI

```bash
# Deploy infrastructure
aws cloudformation deploy \
  --template-file simple-template.yaml \
  --stack-name tts-app \
  --capabilities CAPABILITY_IAM

# Get API endpoint
aws cloudformation describe-stacks \
  --stack-name tts-app \
  --query 'Stacks[0].Outputs[?OutputKey==`ApiEndpoint`].OutputValue' \
  --output text

# Update index.html with API endpoint
# Replace API_ENDPOINT_PLACEHOLDER with actual endpoint

# Upload website
aws s3 sync . s3://your-website-bucket --exclude "*.yaml" --exclude "*.md"
```

### Option 2: Using Deploy Scripts

```bash
# Windows
deploy.bat

# PowerShell
.\deploy.ps1
```

## Manual Steps

1. **Deploy CloudFormation Stack**
   ```bash
   aws cloudformation create-stack \
     --stack-name tts-app \
     --template-body file://simple-template.yaml \
     --capabilities CAPABILITY_IAM
   ```

2. **Update Lambda Code**
   ```bash
   zip -r function.zip index.js
   aws lambda update-function-code \
     --function-name tts-function \
     --zip-file fileb://function.zip
   ```

3. **Upload Website**
   ```bash
   # Get bucket name from CloudFormation outputs
   BUCKET=$(aws cloudformation describe-stacks \
     --stack-name tts-app \
     --query 'Stacks[0].Outputs[?OutputKey==`WebsiteBucket`].OutputValue' \
     --output text)
   
   # Upload files
   aws s3 cp index.html s3://$BUCKET/
   ```

## Environment Variables

The Lambda function uses these environment variables:
- `S3_BUCKET_NAME`: Set automatically by CloudFormation

## Permissions Required

The Lambda execution role needs:
- `polly:SynthesizeSpeech`
- `translate:TranslateText`
- `s3:PutObject`
- `s3:GetObject`
- `s3:ListBucket`

## Testing

```bash
# Test translation + TTS
curl -X POST https://your-api-endpoint/prod/tts \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Hello, how are you today?",
    "voiceId": "Joanna",
    "translateTo": "es"
  }'
```

## Troubleshooting

1. **Lambda timeout**: Increase timeout in CloudFormation template
2. **CORS errors**: Check API Gateway CORS configuration
3. **Permission denied**: Verify IAM role permissions
4. **Translation fails**: Check if target language is supported