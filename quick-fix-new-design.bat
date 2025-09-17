@echo off
echo Quick fix: Updating the new design with correct API endpoint...
echo.

echo Getting stack outputs...
aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey=='ApiEndpoint'].OutputValue" --output text --region us-east-1 > api_endpoint.txt
aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey=='WebsiteBucket'].OutputValue" --output text --region us-east-1 > website_bucket.txt

set /p API_ENDPOINT=<api_endpoint.txt
set /p WEBSITE_BUCKET=<website_bucket.txt

echo API Endpoint: %API_ENDPOINT%
echo Website Bucket: %WEBSITE_BUCKET%

echo.
echo Updating new design with correct API endpoint...
powershell -Command "(Get-Content index.html) -replace 'API_ENDPOINT_PLACEHOLDER', '%API_ENDPOINT%' | Set-Content index-updated.html"

echo.
echo Uploading updated design to S3...
aws s3 cp index-updated.html s3://%WEBSITE_BUCKET%/index.html --content-type "text/html" --region us-east-1

echo.
echo New design deployed with working API!
echo Website URL: http://%WEBSITE_BUCKET%.s3-website-us-east-1.amazonaws.com

del api_endpoint.txt website_bucket.txt index-updated.html
pause