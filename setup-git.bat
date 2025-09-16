@echo off
echo Initializing Git repository...
git init

echo Adding files...
git add .

echo Creating initial commit...
git commit -m "Initial commit: TTS application with GitHub Actions pipeline"

echo.
echo Next steps:
echo 1. Create a new repository on GitHub
echo 2. Add GitHub secrets: AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
echo 3. Run these commands:
echo.
echo git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
echo git branch -M main
echo git push -u origin main
echo.
pause