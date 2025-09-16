@echo off
echo Testing API directly with curl...
curl -X POST https://35cwgrdmfe.execute-api.us-east-1.amazonaws.com/prod/tts ^
  -H "Content-Type: application/json" ^
  -d "{\"text\":\"Hello world\",\"voiceId\":\"Joanna\"}"

echo.
echo.
echo If you see an error above, check CloudWatch logs:
echo Go to AWS Console > CloudWatch > Log Groups > /aws/lambda/tts-function
pause