# 🚀 ONE-LINER COMMANDS TO START SERVER

## **Production Server (Recommended)**
```powershell
cd "C:\Users\PC\Desktop\journita-travel-agent"; .\.venv\Scripts\activate; uvicorn production_server:app --host 0.0.0.0 --port 8000 --reload
```

## **Mock Server (Demo Mode)**
```powershell
cd "C:\Users\PC\Desktop\journita-travel-agent"; .\.venv\Scripts\activate; uvicorn streaming_server:app --host 0.0.0.0 --port 8000 --reload
```

## **Alternative - Full Path Method (works from anywhere)**
```powershell
C:\Users\PC\Desktop\journita-travel-agent\.venv\Scripts\uvicorn production_server:app --host 0.0.0.0 --port 8000 --reload
```

## **After Server Starts:**
- 📱 **Main API**: http://localhost:8000
- 📚 **API Docs**: http://localhost:8000/docs  
- 📊 **Status**: http://localhost:8000/status
- 🎯 **Demo Client**: Open `demo_client.html` in browser

## **Quick Test:**
```powershell
# Test if server is running
Invoke-WebRequest http://localhost:8000/health
```

## **Stop Server:**
Press `Ctrl+C` in the terminal where uvicorn is running
