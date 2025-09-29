"""
Quick API test examples for your LangGraph Travel Agent
"""
import requests
import json

# Test 1: Health Check
def test_health():
    response = requests.get("http://localhost:8000/health")
    print("🏥 Health Check:")
    print(json.dumps(response.json(), indent=2))
    print()

# Test 2: Simple Chat
def test_chat():
    data = {
        "message": "Find flights from New York to London for next week",
        "thread_id": "test_user_123"
    }
    
    response = requests.post(
        "http://localhost:8000/chat/stream",
        json=data,
        stream=True
    )
    
    print("🤖 Agent Response:")
    print("=" * 50)
    
    for line in response.iter_lines():
        if line:
            line_str = line.decode('utf-8')
            if line_str.startswith('data: ') and line_str != 'data: [DONE]':
                data = line_str[6:]  # Remove 'data: ' prefix
                if data and data != '[DONE]':
                    print(data, end='', flush=True)
    
    print("\n" + "=" * 50)

if __name__ == "__main__":
    print("🌍 Testing Travel Agent API")
    print("=" * 60)
    
    try:
        test_health()
        test_chat()
        print("✅ All tests completed successfully!")
    except Exception as e:
        print(f"❌ Error: {e}")
