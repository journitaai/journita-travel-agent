@echo off
echo 🚀 Starting Journita Travel Agent Backend (API)...
echo.
echo Backend API will run on: http://localhost:8000
echo Frontend React app should run on: http://localhost:3000  
echo.

cd /d "C:\Users\PC\Desktop\journita-travel-agent"

echo 📁 Current directory: %CD%
echo.

echo 🔧 Activating virtual environment...
call .venv\Scripts\activate.bat

echo.
echo 🌟 Starting FastAPI server with uvicorn...
echo 📱 Backend will be available at: http://localhost:8000
echo 📚 API docs will be at: http://localhost:8000/docs
echo.
echo ⏹️  Press Ctrl+C to stop the server
echo.

uvicorn production_server:app --reload --host 0.0.0.0 --port 8000

pause
