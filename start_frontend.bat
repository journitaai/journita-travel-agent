@echo off
echo 🚀 Starting Journita Travel Agent Frontend (React)...
echo.
echo Make sure Node.js is installed!
echo Backend should be running on: http://localhost:8000
echo Frontend will run on: http://localhost:3000
echo.

cd /d "C:\Users\PC\Desktop\journita-travel-agent\frontend"

echo 📁 Current directory: %CD%
echo.

echo 📦 Installing dependencies...
call npm install
echo.

if %ERRORLEVEL% NEQ 0 (
    echo ❌ Failed to install dependencies
    echo.
    echo Make sure Node.js and npm are installed:
    echo https://nodejs.org/
    echo.
    pause
    exit /b 1
)

echo ✅ Dependencies installed!
echo.
echo 🌐 Starting React development server...
echo.
call npm start

pause
