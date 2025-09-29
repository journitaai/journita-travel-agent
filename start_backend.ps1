# Journita Travel Agent Backend Startup Script
Write-Host "🚀 Starting Journita Travel Agent Backend..." -ForegroundColor Green
Write-Host "=" * 50

# Navigate to project directory
$ProjectPath = "C:\Users\PC\Desktop\journita-travel-agent"
Set-Location $ProjectPath

Write-Host "📁 Project directory: $ProjectPath" -ForegroundColor Cyan
Write-Host ""

# Check if virtual environment exists
if (Test-Path ".\.venv\Scripts\uvicorn.exe") {
    Write-Host "✅ Virtual environment found!" -ForegroundColor Green
    $uvicornPath = ".\.venv\Scripts\uvicorn.exe"
} else {
    Write-Host "❌ Virtual environment not found!" -ForegroundColor Red
    Write-Host "Please run 'poetry install' first." -ForegroundColor Yellow
    exit 1
}

# Check environment variables
Write-Host "🔑 Checking API keys..." -ForegroundColor Yellow
if ($env:GOOGLE_API_KEY) {
    Write-Host "  ✅ GOOGLE_API_KEY: Set" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  GOOGLE_API_KEY: Not set" -ForegroundColor Yellow
}

if ($env:SERPAPI_API_KEY) {
    Write-Host "  ✅ SERPAPI_API_KEY: Set" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  SERPAPI_API_KEY: Not set" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🌟 Starting FastAPI server..." -ForegroundColor Green
Write-Host "📱 Backend API: http://localhost:8000" -ForegroundColor Cyan
Write-Host "📚 API Documentation: http://localhost:8000/docs" -ForegroundColor Cyan
Write-Host "📊 Health Check: http://localhost:8000/health" -ForegroundColor Cyan
Write-Host "🎨 Demo Frontend: http://localhost:8000/demo" -ForegroundColor Cyan
Write-Host ""
Write-Host "⏹️  Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host "=" * 50
Write-Host ""

try {
    # Start the server
    & $uvicornPath production_server:app --reload --host 0.0.0.0 --port 8000
}
catch {
    Write-Host "❌ Error starting server: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Make sure the virtual environment is properly set up." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "👋 Server stopped. Press any key to exit..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
