# FastAPI Server Startup Script
# Save as: start_server.ps1

Write-Host "🚀 Starting Travel Agent FastAPI Server..." -ForegroundColor Green
Write-Host "=" * 50

# Navigate to project directory
Set-Location "C:\Users\PC\Desktop\journita-travel-agent"

# Check if virtual environment exists
if (Test-Path ".\.venv\Scripts\uvicorn.exe") {
    Write-Host "✅ Virtual environment found!" -ForegroundColor Green
    $uvicornPath = ".\.venv\Scripts\uvicorn.exe"
} else {
    Write-Host "❌ Virtual environment not found!" -ForegroundColor Red
    exit 1
}

# Display server options
Write-Host ""
Write-Host "🎯 Server Options:" -ForegroundColor Yellow
Write-Host "1. Production Server (Smart mock/real mode)"
Write-Host "2. Mock Server (Demo mode only)"
Write-Host "3. Minimal Server (Testing)"
Write-Host ""

$choice = Read-Host "Select server type (1-3) [1]"
if ([string]::IsNullOrEmpty($choice)) { $choice = "1" }

switch ($choice) {
    "1" { 
        Write-Host "🚀 Starting Production Server..." -ForegroundColor Green
        Write-Host "📱 Server will be at: http://localhost:8000" -ForegroundColor Cyan
        Write-Host "📚 API docs at: http://localhost:8000/docs" -ForegroundColor Cyan
        & $uvicornPath production_server:app --host 0.0.0.0 --port 8000 --reload --log-level info
    }
    "2" { 
        Write-Host "🎭 Starting Mock Server..." -ForegroundColor Green
        Write-Host "📱 Server will be at: http://localhost:8000" -ForegroundColor Cyan
        & $uvicornPath streaming_server:app --host 0.0.0.0 --port 8000 --reload --log-level info
    }
    "3" { 
        Write-Host "🧪 Starting Minimal Server..." -ForegroundColor Green
        Write-Host "📱 Server will be at: http://localhost:8000" -ForegroundColor Cyan
        & $uvicornPath minimal_server:app --host 0.0.0.0 --port 8000 --reload --log-level info
    }
    default { 
        Write-Host "❌ Invalid choice. Starting Production Server..." -ForegroundColor Yellow
        Write-Host "📱 Server will be at: http://localhost:8000" -ForegroundColor Cyan
        & $uvicornPath production_server:app --host 0.0.0.0 --port 8000 --reload --log-level info
    }
}
