@echo off
echo Fixing the validation logic in the deployed website...
echo.

echo Getting website bucket...
aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey=='WebsiteBucket'].OutputValue" --output text --region us-east-1 > website_bucket.txt
set /p WEBSITE_BUCKET=<website_bucket.txt

echo Website Bucket: %WEBSITE_BUCKET%

echo.
echo Downloading current index.html from S3...
aws s3 cp s3://%WEBSITE_BUCKET%/index.html current-index.html --region us-east-1

echo.
echo Fixing the validation logic...
powershell -Command "(Get-Content current-index.html) -replace 'if \(API_ENDPOINT === ''https://35cwgrdmfe.execute-api.us-east-1.amazonaws.com/prod/tts''\)', 'if (API_ENDPOINT === ''API_ENDPOINT_PLACEHOLDER'')' | Set-Content fixed-index.html"

echo.
echo Uploading fixed website to S3...
aws s3 cp fixed-index.html s3://%WEBSITE_BUCKET%/index.html --content-type "text/html" --region us-east-1

echo.
echo Fixed! The website should now work properly.
echo Website URL: http://%WEBSITE_BUCKET%.s3-website-us-east-1.amazonaws.com

del website_bucket.txt current-index.html fixed-index.html
pause