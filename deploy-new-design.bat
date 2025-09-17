@echo off
echo Deploying improved web app design...
echo.

echo Committing changes to Git...
git add index.html
git commit -m "feat: Modern UI redesign with improved UX

- Added gradient background and modern styling
- Improved responsive design for mobile
- Added loading states and better feedback
- Added character counter with validation
- Enhanced audio player and download button
- Added animations and hover effects"

echo.
echo Pushing to GitHub (triggers automatic deployment)...
git push

echo.
echo GitHub Actions will automatically deploy the new design!
echo Check the Actions tab to monitor deployment progress.
pause