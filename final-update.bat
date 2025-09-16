@echo off
echo Creating final zip with stream handling fix...
powershell -Command "Compress-Archive -Path index.js -DestinationPath lambda-final-fix.zip -Force"

echo Updating Lambda function...
aws lambda update-function-code --function-name tts-function --zip-file fileb://lambda-final-fix.zip --region us-east-1

echo Waiting for update...
timeout /t 5

echo Testing function...
curl -X POST https://35cwgrdmfe.execute-api.us-east-1.amazonaws.com/prod/tts ^
  -H "Content-Type: application/json" ^
  -d "{\"text\":\"Hello world\",\"voiceId\":\"Joanna\"}"

echo.
echo Cleaning up...
del lambda-final-fix.zip

pause