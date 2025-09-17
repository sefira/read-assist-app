@echo off
echo Step 3: Push to GitHub
echo.

echo Step 3a: Connect to your GitHub repository
echo Replace YOUR_USERNAME and YOUR_REPO_NAME with actual values:
echo.
set /p GITHUB_URL="Enter your GitHub repository URL (e.g., https://github.com/username/tts-app.git): "

echo.
echo Step 3b: Adding remote repository...
git remote add origin %GITHUB_URL%

echo.
echo Step 3c: Rename branch to main...
git branch -M main

echo.
echo Step 3d: Push code to GitHub...
git push -u origin main

echo.
echo Done! Check GitHub Actions tab in your repository to see the deployment.
pause