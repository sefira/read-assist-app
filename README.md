# ReadAssist - Text-to-Speech Web Application

A serverless text-to-speech application with translation capabilities built with AWS services.

## Architecture

- **Frontend**: S3 static website hosting
- **Backend**: API Gateway + Lambda
- **TTS Engine**: Amazon Polly
- **Storage**: S3 bucket for audio files
- **Deployment**: GitHub Actions CI/CD

## Features

- ✅ Convert text to speech using Amazon Polly
- ✅ Multiple voice options (Joanna, Matthew, Amy, Brian)
- ✅ In-browser audio playback
- ✅ Download MP3 files
- ✅ Serverless architecture
- ✅ Automated deployment pipeline
- ✅ **Security Features**:
  - Content Security Policy (CSP) headers
  - XSS prevention with safe DOM manipulation
  - Input sanitization and validation
  - Rate limiting (2 seconds between requests)
  - Character limit enforcement (3000 chars)

## Deployment

### Prerequisites

1. AWS Account with appropriate permissions
2. GitHub repository
3. AWS credentials configured as GitHub secrets

### GitHub Secrets Required

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### Deploy

1. Push code to `main` branch
2. GitHub Actions will automatically:
   - Deploy CloudFormation stack
   - Update Lambda function
   - Deploy website to S3

## Local Development

```bash
# Test API directly
curl -X POST https://your-api-endpoint/prod/tts \
  -H "Content-Type: application/json" \
  -d '{"text":"Hello world","voiceId":"Joanna"}'
```

## Files

- `index.html` - Frontend web interface
- `index.js` - Lambda function code
- `simple-template.yaml` - CloudFormation template
- `.github/workflows/deploy.yml` - CI/CD pipeline

## AWS Services Used

- Amazon API Gateway
- AWS Lambda
- Amazon Polly
- Amazon S3
- AWS CloudFormation
- AWS IAM

## Use Cases

- 📚 **Reading Assistant**: Convert books/articles to audio for hands-free consumption
- 🚗 **Driving Companion**: Listen to content while driving
- 🏃 **Exercise Audio**: Convert text to audio for workouts
- ♿ **Accessibility**: Audio content for visually impaired users