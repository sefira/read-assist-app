@echo off
echo Checking AWS CLI configuration...
echo.
echo Current AWS profile:
aws sts get-caller-identity

echo.
echo AWS credentials file location:
echo %USERPROFILE%\.aws\credentials

echo.
echo To view credentials (BE CAREFUL - these are sensitive):
echo type %USERPROFILE%\.aws\credentials

echo.
echo WARNING: Do not share these credentials publicly!
pause