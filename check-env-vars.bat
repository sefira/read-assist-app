@echo off
echo Checking Lambda function environment variables...
aws lambda get-function-configuration --function-name tts-function --region us-east-1 --query "Environment.Variables"

echo.
echo Checking if S3 bucket exists...
aws lambda get-function-configuration --function-name tts-function --region us-east-1 --query "Environment.Variables.S3_BUCKET_NAME" --output text > bucket_name.txt
set /p BUCKET_NAME=<bucket_name.txt

echo S3 Bucket Name: %BUCKET_NAME%
aws s3 ls s3://%BUCKET_NAME% 2>nul && echo Bucket exists || echo Bucket does NOT exist

del bucket_name.txt
pause