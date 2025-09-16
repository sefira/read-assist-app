@echo off
echo Getting latest CloudWatch logs...
aws logs describe-log-streams --log-group-name "/aws/lambda/tts-function" --region us-east-1 --order-by LastEventTime --descending --max-items 1 --query "logStreams[0].logStreamName" --output text > latest_stream.txt

set /p STREAM_NAME=<latest_stream.txt

echo Latest log stream: %STREAM_NAME%
echo.
echo Recent log events:
aws logs get-log-events --log-group-name "/aws/lambda/tts-function" --log-stream-name "%STREAM_NAME%" --region us-east-1 --query "events[-10:].message" --output text

del latest_stream.txt
pause