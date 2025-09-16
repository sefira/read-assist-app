@echo off
echo Deploying complete TTS application...

echo 1. Creating CloudFormation stack...
aws cloudformation create-stack --stack-name tts-complete --template-body file://complete-template.yaml --capabilities CAPABILITY_IAM

echo 2. Waiting for stack creation...
aws cloudformation wait stack-create-complete --stack-name tts-complete

echo 3. Getting outputs...
aws cloudformation describe-stacks --stack-name tts-complete --query "Stacks[0].Outputs[?OutputKey=='ApiEndpoint'].OutputValue" --output text > api_endpoint.txt
aws cloudformation describe-stacks --stack-name tts-complete --query "Stacks[0].Outputs[?OutputKey=='WebsiteBucket'].OutputValue" --output text > website_bucket.txt
aws cloudformation describe-stacks --stack-name tts-complete --query "Stacks[0].Outputs[?OutputKey=='WebsiteURL'].OutputValue" --output text > website_url.txt

set /p API_ENDPOINT=<api_endpoint.txt
set /p WEBSITE_BUCKET=<website_bucket.txt
set /p WEBSITE_URL=<website_url.txt

echo API Endpoint: %API_ENDPOINT%
echo Website Bucket: %WEBSITE_BUCKET%
echo Website URL: %WEBSITE_URL%

echo 4. Updating index.html with API endpoint...
powershell -Command "(Get-Content index.html) -replace 'API_ENDPOINT_PLACEHOLDER', '%API_ENDPOINT%' | Set-Content index-updated.html"

echo 5. Uploading website to S3...
aws s3 cp index-updated.html s3://%WEBSITE_BUCKET%/index.html --content-type "text/html"

echo 6. Cleaning up temp files...
del api_endpoint.txt website_bucket.txt website_url.txt

echo.
echo Deployment complete!
echo Website URL: %WEBSITE_URL%
echo API Endpoint: %API_ENDPOINT%
echo.
echo The website is now hosted on CloudFront and audio files are stored in S3.
pause