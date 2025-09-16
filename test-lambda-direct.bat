@echo off
echo Testing Lambda function directly...
echo.
echo Creating test payload...
echo {"body": "{\"text\":\"Hello world\",\"voiceId\":\"Joanna\"}", "httpMethod": "POST"} > test-payload.json

echo Invoking Lambda function...
aws lambda invoke --function-name tts-function --payload file://test-payload.json response.json

echo.
echo Lambda response:
type response.json

echo.
echo Cleaning up...
del test-payload.json response.json

pause