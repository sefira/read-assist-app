@echo off
echo Creating zip file with fixed Lambda code...
powershell -Command "Compress-Archive -Path fixed-lambda-code.js -DestinationPath lambda-fixed.zip -Force"

echo Updating Lambda function...
aws lambda update-function-code --function-name tts-function --zip-file fileb://lambda-fixed.zip --region us-east-1

echo Updating runtime to Node.js 18.x...
aws lambda update-function-configuration --function-name tts-function --runtime nodejs18.x --region us-east-1

echo Waiting for update to complete...
timeout /t 5

echo Testing updated function...
curl -X POST https://35cwgrdmfe.execute-api.us-east-1.amazonaws.com/prod/tts ^
  -H "Content-Type: application/json" ^
  -d "{\"text\":\"Hello world\",\"voiceId\":\"Joanna\"}"

echo.
echo Cleaning up...
del lambda-fixed.zip

pause