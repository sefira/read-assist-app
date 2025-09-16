@echo off
echo Getting stack outputs...
aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey=='ApiEndpoint'].OutputValue" --output text > api_endpoint.txt
aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey=='S3Bucket'].OutputValue" --output text > website_bucket.txt

set /p API_ENDPOINT=<api_endpoint.txt
set /p WEBSITE_BUCKET=<website_bucket.txt

echo API Endpoint: %API_ENDPOINT%
echo Website Bucket: %WEBSITE_BUCKET%

echo Updating index.html with API endpoint...
powershell -Command "(Get-Content index.html) -replace 'API_ENDPOINT_PLACEHOLDER', '%API_ENDPOINT%' | Set-Content index-updated.html"

echo Uploading website to S3...
aws s3 cp index-updated.html s3://%WEBSITE_BUCKET%/index.html --content-type "text/html"

echo Cleaning up temp files...
del api_endpoint.txt website_bucket.txt index-updated.html

echo.
echo Website uploaded successfully!
echo Website URL: http://%WEBSITE_BUCKET%.s3-website-us-east-1.amazonaws.com
pause