@echo off
echo Checking if resources exist...
echo.
echo Lambda function:
aws lambda get-function --function-name tts-function --query "Configuration.FunctionName"

echo.
echo S3 buckets:
aws s3 ls | findstr tts

echo.
echo API Gateway:
aws apigateway get-rest-apis --query "items[?name=='tts-api'].{Name:name,Id:id}"

pause