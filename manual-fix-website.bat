@echo off
echo Manual fix: Update website with correct API endpoint...
echo.

echo Getting API endpoint...
aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey=='ApiEndpoint'].OutputValue" --output text --region us-east-1 > api_endpoint.txt
aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey=='WebsiteBucket'].OutputValue" --output text --region us-east-1 > website_bucket.txt

set /p API_ENDPOINT=<api_endpoint.txt
set /p WEBSITE_BUCKET=<website_bucket.txt

echo API Endpoint: %API_ENDPOINT%
echo Website Bucket: %WEBSITE_BUCKET%

echo.
echo Updating index.html with correct API endpoint...
powershell -Command "(Get-Content index.html) -replace 'API_ENDPOINT_PLACEHOLDER', '%API_ENDPOINT%' | Set-Content index-fixed.html"

echo.
echo Uploading fixed website to S3...
aws s3 cp index-fixed.html s3://%WEBSITE_BUCKET%/index.html --content-type "text/html" --region us-east-1

echo.
echo Website updated! Try accessing it again.
echo Website URL: http://%WEBSITE_BUCKET%.s3-website-us-east-1.amazonaws.com

del api_endpoint.txt website_bucket.txt index-fixed.html
pause