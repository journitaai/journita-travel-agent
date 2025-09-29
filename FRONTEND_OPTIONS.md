# 🚀 Quick Start Guide - Frontend Options

## Current Situation

You now have **THREE frontend options** to use with your travel agent:

## 📱 Option 1: Simple HTML Frontend (READY NOW!)

**✅ Already opened in your browser!**
- **File**: `simple_frontend.html`
- **No setup required** - works immediately
- **Features**: Full chat interface with streaming
- **Port**: Connects to backend on port 8001

## ⚛️ Option 2: React Frontend (Requires Node.js)

**📁 Location**: `/frontend` directory
**Requirements**: Node.js 16+ installed

### To use React frontend:
1. **Install Node.js**: https://nodejs.org/
2. **Run these commands**:
   ```bash
   cd frontend
   npm install
   npm start
   ```
3. **Opens**: http://localhost:3000

## 🔧 Option 3: Direct API Testing

You can also test the API directly:
- **API Docs**: http://localhost:8001/docs
- **Health Check**: http://localhost:8001/health
- **Status**: http://localhost:8001/status

## 🏃‍♂️ Getting Started RIGHT NOW

### Step 1: Start Backend
```bash
# Navigate to project
cd "C:\Users\PC\Desktop\journita-travel-agent"

# Start backend on port 8001
poetry run python server_8001.py
```

### Step 2: Use Frontend
The **simple_frontend.html** is already open in your browser!

If the connection shows "❌ Backend connection failed":
1. Make sure the backend is running (Step 1)
2. Check that it's running on port 8001
3. Refresh the page

## 🎯 Testing the Travel Agent

Try these example queries in the frontend:

1. **"Find flights from New York to Paris for next week"**
2. **"I need a hotel in Tokyo for 3 nights"**
3. **"Plan a 5-day itinerary for Rome"**
4. **"What's the best time to visit Thailand?"**

## 🐛 Troubleshooting

### Backend Issues:
- **Port 8000 busy**: Use `server_8001.py` (runs on port 8001)
- **Import errors**: Make sure you're using `poetry run python server_8001.py`
- **API keys**: Backend works in mock mode if no API keys

### Frontend Issues:
- **Connection failed**: Backend must be running first
- **Node.js not found**: Only needed for React frontend, not simple HTML
- **Port conflicts**: Simple frontend connects to port 8001

## 🎉 Quick Win

1. **Backend running?** Run: `poetry run python server_8001.py`
2. **Frontend open?** The simple_frontend.html should be open in your browser
3. **Test connection** - should show "✅ Connected to backend"
4. **Start chatting!** Ask about travel plans

The simple HTML frontend gives you full functionality without needing Node.js!
