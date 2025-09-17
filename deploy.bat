@echo off
echo ReadAssist Deployment Script
echo ===========================

REM Get API endpoint from CloudFormation
echo Getting API endpoint...
for /f "tokens=*" %%i in ('aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey=='ApiEndpoint'].OutputValue" --output text --region us-east-1') do set API_ENDPOINT=%%i

REM Get S3 bucket name
echo Getting S3 bucket name...
for /f "tokens=*" %%i in ('aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey=='WebsiteBucket'].OutputValue" --output text --region us-east-1') do set BUCKET_NAME=%%i

echo API Endpoint: %API_ENDPOINT%
echo S3 Bucket: %BUCKET_NAME%

REM Create temporary file with API endpoint replaced
echo Replacing API endpoint in HTML...
powershell -Command "(Get-Content index.html) -replace 'API_ENDPOINT_PLACEHOLDER', '%API_ENDPOINT%' | Set-Content index-deploy.html"

REM Upload to S3
echo Uploading to S3...
aws s3 cp index-deploy.html s3://%BUCKET_NAME%/index.html --content-type "text/html" --region us-east-1

REM Clean up
del index-deploy.html

echo.
echo Deployment complete!
echo Website URL: http://%BUCKET_NAME%.s3-website-us-east-1.amazonaws.com
pause