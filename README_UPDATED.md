# 🌍 AI Travel Agent ✈️

A sophisticated travel planning agent built with LangGraph, powered by Google Gemini AI, and designed for production deployment via FastAPI streaming endpoints.

## 🚀 Features

- **Google Gemini AI**: Powered by Google's Gemini 1.5 Flash model for intelligent conversation
- **Intelligent Flight Search**: Find flights using real-time data via SerpAPI
- **Hotel Recommendations**: Discover hotels with ratings, prices, and amenities
- **Streaming Responses**: Real-time response streaming via FastAPI
- **LangGraph Studio**: Compatible with LangGraph Studio for visual workflow management
- **Production Ready**: Docker deployment with Redis and PostgreSQL
- **Thread Persistence**: Maintain conversation history across sessions

## 🏗️ Architecture

- **Backend**: FastAPI with streaming endpoints
- **AI Model**: Google Gemini 1.5 Flash via LangChain
- **Agent Framework**: LangGraph for workflow orchestration
- **Search Tools**: SerpAPI for real-time flight and hotel data
- **Deployment**: Docker Compose with Redis & PostgreSQL

## 🚀 Quick Start

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd journita-travel-agent
   ```

2. **Set up Python environment**
   ```bash
   poetry install --sync
   poetry shell
   ```

3. **Configure API keys**
   Create a `.env` file based on `.env.example`:
   ```bash
   GOOGLE_API_KEY=your_gemini_api_key_here
   SERPAPI_API_KEY=your_serpapi_key_here
   LANGSMITH_API_KEY=your_langsmith_api_key_here
   ```

4. **Start the server**
   ```bash
   uvicorn production_server:app --reload --host 0.0.0.0 --port 8000
   ```

   Or use the PowerShell script:
   ```bash
   .\start_server.ps1
   ```

## 🔧 Usage

### API Endpoints

1. **Streaming Chat** (`POST /chat/stream`)
   ```bash
   curl -X POST "http://localhost:8000/chat/stream" \
        -H "Content-Type: application/json" \
        -d '{"message": "Find flights from Madrid to Amsterdam Oct 1-7", "thread_id": "user123"}'
   ```

2. **Health Check** (`GET /health`)
   ```bash
   curl http://localhost:8000/health
   ```

### Example Travel Request
Send a message like:
> "I want to travel to Amsterdam from Madrid from October 1st to 7th. Find me flights and 4-star hotels."

The agent will:
1. 🔍 Search for flights using SerpAPI
2. 🏨 Find hotel recommendations  
3. 📊 Present options with ratings and prices
4. 💬 Stream responses in real-time

## 🐋 Docker Deployment

Start the full production environment:
```bash
docker-compose up -d
```

This launches:
- FastAPI server (port 8000)
- Redis for caching
- PostgreSQL for persistence

## 🎨 LangGraph Studio

The project is configured for LangGraph Studio deployment with `langgraph.json`. The graph structure supports visual workflow editing and monitoring.

## 📁 Project Structure

```
journita-travel-agent/
├── agents/
│   ├── agent.py          # Core agent logic
│   ├── graph.py          # LangGraph workflow definition
│   └── tools/            # Flight and hotel search tools
├── production_server.py  # FastAPI server with streaming
├── langgraph.json       # LangGraph Studio configuration
├── docker-compose.yml   # Multi-service deployment
├── pyproject.toml       # Dependencies and project config
└── start_server.ps1     # Quick start script
```

## 🔑 API Keys Required

1. **Google Gemini API**: Get from [Google AI Studio](https://makersuite.google.com/app/apikey)
2. **SerpAPI**: Get from [SerpAPI](https://serpapi.com/) for real-time search data
3. **LangSmith** (optional): For tracing and monitoring

## 🚀 Deployment Options

### Local Development
```bash
poetry shell
uvicorn production_server:app --reload
```

### Docker Production
```bash
docker-compose up -d
```

### LangGraph Studio
```bash
langgraph dev
```

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.
