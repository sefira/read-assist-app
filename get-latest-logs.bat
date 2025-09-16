@echo off
echo Getting the very latest logs...
timeout /t 2

aws logs filter-log-events --log-group-name "/aws/lambda/tts-function" --region us-east-1 --start-time 1726525000000 --query "events[-5:].message" --output text

pause