@echo off
echo Getting API endpoint from CloudFormation stack...
aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey=='ApiEndpoint'].OutputValue" --output text

echo.
echo Copy this URL and manually replace API_ENDPOINT_PLACEHOLDER in your HTML file before uploading to S3.
pause