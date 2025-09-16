@echo off
echo Checking Lambda function logs...
echo.
echo Recent log events (last 10 minutes):
aws logs filter-log-events --log-group-name "/aws/lambda/tts-function" --start-time 1000000000000

echo.
echo If no logs appear, the function might not exist or have a different name.
echo Checking all Lambda functions:
aws lambda list-functions --query "Functions[?contains(FunctionName, 'tts')].FunctionName"

pause