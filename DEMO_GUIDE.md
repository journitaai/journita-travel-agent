# 🎯 Comprehensive Demo Guide for Travel Agent API

## 🚀 **Current Status**
- ✅ **Production Server**: Running at `http://localhost:8000`
- ⚠️ **Mode**: Mock Mode (due to OpenAI API key issue)
- ✅ **Streaming**: Fully functional
- ✅ **FastAPI Docs**: Available at `/docs`
- ✅ **All Dependencies**: Installed and working

## 🎭 **Demo Scenarios**

### **Scenario 1: Basic Travel Query**
**Test**: `POST /travel/query`
```json
{
  "query": "I want to travel from London to Paris next week. Find me flights and hotels.",
  "use_real_agent": false
}
```
**Expected**: Comprehensive mock response with flights and hotels

### **Scenario 2: Streaming Demo**
**Test**: `POST /travel/stream`
```json
{
  "query": "Find me budget flights from New York to Tokyo and luxury hotels",
  "use_real_agent": false
}
```
**Expected**: Real-time streaming response with step-by-step updates

### **Scenario 3: Flight-Only Query**
**Test**: `POST /travel/stream`
```json
{
  "query": "Show me flights from Berlin to Barcelona for March",
  "use_real_agent": false
}
```
**Expected**: Focus on flight options only

### **Scenario 4: Hotel-Only Query**
**Test**: `POST /travel/query`
```json
{
  "query": "I need 4-star hotels in Rome near the city center",
  "use_real_agent": false
}
```
**Expected**: Focus on hotel options only

### **Scenario 5: Thread Persistence**
**Test**: Multiple queries with same `thread_id`
```json
{
  "query": "Find flights to Paris",
  "thread_id": "demo-thread-123",
  "use_real_agent": false
}
```
Then:
```json
{
  "query": "Now find hotels in Paris",
  "thread_id": "demo-thread-123",
  "use_real_agent": false
}
```

## 🔧 **API Key Fix Instructions**

### **OpenAI API Key Issue**
Your current key appears to be invalid. Here's how to fix it:

1. **Go to OpenAI Platform**: https://platform.openai.com/api-keys
2. **Create New Key**: 
   - Click "Create new secret key"
   - Name it "Travel Agent API"
   - Copy the key (starts with `sk-proj-` for new keys)
3. **Update .env file**:
   ```env
   OPENAI_API_KEY=sk-proj-your-new-key-here
   ```
4. **Restart server** to load new key

### **SerpAPI Key** (Optional Enhancement)
Your SerpAPI key looks correct, but verify at: https://serpapi.com/dashboard

## 🎪 **Presentation Flow**

### **Phase 1: Mock Demo (Current)**
1. **Start with API Overview**: Show `http://localhost:8000`
2. **Show Interactive Docs**: Demonstrate `/docs` endpoint
3. **Live Streaming Demo**: Use client.html with streaming
4. **API Status**: Show `/status` endpoint

### **Phase 2: Real Integration (After API Key Fix)**
1. **Show Real vs Mock Toggle**: Demonstrate `use_real_agent` parameter
2. **Real AI Response**: Show actual OpenAI integration
3. **Tool Usage**: Demonstrate SerpAPI flight/hotel search
4. **Production Features**: Error handling, thread persistence

### **Phase 3: LangGraph Studio**
1. **Visual Workflow**: Show graph structure
2. **Step-by-step Execution**: Demonstrate agent reasoning
3. **Debugging Tools**: Show state inspection

## 🌟 **Demo Talking Points**

### **Technical Highlights**
- **Adaptive System**: Automatically falls back to mock mode
- **Real-time Streaming**: Shows responses as they're generated
- **Production Ready**: Full error handling and logging
- **Developer Friendly**: Interactive API documentation
- **Scalable Architecture**: Ready for Docker deployment

### **Business Benefits**
- **User Experience**: Real-time responses keep users engaged
- **Reliability**: Fallback systems ensure uptime
- **Flexibility**: Works with or without external APIs
- **Maintainability**: Clear separation of concerns

## 🚀 **Quick Start for Demo**

### **Option A: Web Interface**
1. Open `client.html` in browser
2. Try: "Find me flights from London to Paris and luxury hotels"
3. Click "Stream Response" to see real-time streaming

### **Option B: API Testing**
1. Go to `http://localhost:8000/docs`
2. Try the `/travel/stream` endpoint
3. Watch the real-time response

### **Option C: Command Line**
```powershell
# Test regular endpoint
$body = @{
    query = "Find flights to Tokyo and hotels"
    use_real_agent = $false
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8000/travel/query" -Method POST -Body $body -ContentType "application/json"
```

## 🔮 **Next Steps After Demo**

1. **Fix OpenAI API Key**: Get real AI responses
2. **Deploy to Production**: Use Docker setup
3. **Add Database**: For real thread persistence  
4. **Monitoring Setup**: Add logging and metrics
5. **Custom Branding**: Personalize for your organization

## 🎯 **Demo Success Metrics**

- ✅ **Streaming Works**: Real-time response display
- ✅ **API Docs Work**: Interactive Swagger interface  
- ✅ **Fallback Works**: Graceful handling of API issues
- ✅ **Thread Persistence**: Conversation continuity
- ✅ **Error Handling**: Proper error responses

**Your system is ready for an impressive demo!** 🚀
