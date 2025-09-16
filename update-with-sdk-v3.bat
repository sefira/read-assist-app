@echo off
echo Creating zip with AWS SDK v3 code...
powershell -Command "Compress-Archive -Path index.js -DestinationPath lambda-sdk-v3.zip -Force"

echo Updating Lambda function...
aws lambda update-function-code --function-name tts-function --zip-file fileb://lambda-sdk-v3.zip --region us-east-1

echo Updating to Node.js 20.x (has AWS SDK v3)...
aws lambda update-function-configuration --function-name tts-function --runtime nodejs20.x --region us-east-1

echo Waiting for update...
timeout /t 5

echo Testing function...
curl -X POST https://35cwgrdmfe.execute-api.us-east-1.amazonaws.com/prod/tts ^
  -H "Content-Type: application/json" ^
  -d "{\"text\":\"Hello world\",\"voiceId\":\"Joanna\"}"

echo.
echo Cleaning up...
del lambda-sdk-v3.zip

pause