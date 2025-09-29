#!/usr/bin/env python3

import os
import uuid
from dotenv import load_dotenv
from langchain_core.messages import HumanMessage

print("🧪 Testing Real LangGraph Agent Integration")
print("=" * 50)

# Load environment variables
load_dotenv()

def test_api_keys():
    """Test if API keys are available"""
    print("📋 Checking API Keys...")
    
    openai_key = os.getenv('OPENAI_API_KEY')
    serpapi_key = os.getenv('SERPAPI_API_KEY')
    langsmith_key = os.getenv('LANGSMITH_API_KEY')
    
    print(f"✓ OpenAI API Key: {'✅ Available' if openai_key else '❌ Missing'}")
    print(f"✓ SerpAPI Key: {'✅ Available' if serpapi_key else '❌ Missing'}")
    print(f"✓ LangSmith Key: {'✅ Available' if langsmith_key else '❌ Missing'}")
    
    return bool(openai_key and serpapi_key)

def test_imports():
    """Test all required imports"""
    print("\n📦 Testing Imports...")
    
    try:
        from agents.graph import create_graph
        print("✓ Graph module imported")
        
        from langchain_core.messages import HumanMessage
        print("✓ LangChain core imported")
        
        from langchain_openai import ChatOpenAI
        print("✓ OpenAI integration imported")
        
        return True
    except Exception as e:
        print(f"❌ Import failed: {e}")
        return False

def test_openai_connection():
    """Test OpenAI connection"""
    print("\n🤖 Testing OpenAI Connection...")
    
    try:
        from langchain_openai import ChatOpenAI
        
        llm = ChatOpenAI(model='gpt-4o', temperature=0)
        response = llm.invoke([HumanMessage(content="Say 'Connection test successful' and nothing else.")])
        
        print(f"✓ OpenAI Response: {response.content}")
        return True
    except Exception as e:
        print(f"❌ OpenAI connection failed: {e}")
        return False

def test_graph_creation():
    """Test graph creation"""
    print("\n🕸️ Testing Graph Creation...")
    
    try:
        from agents.graph import create_graph
        
        graph = create_graph()
        print("✓ Graph created successfully")
        
        # Test graph structure
        print(f"✓ Graph nodes: {list(graph.get_graph().nodes.keys())}")
        
        return graph
    except Exception as e:
        print(f"❌ Graph creation failed: {e}")
        import traceback
        traceback.print_exc()
        return None

def test_simple_agent_query(graph):
    """Test a simple agent query"""
    print("\n🎯 Testing Simple Agent Query...")
    
    try:
        thread_id = str(uuid.uuid4())
        messages = [HumanMessage(content="Hello! Can you help me plan a trip? Just say hello back.")]
        config = {'configurable': {'thread_id': thread_id}}
        
        print("📤 Sending test query...")
        result = graph.invoke({'messages': messages}, config=config)
        
        if result and 'messages' in result and result['messages']:
            response = result['messages'][-1].content
            print(f"✅ Agent Response: {response[:100]}...")
            return True
        else:
            print("❌ No response received")
            return False
            
    except Exception as e:
        print(f"❌ Agent query failed: {e}")
        import traceback
        traceback.print_exc()
        return False

def main():
    """Run all tests"""
    print("🚀 Starting Real LangGraph Integration Tests...\n")
    
    # Test 1: API Keys
    if not test_api_keys():
        print("❌ Cannot proceed without API keys")
        return False
    
    # Test 2: Imports
    if not test_imports():
        print("❌ Cannot proceed with import errors")
        return False
    
    # Test 3: OpenAI Connection
    if not test_openai_connection():
        print("❌ Cannot proceed without OpenAI connection")
        return False
    
    # Test 4: Graph Creation
    graph = test_graph_creation()
    if not graph:
        print("❌ Cannot proceed without working graph")
        return False
    
    # Test 5: Simple Query
    if not test_simple_agent_query(graph):
        print("❌ Agent query test failed")
        return False
    
    print("\n🎉 ALL TESTS PASSED!")
    print("✅ Real LangGraph integration is working!")
    print("🚀 Ready to integrate with FastAPI server!")
    
    return True

if __name__ == "__main__":
    try:
        success = main()
        if success:
            print("\n🎯 Next: Creating integrated FastAPI server...")
        else:
            print("\n❌ Tests failed. Check errors above.")
    except KeyboardInterrupt:
        print("\n⏹️ Tests interrupted by user")
    except Exception as e:
        print(f"\n💥 Unexpected error: {e}")
        import traceback
        traceback.print_exc()
