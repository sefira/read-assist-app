#!/usr/bin/env pwsh
Write-Host "ReadAssist Deployment Script" -ForegroundColor Green
Write-Host "============================" -ForegroundColor Green

# Get API endpoint from CloudFormation
Write-Host "Getting API endpoint..." -ForegroundColor Yellow
$API_ENDPOINT = aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey=='ApiEndpoint'].OutputValue" --output text --region us-east-1

# Get S3 bucket name
Write-Host "Getting S3 bucket name..." -ForegroundColor Yellow
$BUCKET_NAME = aws cloudformation describe-stacks --stack-name tts-app --query "Stacks[0].Outputs[?OutputKey=='WebsiteBucket'].OutputValue" --output text --region us-east-1

Write-Host "API Endpoint: $API_ENDPOINT" -ForegroundColor Cyan
Write-Host "S3 Bucket: $BUCKET_NAME" -ForegroundColor Cyan

# Replace API endpoint in HTML
Write-Host "Replacing API endpoint in HTML..." -ForegroundColor Yellow
$content = Get-Content "index.html" -Raw
$deployContent = $content -replace 'API_ENDPOINT_PLACEHOLDER', $API_ENDPOINT
$deployContent | Set-Content "index-deploy.html"

# Upload to S3
Write-Host "Uploading to S3..." -ForegroundColor Yellow
aws s3 cp index-deploy.html "s3://$BUCKET_NAME/index.html" --content-type "text/html" --region us-east-1

# Clean up
Remove-Item "index-deploy.html"

Write-Host ""
Write-Host "Deployment complete!" -ForegroundColor Green
Write-Host "Website URL: http://$BUCKET_NAME.s3-website-us-east-1.amazonaws.com" -ForegroundColor Cyan