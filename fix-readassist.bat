@echo off
echo Fixing ReadAssist with correct API endpoint...

aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey=='ApiEndpoint'].OutputValue" --output text --region us-east-1 > api.txt
aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey=='WebsiteBucket'].OutputValue" --output text --region us-east-1 > bucket.txt

set /p API_ENDPOINT=<api.txt
set /p WEBSITE_BUCKET=<bucket.txt

powershell -Command "(Get-Content index.html) -replace 'API_ENDPOINT_PLACEHOLDER', '%API_ENDPOINT%' | Set-Content fixed.html"

aws s3 cp fixed.html s3://%WEBSITE_BUCKET%/index.html --content-type "text/html" --region us-east-1

echo ReadAssist updated! Website: http://%WEBSITE_BUCKET%.s3-website-us-east-1.amazonaws.com

del api.txt bucket.txt fixed.html
pause