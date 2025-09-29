# 🚀 FastAPI Server Quick Start Guide

## **Method 1: Using Startup Scripts (Easiest)**

### Windows PowerShell:
```powershell
.\start_server.ps1
```

### Windows Command Prompt:
```cmd
start_server.bat
```

## **Method 2: Manual Uvicorn Commands**

### Step 1: Navigate and Activate
```powershell
cd "C:\Users\PC\Desktop\journita-travel-agent"
.\.venv\Scripts\activate
```

### Step 2: Choose Your Server

#### Production Server (Recommended for Demo):
```powershell
uvicorn production_server:app --host 0.0.0.0 --port 8000 --reload
```
- ✅ Smart mock/real mode switching
- ✅ Full error handling
- ✅ Auto-detects API key issues

#### Mock Demo Server:
```powershell
uvicorn streaming_server:app --host 0.0.0.0 --port 8000 --reload
```
- ✅ Fast startup
- ✅ No API keys needed
- ✅ Perfect for demos

#### Minimal Test Server:
```powershell
uvicorn minimal_server:app --host 0.0.0.0 --port 8000 --reload
```
- ✅ Basic endpoints only
- ✅ Quick testing

## **Server Access Points**

Once started, access your server at:
- **Main API**: http://localhost:8000
- **Interactive Docs**: http://localhost:8000/docs
- **API Status**: http://localhost:8000/status  
- **Health Check**: http://localhost:8000/health

## **Demo Client**

Open in browser: `demo_client.html`
- Professional interface
- Pre-loaded scenarios
- Real-time streaming demo
- Server monitoring

## **Uvicorn Parameters Reference**

```powershell
uvicorn [module:app] [options]
```

**Common Options:**
- `--host 0.0.0.0` - Accept connections from any IP
- `--port 8000` - Server port
- `--reload` - Auto-restart on code changes
- `--log-level info` - Detailed logging
- `--workers 4` - Multiple processes (production)
- `--access-log` - HTTP request logging

## **Troubleshooting**

### Server Won't Start:
1. Check if port 8000 is free: `netstat -ano | findstr :8000`
2. Try different port: `--port 8001`
3. Check virtual environment is activated

### API Key Issues:
- Production server automatically falls back to mock mode
- Check status at: http://localhost:8000/status
- Update keys in `.env` file

### Performance:
- Use `--workers 4` for production
- Remove `--reload` for production
- Use `--log-level warning` for production

## **Quick Demo Commands**

```powershell
# Start demo server
uvicorn production_server:app --port 8000 --reload

# In another terminal, test it:
curl http://localhost:8000/health

# Or open browser:
start http://localhost:8000/docs
```

**You're ready to demo!** 🎯
