@echo off
echo Checking CloudFormation stack status...
aws cloudformation describe-stacks --stack-name tts-complete --query "Stacks[0].{Status:StackStatus,Outputs:Outputs}"

echo.
echo Stack outputs:
aws cloudformation describe-stacks --stack-name tts-complete --query "Stacks[0].Outputs[*].{Key:OutputKey,Value:OutputValue}" --output table

pause