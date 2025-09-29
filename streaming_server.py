#!/usr/bin/env python3

import asyncio
import uuid
import json
from typing import AsyncGenerator
from datetime import datetime

print("🚀 Starting Enhanced Travel Agent API with Streaming...")

try:
    from fastapi import FastAPI, HTTPException
    from fastapi.middleware.cors import CORSMiddleware
    from fastapi.responses import StreamingResponse
    from pydantic import BaseModel
    import uvicorn
    
    # Create FastAPI app
    app = FastAPI(
        title="Travel Agent API with Streaming", 
        version="2.0.0",
        description="Enhanced Travel Agent API with streaming responses and mock data"
    )
    
    # Configure CORS
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )
    
    # Models
    class TravelQuery(BaseModel):
        query: str
        thread_id: str = None
    
    class TravelResponse(BaseModel):
        response: str
        thread_id: str
        timestamp: str
    
    # Mock data for realistic responses
    MOCK_FLIGHTS = [
        {"airline": "British Airways", "from": "London", "to": "Paris", "price": "€150", "duration": "1h 25m", "departure": "10:30", "arrival": "13:55"},
        {"airline": "Air France", "from": "London", "to": "Paris", "price": "€175", "duration": "1h 30m", "departure": "14:15", "arrival": "17:45"},
        {"airline": "EasyJet", "from": "London", "to": "Paris", "price": "€89", "duration": "1h 35m", "departure": "07:45", "arrival": "11:20"},
        {"airline": "Ryanair", "from": "London", "to": "Paris", "price": "€65", "duration": "1h 40m", "departure": "16:30", "arrival": "20:10"},
    ]
    
    MOCK_HOTELS = [
        {"name": "Hotel Paris Center", "location": "1st Arrondissement", "price": "€120/night", "rating": "4.5/5", "amenities": "WiFi, Breakfast, AC"},
        {"name": "Boutique Montmartre", "location": "18th Arrondissement", "price": "€95/night", "rating": "4.2/5", "amenities": "WiFi, City View, Restaurant"},
        {"name": "Luxury Champs-Élysées", "location": "8th Arrondissement", "price": "€280/night", "rating": "4.8/5", "amenities": "Spa, Concierge, WiFi"},
        {"name": "Budget Latin Quarter", "location": "5th Arrondissement", "price": "€65/night", "rating": "4.0/5", "amenities": "WiFi, Shared Kitchen"},
    ]
    
    # Basic endpoints
    @app.get("/")
    async def root():
        return {
            "message": "🌍 Travel Agent API with Streaming ✈️",
            "version": "2.0.0",
            "features": ["Regular queries", "Streaming responses", "Mock travel data"],
            "endpoints": {
                "health": "/health",
                "docs": "/docs",
                "query": "/travel/query",
                "stream": "/travel/stream",
                "threads": "/travel/threads/{thread_id}"
            }
        }
    
    @app.get("/health")
    async def health_check():
        return {
            "status": "healthy",
            "timestamp": datetime.now().isoformat(),
            "streaming": "enabled",
            "mock_data": "active"
        }
    
    # Regular query endpoint
    @app.post("/travel/query")
    async def query_travel_agent(travel_query: TravelQuery) -> TravelResponse:
        """Non-streaming endpoint for travel queries with mock data"""
        thread_id = travel_query.thread_id or str(uuid.uuid4())
        
        # Simulate processing time
        await asyncio.sleep(1)
        
        # Generate mock response based on query
        query_lower = travel_query.query.lower()
        
        response_parts = []
        
        if "flight" in query_lower or "fly" in query_lower:
            response_parts.append("✈️ **FLIGHT OPTIONS:**\n")
            for i, flight in enumerate(MOCK_FLIGHTS, 1):
                response_parts.append(f"{i}. **{flight['airline']}**")
                response_parts.append(f"   Route: {flight['from']} → {flight['to']}")
                response_parts.append(f"   Price: {flight['price']}")
                response_parts.append(f"   Time: {flight['departure']} → {flight['arrival']} ({flight['duration']})")
                response_parts.append("")
        
        if "hotel" in query_lower or "accommodation" in query_lower:
            response_parts.append("🏨 **HOTEL OPTIONS:**\n")
            for i, hotel in enumerate(MOCK_HOTELS, 1):
                response_parts.append(f"{i}. **{hotel['name']}**")
                response_parts.append(f"   Location: {hotel['location']}")
                response_parts.append(f"   Price: {hotel['price']}")
                response_parts.append(f"   Rating: {hotel['rating']}")
                response_parts.append(f"   Amenities: {hotel['amenities']}")
                response_parts.append("")
        
        if not response_parts:
            response_parts = [
                "🤖 I can help you find flights and hotels!",
                "",
                "Try asking something like:",
                "- 'Find me flights from London to Paris'",
                "- 'Show me hotels in Paris'",
                "- 'I need flights and hotels for a trip to Paris'"
            ]
        
        response_text = "\n".join(response_parts)
        
        return TravelResponse(
            response=response_text,
            thread_id=thread_id,
            timestamp=datetime.now().isoformat()
        )
    
    # Streaming endpoint
    async def stream_travel_response(query: str, thread_id: str) -> AsyncGenerator[str, None]:
        """Generate streaming response with realistic travel search simulation"""
        
        query_lower = query.lower()
        
        # Phase 1: Initial acknowledgment
        yield f"data: 🔍 Processing your travel request: '{query}'\n\n"
        await asyncio.sleep(0.8)
        
        # Phase 2: Flight search
        if "flight" in query_lower or "fly" in query_lower:
            yield f"data: ✈️ Searching for flights...\n\n"
            await asyncio.sleep(1.2)
            
            yield f"data: 📊 Found {len(MOCK_FLIGHTS)} flight options!\n\n"
            await asyncio.sleep(0.5)
            
            yield f"data: ✈️ **FLIGHT OPTIONS:**\n\n"
            
            for i, flight in enumerate(MOCK_FLIGHTS, 1):
                yield f"data: {i}. **{flight['airline']}** - {flight['price']}\n"
                yield f"data:    {flight['from']} → {flight['to']} ({flight['duration']})\n"
                yield f"data:    Departure: {flight['departure']} | Arrival: {flight['arrival']}\n\n"
                await asyncio.sleep(0.6)
        
        # Phase 3: Hotel search
        if "hotel" in query_lower or "accommodation" in query_lower:
            yield f"data: 🏨 Searching for hotels...\n\n"
            await asyncio.sleep(1.0)
            
            yield f"data: 📊 Found {len(MOCK_HOTELS)} hotel options!\n\n"
            await asyncio.sleep(0.5)
            
            yield f"data: 🏨 **HOTEL OPTIONS:**\n\n"
            
            for i, hotel in enumerate(MOCK_HOTELS, 1):
                yield f"data: {i}. **{hotel['name']}** - {hotel['price']}\n"
                yield f"data:    📍 {hotel['location']} | ⭐ {hotel['rating']}\n"
                yield f"data:    🛎️ {hotel['amenities']}\n\n"
                await asyncio.sleep(0.7)
        
        # Phase 4: Completion
        yield f"data: ✅ Search complete! Found great options for your trip.\n\n"
        yield f"data: 💡 **Next Steps:**\n"
        yield f"data: • Compare prices and amenities\n"
        yield f"data: • Check availability for your dates\n"
        yield f"data: • Book your preferred options\n\n"
        yield f"data: 🆔 Thread ID: {thread_id}\n\n"
        
        # Send completion marker
        yield "data: [DONE]\n\n"
    
    @app.post("/travel/stream")
    async def stream_travel_agent(travel_query: TravelQuery):
        """Streaming endpoint for travel queries"""
        thread_id = travel_query.thread_id or str(uuid.uuid4())
        
        return StreamingResponse(
            stream_travel_response(travel_query.query, thread_id),
            media_type="text/plain",
            headers={
                "Cache-Control": "no-cache",
                "Connection": "keep-alive",
                "Access-Control-Allow-Origin": "*",
                "X-Thread-ID": thread_id,
            }
        )
    
    # Thread history endpoint
    @app.get("/travel/threads/{thread_id}")
    async def get_thread_messages(thread_id: str):
        """Get thread history (mock implementation)"""
        return {
            "thread_id": thread_id,
            "status": "active",
            "message_count": 2,
            "last_activity": datetime.now().isoformat(),
            "messages": [
                {
                    "type": "HumanMessage",
                    "content": "Find me flights and hotels for Paris",
                    "timestamp": datetime.now().isoformat()
                },
                {
                    "type": "AIMessage", 
                    "content": "I found several options for your trip to Paris...",
                    "timestamp": datetime.now().isoformat()
                }
            ]
        }
    
    print("✅ Enhanced Travel Agent API created successfully!")
    print("📋 Available endpoints:")
    print("   GET  /              - API information")
    print("   GET  /health        - Health check")
    print("   POST /travel/query  - Regular travel query")
    print("   POST /travel/stream - Streaming travel query")
    print("   GET  /travel/threads/{id} - Thread history")
    
    if __name__ == "__main__":
        print("\n🚀 Starting enhanced server...")
        print("📱 Access the API at: http://localhost:8000")
        print("📚 API documentation at: http://localhost:8000/docs")
        print("🧪 Test streaming with your client.html")
        
        uvicorn.run(
            app,
            host="127.0.0.1",
            port=8000,
            log_level="info",
            reload=False  # Disable reload for better streaming performance
        )
        
except Exception as e:
    print(f"❌ ERROR: {e}")
    import traceback
    traceback.print_exc()
    input("Press Enter to exit...")
