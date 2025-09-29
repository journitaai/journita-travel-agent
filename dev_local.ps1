# Local Development Scripts

Write-Host "🔧 Journita Travel Agent - Local Development Helper" -ForegroundColor Green
Write-Host ""

Write-Host "Please choose an option:" -ForegroundColor Cyan
Write-Host "1. 🚀 Start Backend Server (Port 8002)" -ForegroundColor Yellow
Write-Host "2. 🌐 Start Frontend Development" -ForegroundColor Yellow
Write-Host "3. 📦 Start Both (Backend + Frontend)" -ForegroundColor Yellow
Write-Host "4. 🔧 Setup Development Environment" -ForegroundColor Yellow
Write-Host "5. 📋 Check Environment Status" -ForegroundColor Yellow
Write-Host ""

$choice = Read-Host "Enter your choice (1-5)"

switch ($choice) {
    "1" {
        Write-Host "🚀 Starting Backend Server..." -ForegroundColor Cyan
        
        # Check if poetry is installed
        try {
            poetry --version | Out-Null
            Write-Host "✅ Poetry found" -ForegroundColor Green
        } catch {
            Write-Host "❌ Poetry not found. Installing via pip..." -ForegroundColor Yellow
            pip install poetry
        }
        
        # Install dependencies
        Write-Host "📦 Installing Python dependencies..." -ForegroundColor Yellow
        poetry install
        
        # Check environment variables
        if (-not $env:GOOGLE_API_KEY) {
            Write-Host "⚠️ GOOGLE_API_KEY not set" -ForegroundColor Yellow
            $googleKey = Read-Host "Enter your Google API Key (or press Enter to skip)"
            if ($googleKey) {
                $env:GOOGLE_API_KEY = $googleKey
            }
        }
        
        if (-not $env:SERPAPI_API_KEY) {
            Write-Host "⚠️ SERPAPI_API_KEY not set" -ForegroundColor Yellow
            $serpKey = Read-Host "Enter your SerpAPI Key (or press Enter to skip)"
            if ($serpKey) {
                $env:SERPAPI_API_KEY = $serpKey
            }
        }
        
        Write-Host ""
        Write-Host "🎯 Backend will be available at:" -ForegroundColor Green
        Write-Host "http://localhost:8002" -ForegroundColor Blue
        Write-Host "http://localhost:8002/docs (API Documentation)" -ForegroundColor Blue
        Write-Host ""
        Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
        Write-Host ""
        
        # Start backend
        poetry run python backend_server.py
    }
    
    "2" {
        Write-Host "🌐 Starting Frontend Development..." -ForegroundColor Cyan
        
        # Check if Node.js is installed
        try {
            $nodeVersion = node --version
            Write-Host "✅ Node.js found: $nodeVersion" -ForegroundColor Green
        } catch {
            Write-Host "❌ Node.js not found. Please install from:" -ForegroundColor Red
            Write-Host "https://nodejs.org/en/download/" -ForegroundColor Blue
            Read-Host "Press Enter to exit"
            exit 1
        }
        
        # Navigate to frontend directory
        if (Test-Path "frontend") {
            Set-Location frontend
            
            # Install dependencies
            Write-Host "📦 Installing Node dependencies..." -ForegroundColor Yellow
            npm install
            
            Write-Host ""
            Write-Host "🎯 Frontend will be available at:" -ForegroundColor Green
            Write-Host "http://localhost:3000" -ForegroundColor Blue
            Write-Host ""
            Write-Host "⚠️ Make sure backend is running on port 8002!" -ForegroundColor Yellow
            Write-Host "Press Ctrl+C to stop the dev server" -ForegroundColor Yellow
            Write-Host ""
            
            # Start frontend
            npm start
        } else {
            Write-Host "❌ Frontend directory not found" -ForegroundColor Red
            Write-Host "📄 Using interim frontend at: http://localhost:8002" -ForegroundColor Blue
        }
    }
    
    "3" {
        Write-Host "📦 Starting Both Backend and Frontend..." -ForegroundColor Cyan
        Write-Host ""
        Write-Host "This will open two terminal windows:" -ForegroundColor Yellow
        Write-Host "1. Backend server on port 8002" -ForegroundColor Blue
        Write-Host "2. Frontend dev server on port 3000" -ForegroundColor Blue
        Write-Host ""
        
        $confirm = Read-Host "Continue? (y/N)"
        if ($confirm -ne "y" -and $confirm -ne "Y") {
            Write-Host "❌ Cancelled" -ForegroundColor Red
            exit 0
        }
        
        # Start backend in new terminal
        Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD'; .\dev_local.ps1; Write-Host 'Choose option 1 for backend'"
        
        # Wait a moment
        Start-Sleep -Seconds 2
        
        # Start frontend in new terminal
        if (Test-Path "frontend") {
            Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD'; .\dev_local.ps1; Write-Host 'Choose option 2 for frontend'"
        } else {
            Write-Host "⚠️ Frontend directory not found. Only backend started." -ForegroundColor Yellow
            Write-Host "📄 Access frontend at: http://localhost:8002" -ForegroundColor Blue
        }
        
        Write-Host "✅ Servers starting in separate windows..." -ForegroundColor Green
    }
    
    "4" {
        Write-Host "🔧 Setting up Development Environment..." -ForegroundColor Cyan
        
        # Check Python
        try {
            $pythonVersion = python --version
            Write-Host "✅ Python found: $pythonVersion" -ForegroundColor Green
        } catch {
            Write-Host "❌ Python not found. Please install Python 3.9+" -ForegroundColor Red
        }
        
        # Check Poetry
        try {
            $poetryVersion = poetry --version
            Write-Host "✅ Poetry found: $poetryVersion" -ForegroundColor Green
        } catch {
            Write-Host "❌ Poetry not found. Installing..." -ForegroundColor Yellow
            pip install poetry
        }
        
        # Check Node.js
        try {
            $nodeVersion = node --version
            Write-Host "✅ Node.js found: $nodeVersion" -ForegroundColor Green
        } catch {
            Write-Host "❌ Node.js not found. Please install from:" -ForegroundColor Red
            Write-Host "https://nodejs.org/en/download/" -ForegroundColor Blue
        }
        
        # Install Python dependencies
        Write-Host ""
        Write-Host "📦 Installing Python dependencies..." -ForegroundColor Yellow
        poetry install
        
        # Setup frontend if exists
        if (Test-Path "frontend") {
            Write-Host "📦 Installing Frontend dependencies..." -ForegroundColor Yellow
            Set-Location frontend
            npm install
            Set-Location ..
        }
        
        # Check environment variables
        Write-Host ""
        Write-Host "🔑 Environment Variables:" -ForegroundColor Cyan
        if ($env:GOOGLE_API_KEY) {
            Write-Host "✅ GOOGLE_API_KEY is set" -ForegroundColor Green
        } else {
            Write-Host "❌ GOOGLE_API_KEY not set" -ForegroundColor Red
            Write-Host "Set it with: `$env:GOOGLE_API_KEY='your-key-here'" -ForegroundColor Blue
        }
        
        if ($env:SERPAPI_API_KEY) {
            Write-Host "✅ SERPAPI_API_KEY is set" -ForegroundColor Green
        } else {
            Write-Host "❌ SERPAPI_API_KEY not set" -ForegroundColor Red
            Write-Host "Set it with: `$env:SERPAPI_API_KEY='your-key-here'" -ForegroundColor Blue
        }
        
        Write-Host ""
        Write-Host "🎉 Setup complete!" -ForegroundColor Green
    }
    
    "5" {
        Write-Host "📋 Checking Environment Status..." -ForegroundColor Cyan
        Write-Host ""
        
        # Check Python
        try {
            $pythonVersion = python --version
            Write-Host "✅ Python: $pythonVersion" -ForegroundColor Green
        } catch {
            Write-Host "❌ Python: Not found" -ForegroundColor Red
        }
        
        # Check Poetry
        try {
            $poetryVersion = poetry --version
            Write-Host "✅ Poetry: $poetryVersion" -ForegroundColor Green
        } catch {
            Write-Host "❌ Poetry: Not found" -ForegroundColor Red
        }
        
        # Check Node.js
        try {
            $nodeVersion = node --version
            $npmVersion = npm --version
            Write-Host "✅ Node.js: $nodeVersion" -ForegroundColor Green
            Write-Host "✅ npm: $npmVersion" -ForegroundColor Green
        } catch {
            Write-Host "❌ Node.js: Not found" -ForegroundColor Red
        }
        
        # Check directories
        Write-Host ""
        Write-Host "📁 Project Structure:" -ForegroundColor Cyan
        if (Test-Path "pyproject.toml") {
            Write-Host "✅ pyproject.toml found" -ForegroundColor Green
        } else {
            Write-Host "❌ pyproject.toml not found" -ForegroundColor Red
        }
        
        if (Test-Path "backend_server.py") {
            Write-Host "✅ backend_server.py found" -ForegroundColor Green
        } else {
            Write-Host "❌ backend_server.py not found" -ForegroundColor Red
        }
        
        if (Test-Path "frontend") {
            Write-Host "✅ frontend/ directory found" -ForegroundColor Green
        } else {
            Write-Host "⚠️ frontend/ directory not found (using interim HTML)" -ForegroundColor Yellow
        }
        
        # Check environment variables
        Write-Host ""
        Write-Host "🔑 Environment Variables:" -ForegroundColor Cyan
        if ($env:GOOGLE_API_KEY) {
            $maskedKey = $env:GOOGLE_API_KEY.Substring(0, [Math]::Min(10, $env:GOOGLE_API_KEY.Length)) + "..."
            Write-Host "✅ GOOGLE_API_KEY: $maskedKey" -ForegroundColor Green
        } else {
            Write-Host "❌ GOOGLE_API_KEY: Not set" -ForegroundColor Red
        }
        
        if ($env:SERPAPI_API_KEY) {
            $maskedKey = $env:SERPAPI_API_KEY.Substring(0, [Math]::Min(10, $env:SERPAPI_API_KEY.Length)) + "..."
            Write-Host "✅ SERPAPI_API_KEY: $maskedKey" -ForegroundColor Green
        } else {
            Write-Host "❌ SERPAPI_API_KEY: Not set" -ForegroundColor Red
        }
        
        # Check ports
        Write-Host ""
        Write-Host "🌐 Port Status:" -ForegroundColor Cyan
        try {
            $port8002 = Get-NetTCPConnection -LocalPort 8002 -ErrorAction SilentlyContinue
            if ($port8002) {
                Write-Host "🟢 Port 8002: In use (Backend running)" -ForegroundColor Green
            } else {
                Write-Host "🔴 Port 8002: Available" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "🔴 Port 8002: Available" -ForegroundColor Yellow
        }
        
        try {
            $port3000 = Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue
            if ($port3000) {
                Write-Host "🟢 Port 3000: In use (Frontend running)" -ForegroundColor Green
            } else {
                Write-Host "🔴 Port 3000: Available" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "🔴 Port 3000: Available" -ForegroundColor Yellow
        }
    }
    
    default {
        Write-Host "❌ Invalid choice" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Read-Host "Press Enter to exit"
