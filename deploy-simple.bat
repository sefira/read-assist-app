@echo off
echo Deploying TTS Application...

REM Deploy CloudFormation stack
echo Deploying infrastructure...
aws cloudformation deploy --template-file simple-template.yaml --stack-name tts-app --capabilities CAPABILITY_IAM

REM Get API endpoint
echo Getting API endpoint...
for /f "tokens=*" %%i in ('aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey==`ApiEndpoint`].OutputValue" --output text') do set API_ENDPOINT=%%i

REM Get website bucket
for /f "tokens=*" %%i in ('aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey==`WebsiteBucket`].OutputValue" --output text') do set WEBSITE_BUCKET=%%i

echo API Endpoint: %API_ENDPOINT%
echo Website Bucket: %WEBSITE_BUCKET%

REM Update HTML with API endpoint
powershell -Command "(Get-Content index.html) -replace 'API_ENDPOINT_PLACEHOLDER', '%API_ENDPOINT%' | Set-Content index.html"

REM Upload website
echo Uploading website...
aws s3 cp index.html s3://%WEBSITE_BUCKET%/

REM Get website URL
for /f "tokens=*" %%i in ('aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey==`WebsiteURL`].OutputValue" --output text') do set WEBSITE_URL=%%i

echo.
echo Deployment complete!
echo Website URL: %WEBSITE_URL%
echo API Endpoint: %API_ENDPOINT%
pause