#!/usr/bin/env python3

import asyncio
import uuid
import json
import os
from typing import AsyncGenerator, Optional
from datetime import datetime

print("🚀 Starting Journita Travel Agent for GCP...")

try:
    from dotenv import load_dotenv
    
    from fastapi import FastAPI, HTTPException, BackgroundTasks
    from fastapi.middleware.cors import CORSMiddleware
    from fastapi.responses import StreamingResponse, FileResponse
    from fastapi.staticfiles import StaticFiles
    from pydantic import BaseModel, Field
    import uvicorn
    
    from langchain_core.messages import HumanMessage
    
    # Load environment variables
    load_dotenv()
    
    # Check if we have real API keys
    HAS_GEMINI = bool(os.getenv('GOOGLE_API_KEY'))
    HAS_SERPAPI = bool(os.getenv('SERPAPI_API_KEY'))
    REAL_INTEGRATION = HAS_GEMINI and HAS_SERPAPI
    
    print(f"🔑 Gemini API: {'✅ Available' if HAS_GEMINI else '❌ Missing'}")
    print(f"🔑 SerpAPI: {'✅ Available' if HAS_SERPAPI else '❌ Missing'}")
    print(f"🤖 Real Integration: {'✅ Enabled' if REAL_INTEGRATION else '⚠️ Mock Mode'}")
    
    # Try to import and create the real graph
    real_graph = None
    if REAL_INTEGRATION:
        try:
            from agents.graph import create_graph
            real_graph = create_graph()
            print("✅ Real LangGraph agent loaded!")
        except Exception as e:
            print(f"⚠️ Real agent failed, falling back to mock: {e}")
            REAL_INTEGRATION = False
    
    # Create FastAPI app
    app = FastAPI(
        title="🌍 Journita Travel Agent API ✈️",
        version="1.0.0",
        description=f"""
Production-ready Travel Agent API deployed on Google Cloud Platform.

**Mode**: {'🤖 Real AI Agent' if REAL_INTEGRATION else '🎭 Mock Mode'}
**Features**: Real-time streaming, AI-powered travel search, responsive frontend
**Integration**: LangGraph + Gemini 2.0 Flash + SerpAPI
        """.strip()
    )
    
    # Configure CORS for production
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],  # In production, specify your domain
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )
    
    # Serve static files (frontend)
    try:
        app.mount("/static", StaticFiles(directory="static"), name="static")
    except:
        pass  # Skip if static directory doesn't exist
    
    # Models
    class TravelQuery(BaseModel):
        query: str = Field(..., description="Your travel query")
        thread_id: Optional[str] = Field(None, description="Thread ID for conversation")
        use_real_agent: bool = Field(True, description="Use real AI agent")
    
    class ChatMessage(BaseModel):
        message: str = Field(..., description="Chat message")
    
    class TravelResponse(BaseModel):
        response: str
        thread_id: str
        timestamp: str
        mode: str = Field(description="'real' or 'mock'")
        processing_time: Optional[float] = None
    
    # Mock data for fallback
    MOCK_FLIGHTS = [
        {"airline": "British Airways", "route": "London → Paris", "price": "€150", "duration": "1h 25m", "times": "10:30 → 13:55"},
        {"airline": "Air France", "route": "London → Paris", "price": "€175", "duration": "1h 30m", "times": "14:15 → 17:45"},
        {"airline": "EasyJet", "route": "London → Paris", "price": "€89", "duration": "1h 35m", "times": "07:45 → 11:20"},
    ]
    
    MOCK_HOTELS = [
        {"name": "Hotel Paris Center", "location": "1st Arr.", "price": "€120/night", "rating": "4.5⭐", "features": "WiFi, Breakfast, AC"},
        {"name": "Boutique Montmartre", "location": "18th Arr.", "price": "€95/night", "rating": "4.2⭐", "features": "WiFi, City View"},
        {"name": "Luxury Champs-Élysées", "location": "8th Arr.", "price": "€280/night", "rating": "4.8⭐", "features": "Spa, Concierge"},
    ]
    
    # Real agent functions
    async def query_real_agent(query: str, thread_id: str) -> str:
        """Query the real LangGraph agent"""
        try:
            messages = [HumanMessage(content=query)]
            config = {'configurable': {'thread_id': thread_id}}
            
            result = real_graph.invoke({'messages': messages}, config=config)
            
            if result and 'messages' in result and result['messages']:
                return result['messages'][-1].content
            else:
                return "I apologize, but I couldn't process your request at the moment."
                
        except Exception as e:
            print(f"Real agent error: {e}")
            raise HTTPException(status_code=500, detail=f"Agent processing failed: {str(e)}")
    
    async def stream_real_agent(query: str, thread_id: str) -> AsyncGenerator[str, None]:
        """Stream from the real LangGraph agent"""
        try:
            messages = [HumanMessage(content=query)]
            config = {'configurable': {'thread_id': thread_id}}
            
            yield f"data: 🤖 Processing with real AI agent...\n\n"
            await asyncio.sleep(0.5)
            
            result = real_graph.invoke({'messages': messages}, config=config)
            
            if result and 'messages' in result and result['messages']:
                response = result['messages'][-1].content
                
                # Simulate streaming by breaking response into chunks
                words = response.split()
                chunk_size = 5
                
                for i in range(0, len(words), chunk_size):
                    chunk = ' '.join(words[i:i+chunk_size])
                    yield f"data: {chunk} "
                    await asyncio.sleep(0.3)
                
                yield f"data: \n\n✅ Real agent response complete!\n\n"
            else:
                yield f"data: ❌ No response from agent\n\n"
                
            yield "data: [DONE]\n\n"
            
        except Exception as e:
            yield f"data: ❌ Error: {str(e)}\n\n"
            yield "data: [DONE]\n\n"
    
    # Mock agent functions
    def generate_mock_response(query: str) -> str:
        """Generate mock response based on query"""
        query_lower = query.lower()
        
        response_parts = ["🎭 **MOCK TRAVEL SEARCH RESULTS**", ""]
        
        if "flight" in query_lower or "fly" in query_lower:
            response_parts.extend(["✈️ **FLIGHT OPTIONS:**", ""])
            for i, flight in enumerate(MOCK_FLIGHTS, 1):
                response_parts.extend([
                    f"{i}. **{flight['airline']}** - {flight['price']}",
                    f"   {flight['route']} ({flight['duration']})",
                    f"   {flight['times']}", ""
                ])
        
        if "hotel" in query_lower or "accommodation" in query_lower:
            response_parts.extend(["🏨 **HOTEL OPTIONS:**", ""])
            for i, hotel in enumerate(MOCK_HOTELS, 1):
                response_parts.extend([
                    f"{i}. **{hotel['name']}** - {hotel['price']}",
                    f"   📍 {hotel['location']} | {hotel['rating']}",
                    f"   🛎️ {hotel['features']}", ""
                ])
        
        if not any(keyword in query_lower for keyword in ['flight', 'fly', 'hotel', 'accommodation']):
            response_parts = [
                "🤖 **Travel Assistant Ready!**", "",
                "I can help you find:",
                "✈️ Flights between any cities",
                "🏨 Hotels and accommodations", 
                "🎯 Complete travel packages", "",
                "Try asking: 'Find me flights from London to Paris and hotels'"
            ]
        
        response_parts.extend(["", "---", "⚠️ This is a mock response. Enable real integration with API keys."])
        
        return "\n".join(response_parts)
    
    async def stream_mock_response(query: str, thread_id: str) -> AsyncGenerator[str, None]:
        """Stream mock response"""
        steps = [
            "🎭 Starting mock travel search...",
            "🔍 Analyzing your request...",
            "✈️ Searching flight databases...",
            "🏨 Checking hotel availability...",
            "📊 Comparing prices and options...",
            "✅ Preparing results..."
        ]
        
        for step in steps:
            yield f"data: {step}\n\n"
            await asyncio.sleep(0.8)
        
        # Stream the actual response
        response = generate_mock_response(query)
        lines = response.split('\n')
        
        for line in lines:
            if line.strip():
                yield f"data: {line}\n"
            else:
                yield f"data: \n"
            await asyncio.sleep(0.2)
        
        yield f"data: \n\n🆔 Thread: {thread_id}\n\n"
        yield "data: [DONE]\n\n"
    
    # API Endpoints
    @app.get("/")
    async def root():
        """Serve the frontend"""
        try:
            return FileResponse("frontend_8002.html")
        except:
            return {
                "message": "🌍 Journita Travel Agent API ✈️",
                "version": "1.0.0",
                "mode": "Real AI Agent" if REAL_INTEGRATION else "Mock Mode",
                "frontend": "Add frontend_8002.html to serve the chat interface",
                "endpoints": {
                    "health": "/health",
                    "docs": "/docs", 
                    "chat": "/chat",
                    "chat_stream": "/chat/stream",
                    "status": "/status"
                }
            }
    
    @app.get("/health")
    async def health_check():
        return {
            "status": "healthy",
            "mode": "real" if REAL_INTEGRATION else "mock",
            "timestamp": datetime.now().isoformat(),
            "service": "journita-travel-agent",
            "version": "1.0.0"
        }
    
    @app.get("/status")
    async def status():
        return {
            "status": "operational",
            "mode": "real" if REAL_INTEGRATION else "mock",
            "timestamp": datetime.now().isoformat(),
            "capabilities": {
                "real_agent": REAL_INTEGRATION,
                "mock_fallback": True,
                "streaming": True,
                "gemini_integration": HAS_GEMINI,
                "serpapi_integration": HAS_SERPAPI
            },
            "deployment": "Google Cloud Platform"
        }
    
    @app.post("/chat")
    async def chat(chat_message: ChatMessage):
        """Simple chat endpoint"""
        thread_id = str(uuid.uuid4())
        
        try:
            if REAL_INTEGRATION:
                response = await query_real_agent(chat_message.message, thread_id)
                mode = "real"
            else:
                await asyncio.sleep(1)
                response = generate_mock_response(chat_message.message)
                mode = "mock"
            
            return {
                "response": response,
                "thread_id": thread_id,
                "timestamp": datetime.now().isoformat(),
                "mode": mode
            }
            
        except Exception as e:
            raise HTTPException(status_code=500, detail=str(e))

    @app.post("/chat/stream")
    async def chat_stream(chat_message: ChatMessage):
        """Streaming chat endpoint"""
        thread_id = str(uuid.uuid4())
        
        if REAL_INTEGRATION:
            generator = stream_real_agent(chat_message.message, thread_id)
        else:
            generator = stream_mock_response(chat_message.message, thread_id)
        
        return StreamingResponse(
            generator,
            media_type="text/plain",
            headers={
                "Cache-Control": "no-cache",
                "Connection": "keep-alive",
                "Access-Control-Allow-Origin": "*",
                "X-Thread-ID": thread_id,
                "X-Mode": "real" if REAL_INTEGRATION else "mock"
            }
        )
    
    print("✅ Journita Travel Agent API Ready for GCP!")
    print(f"🤖 Mode: {'Real AI Agent' if REAL_INTEGRATION else 'Mock Data'}")

    if __name__ == "__main__":
        # Get port from environment (Cloud Run uses PORT env var)
        port = int(os.getenv("PORT", 8080))
        host = os.getenv("HOST", "0.0.0.0")
        
        print(f"\n🚀 Starting server on {host}:{port}")
        print("🌐 Frontend: Available at root URL")
        print("📚 Docs: /docs")
        print("❤️ Health: /health")
        
        uvicorn.run(
            app,
            host=host,
            port=port,
            log_level="info"
        )
        
except Exception as e:
    print(f"❌ STARTUP ERROR: {e}")
    import traceback
    traceback.print_exc()
