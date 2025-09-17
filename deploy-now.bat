@echo off
echo Deploying TTS Application...

REM Deploy CloudFormation stack
aws cloudformation deploy --template-file simple-template.yaml --stack-name tts-app --capabilities CAPABILITY_IAM

REM Get outputs
for /f "tokens=*" %%i in ('aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey==`ApiEndpoint`].OutputValue" --output text') do set API_ENDPOINT=%%i
for /f "tokens=*" %%i in ('aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey==`ApiKey`].OutputValue" --output text') do set API_KEY=%%i
for /f "tokens=*" %%i in ('aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey==`WebsiteBucket`].OutputValue" --output text') do set WEBSITE_BUCKET=%%i

echo API Endpoint: %API_ENDPOINT%
echo API Key: %API_KEY%
echo Website Bucket: %WEBSITE_BUCKET%

REM Create updated HTML
copy index.html index-updated.html
powershell -Command "(Get-Content index-updated.html) -replace 'API_ENDPOINT_PLACEHOLDER', '%API_ENDPOINT%' | Set-Content index-updated.html"
powershell -Command "(Get-Content index-updated.html) -replace 'API_KEY_PLACEHOLDER', '%API_KEY%' | Set-Content index-updated.html"

REM Upload to S3
aws s3 cp index-updated.html s3://%WEBSITE_BUCKET%/index.html

REM Get website URL
for /f "tokens=*" %%i in ('aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey==`WebsiteURL`].OutputValue" --output text') do set WEBSITE_URL=%%i

echo.
echo Deployment complete!
echo Website URL: %WEBSITE_URL%
pause