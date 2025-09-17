@echo off
echo Manual deployment of ReadAssist...

echo Getting AWS resources...
for /f %%i in ('aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey=='ApiEndpoint'].OutputValue" --output text --region us-east-1') do set API_ENDPOINT=%%i
for /f %%i in ('aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey=='WebsiteBucket'].OutputValue" --output text --region us-east-1') do set WEBSITE_BUCKET=%%i

echo API Endpoint: %API_ENDPOINT%
echo Website Bucket: %WEBSITE_BUCKET%

echo Creating ReadAssist with correct API endpoint...
powershell -Command "(Get-Content index.html) -replace 'API_ENDPOINT_PLACEHOLDER', '%API_ENDPOINT%' -replace 'VoiceForge', 'ReadAssist' | Set-Content readassist.html"

echo Uploading ReadAssist to S3...
aws s3 cp readassist.html s3://%WEBSITE_BUCKET%/index.html --content-type "text/html" --region us-east-1

echo.
echo ReadAssist deployed successfully!
echo Website: http://%WEBSITE_BUCKET%.s3-website-us-east-1.amazonaws.com

del readassist.html
pause