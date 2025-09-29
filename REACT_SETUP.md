# Journita Travel Agent - React Frontend Setup

## 🎯 Overview

This project now has a **React TypeScript frontend** that consumes the FastAPI backend. All redundant HTML files have been removed and the backend has been updated to serve only API endpoints.

## 📂 Project Structure

```
journita-travel-agent/
├── agents/                 # AI Agent logic (LangGraph + Gemini)
├── frontend/              # React TypeScript frontend
│   ├── src/
│   │   ├── components/    # React components
│   │   ├── services/      # API client
│   │   └── ...
│   ├── package.json
│   └── README.md
├── production_server.py   # FastAPI backend (API only)
├── start_backend.bat      # Backend startup script
├── start_frontend.bat     # Frontend startup script
└── ...
```

## 🚀 Quick Start

### Prerequisites

1. **Python 3.8+** with dependencies installed
2. **Node.js 16+** and npm
3. **API Keys** (see backend setup)

### Step 1: Start Backend (API)

**Option A - Using Script:**
```bash
# Windows
start_backend.bat

# Or PowerShell
.\start_backend.ps1
```

**Option B - Manual:**
```bash
cd journita-travel-agent
python production_server.py
```

The backend API will run on **http://localhost:8000**

### Step 2: Start Frontend (React)

**Option A - Using Script:**
```bash
# Windows
start_frontend.bat

# Or PowerShell  
.\start_frontend.ps1
```

**Option B - Manual:**
```bash
cd frontend
npm install
npm start
```

The React frontend will run on **http://localhost:3000**

## 🔧 Configuration

### Backend Configuration

The backend uses environment variables for API keys:

```env
GOOGLE_API_KEY=your_gemini_api_key
SERPAPI_API_KEY=your_serpapi_key
```

### Frontend Configuration

The React app connects to the backend via:

```env
# frontend/.env
REACT_APP_API_URL=http://localhost:8000
```

## 🌐 API Endpoints

The backend now provides clean API endpoints:

- `GET /` - API information
- `GET /health` - Health check
- `POST /chat` - Simple chat endpoint
- `POST /chat/stream` - Streaming chat (used by React)
- `GET /docs` - API documentation

## ✨ Features

### React Frontend Features:
- **Real-time streaming chat** with the AI agent
- **Connection status monitoring**
- **Responsive design** with modern UI
- **TypeScript support** for type safety
- **Example prompts** to get started quickly

### Backend Features:
- **Gemini 2.0 Flash integration** for AI responses
- **Streaming responses** for real-time interaction
- **Mock mode fallback** when API keys aren't available
- **CORS enabled** for frontend integration
- **Clean API design** focused on React consumption

## 🔍 Development Workflow

1. **Start Backend First**: Run the FastAPI server
2. **Start Frontend**: Run the React development server
3. **Test Integration**: Frontend will automatically connect to backend
4. **Monitor Logs**: Check both terminal windows for errors

## 🐛 Troubleshooting

### Frontend Issues:
- **Node.js not found**: Install from https://nodejs.org/
- **npm install fails**: Check Node.js version (16+ required)
- **Connection failed**: Ensure backend is running on port 8000

### Backend Issues:
- **Import errors**: Check Python dependencies with `pip install -r requirements.txt`
- **API key warnings**: Add API keys to .env file for full functionality
- **Port conflicts**: Change port in production_server.py if needed

## 📱 Usage

1. Open **http://localhost:3000** in your browser
2. Wait for the connection status to show "Connected to backend"
3. Start chatting with the AI travel agent:
   - "Find flights from New York to Paris"
   - "I need a hotel in Tokyo for 3 nights"
   - "Plan a 5-day itinerary for Rome"

## 🎨 UI Features

- **Modern gradient design** with purple theme
- **Real-time typing indicators** during AI responses
- **Message bubbles** with timestamps
- **Responsive layout** for mobile and desktop
- **Example prompts** for quick testing

## 🚀 Deployment

For production deployment:

1. **Backend**: Deploy FastAPI app to your preferred platform
2. **Frontend**: Build React app with `npm run build`
3. **Environment**: Update REACT_APP_API_URL to your backend URL

## 📝 Notes

- All redundant HTML frontend files have been removed
- Backend now serves only API endpoints (no HTML)
- React app handles all frontend functionality
- Streaming responses work seamlessly with the React interface
- Connection monitoring helps debug API issues
