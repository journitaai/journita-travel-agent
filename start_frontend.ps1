Write-Host "🚀 Starting Journita Travel Agent Frontend (React)..." -ForegroundColor Green
Write-Host ""
Write-Host "Make sure Node.js is installed!" -ForegroundColor Yellow
Write-Host "Backend should be running on: http://localhost:8000" -ForegroundColor Cyan
Write-Host "Frontend will run on: http://localhost:3000" -ForegroundColor Cyan
Write-Host ""

Set-Location "C:\Users\PC\Desktop\journita-travel-agent\frontend"

Write-Host "📁 Current directory: $(Get-Location)" -ForegroundColor Blue
Write-Host ""

Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow
npm install

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
    Write-Host ""
    Write-Host "Make sure Node.js and npm are installed:" -ForegroundColor Yellow
    Write-Host "https://nodejs.org/" -ForegroundColor Blue
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "✅ Dependencies installed!" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 Starting React development server..." -ForegroundColor Green
Write-Host ""
npm start

Read-Host "Press Enter to exit"
