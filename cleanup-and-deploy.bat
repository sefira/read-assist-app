@echo off
echo Cleaning up failed stack and redeploying...

echo 1. Deleting failed stack...
aws cloudformation delete-stack --stack-name tts-simple
echo Waiting for deletion...
aws cloudformation wait stack-delete-complete --stack-name tts-simple

echo 2. Creating new stack with fixed template...
aws cloudformation create-stack --stack-name tts-simple --template-body file://simple-template.yaml --capabilities CAPABILITY_IAM

echo 3. Waiting for stack creation...
aws cloudformation wait stack-create-complete --stack-name tts-simple

echo 4. Getting outputs...
aws cloudformation describe-stacks --stack-name tts-simple --query "Stacks[0].Outputs[?OutputKey=='ApiEndpoint'].OutputValue" --output text > api_endpoint.txt
aws cloudformation describe-stacks --stack-name tts-simple --query "Stacks[0].Outputs[?OutputKey=='WebsiteBucket'].OutputValue" --output text > website_bucket.txt
aws cloudformation describe-stacks --stack-name tts-simple --query "Stacks[0].Outputs[?OutputKey=='WebsiteURL'].OutputValue" --output text > website_url.txt

set /p API_ENDPOINT=<api_endpoint.txt
set /p WEBSITE_BUCKET=<website_bucket.txt
set /p WEBSITE_URL=<website_url.txt

echo API Endpoint: %API_ENDPOINT%
echo Website Bucket: %WEBSITE_BUCKET%
echo Website URL: %WEBSITE_URL%

echo 5. Updating index.html with API endpoint...
powershell -Command "(Get-Content index.html) -replace 'API_ENDPOINT_PLACEHOLDER', '%API_ENDPOINT%' | Set-Content index-updated.html"

echo 6. Uploading website to S3...
aws s3 cp index-updated.html s3://%WEBSITE_BUCKET%/index.html --content-type "text/html"

echo 7. Cleaning up temp files...
del api_endpoint.txt website_bucket.txt website_url.txt

echo.
echo Deployment complete!
echo Website URL: %WEBSITE_URL%
echo.
pause