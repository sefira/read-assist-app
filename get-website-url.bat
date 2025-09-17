@echo off
echo Getting website URL from AWS...
aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey=='WebsiteURL'].OutputValue" --output text --region us-east-1

echo.
echo You can also find this URL in:
echo 1. GitHub Actions workflow output
echo 2. AWS CloudFormation console
echo 3. S3 console under Static website hosting
pause