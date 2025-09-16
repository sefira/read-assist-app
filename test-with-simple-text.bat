@echo off
echo Testing with simple text...
curl -X POST https://35cwgrdmfe.execute-api.us-east-1.amazonaws.com/prod/tts ^
  -H "Content-Type: application/json" ^
  -d "{\"text\":\"test\"}"

echo.
echo.
echo Testing OPTIONS request...
curl -X OPTIONS https://35cwgrdmfe.execute-api.us-east-1.amazonaws.com/prod/tts ^
  -H "Origin: https://example.com"

pause