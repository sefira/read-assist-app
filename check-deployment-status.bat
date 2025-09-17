@echo off
echo Checking GitHub Actions deployment status...
echo.
echo 1. Check if GitHub Actions ran successfully:
echo    - Go to your GitHub repository
echo    - Click "Actions" tab
echo    - Look for green checkmark or red X
echo.
echo 2. Checking current S3 website content...
aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey=='WebsiteBucket'].OutputValue" --output text --region us-east-1 > bucket_name.txt
set /p BUCKET_NAME=<bucket_name.txt

echo Website bucket: %BUCKET_NAME%
echo.
echo Current index.html content in S3:
aws s3 cp s3://%BUCKET_NAME%/index.html - --region us-east-1 | findstr "API_ENDPOINT"

echo.
echo 3. Getting correct API endpoint:
aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey=='ApiEndpoint'].OutputValue" --output text --region us-east-1

del bucket_name.txt
echo.
echo If API_ENDPOINT_PLACEHOLDER is still showing, the GitHub Actions deployment failed.
pause