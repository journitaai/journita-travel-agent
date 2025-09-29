@echo off
echo 🚀 Starting Travel Agent FastAPI Server...
echo =====================================

cd "C:\Users\PC\Desktop\journita-travel-agent"

echo ✅ Activating virtual environment...
call .venv\Scripts\activate.bat

echo 🚀 Starting Production Server with uvicorn...
echo 📱 Server will be available at: http://localhost:8000
echo 📚 API docs at: http://localhost:8000/docs
echo 🔄 Auto-reload enabled for development
echo.
echo Press Ctrl+C to stop the server
echo.

uvicorn production_server:app --host 0.0.0.0 --port 8000 --reload --log-level info

pause
