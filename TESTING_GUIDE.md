# 🧪 Testing Guide: Backend + Frontend Separately

## 🚀 Setup Instructions

### 1. **Start the Backend Server**

**Option A: Using PowerShell Script**
```powershell
.\start_backend.ps1
```

**Option B: Using Batch File**
```cmd
start_backend.bat
```

**Option C: Manual Command**
```powershell
.\.venv\Scripts\uvicorn.exe production_server:app --reload --host 0.0.0.0 --port 8000
```

### 2. **Open the Standalone Frontend**

**Option A: Double-click the file**
- Open `standalone_frontend.html` in your web browser

**Option B: File URL**
- Navigate to: `file:///c:/Users/PC/Desktop/journita-travel-agent/standalone_frontend.html`

## 🔧 Testing Steps

### Step 1: Verify Backend is Running
1. Backend should show:
   ```
   🚀 Starting Production Travel Agent API...
   🔑 Gemini API: ✅ Available
   🔑 SerpAPI: ✅ Available
   🤖 Real Integration: ✅ Enabled
   ✅ Production Travel Agent API Ready!
   ```

2. Check these URLs in browser:
   - **Health Check**: http://localhost:8000/health
   - **API Docs**: http://localhost:8000/docs
   - **Root Info**: http://localhost:8000/

### Step 2: Test Frontend Connection
1. Open `standalone_frontend.html` in browser
2. Check connection status (should show green "Connected")
3. Verify backend URL shows: `http://localhost:8000`
4. Check that input field is enabled

### Step 3: Test AI Conversation
1. Try these example queries:
   - "Find flights from NYC to Paris"
   - "I need a hotel in London"
   - "Plan a trip to Tokyo"

2. Verify streaming responses work in real-time
3. Check debug console for connection logs

## 🐛 Troubleshooting

### Backend Issues:
- **Port 8000 in use**: Change port in command
- **Virtual env not found**: Run `poetry install`
- **API keys missing**: Check `.env` file

### Frontend Issues:
- **Can't connect**: Verify backend URL in frontend
- **CORS errors**: Backend has CORS enabled for all origins
- **No streaming**: Check browser developer console

### Connection Test:
```javascript
// Test in browser console
fetch('http://localhost:8000/health')
  .then(r => r.json())
  .then(data => console.log('Backend status:', data));
```

## 📱 Available Endpoints

| Endpoint | Purpose | Method |
|----------|---------|--------|
| `/health` | Health check | GET |
| `/status` | Detailed status | GET |
| `/chat/stream` | AI chat (streaming) | POST |
| `/docs` | API documentation | GET |
| `/demo` | Integrated frontend | GET |

## 🎯 Testing Scenarios

### Scenario 1: Flight Search
```json
{
  "message": "Find flights from New York to London for next week",
  "thread_id": "test_001"
}
```

### Scenario 2: Hotel Search
```json
{
  "message": "I need a 4-star hotel in Paris for 3 nights",
  "thread_id": "test_002"
}
```

### Scenario 3: Complex Travel Planning
```json
{
  "message": "Plan a 10-day trip to Japan from Los Angeles, including flights and hotels",
  "thread_id": "test_003"
}
```

## 📊 Expected Response Format

**Streaming Response:**
```
data: I found several great options for your trip!

data: **Flights from NYC to London:**
data: • British Airways - $450
data: • Virgin Atlantic - $475

data: [DONE]
```

## ✅ Success Indicators

- ✅ Backend starts without errors
- ✅ Frontend connects successfully 
- ✅ Green connection status
- ✅ Streaming responses work
- ✅ AI provides travel recommendations
- ✅ Debug console shows successful requests

## 🌐 For Render Deployment

When deploying to Render, update the frontend's default backend URL from:
```javascript
let API_BASE = 'http://localhost:8000';
```

To:
```javascript
let API_BASE = 'https://your-app.onrender.com';
```

Your backend and frontend are now running separately and ready for testing! 🎉
