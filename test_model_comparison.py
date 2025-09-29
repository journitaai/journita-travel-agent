"""
Comparison test: LangChain vs Direct Google GenAI client with gemini-2.0-flash
"""
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

def test_langchain_gemini():
    """Test gemini-2.0-flash via LangChain"""
    try:
        from langchain_google_genai import ChatGoogleGenerativeAI
        
        model = ChatGoogleGenerativeAI(
            model="gemini-2.0-flash",
            temperature=0.1
        )
        
        response = model.invoke("Explain how AI works in travel planning")
        
        print("🦜 LangChain + Gemini 2.0 Flash Response:")
        print("=" * 50)
        print(response.content)
        print("=" * 50)
        
    except Exception as e:
        print(f"❌ LangChain test failed: {e}")

def test_direct_genai():
    """Test gemini-2.0-flash via direct Google GenAI client"""
    try:
        from google import genai
        
        api_key = os.getenv('GOOGLE_API_KEY')
        if not api_key:
            print("❌ GOOGLE_API_KEY not found")
            return
            
        client = genai.Client(api_key=api_key, http_options={'api_version': 'v1alpha'})
        
        response = client.models.generate_content(
            model='gemini-2.0-flash',
            contents="Explain how AI works in travel planning",
        )
        
        print("🤖 Direct GenAI Client + Gemini 2.0 Flash Response:")
        print("=" * 50)
        print(response.text)
        print("=" * 50)
        
    except Exception as e:
        print(f"❌ Direct GenAI test failed: {e}")

if __name__ == "__main__":
    print("🧪 Testing Gemini 2.0 Flash Models")
    print("=" * 60)
    
    print("\n1. Testing LangChain Integration:")
    test_langchain_gemini()
    
    print("\n2. Testing Direct Google GenAI Client:")
    test_direct_genai()
    
    print("\n✅ Both approaches now use gemini-2.0-flash model!")
