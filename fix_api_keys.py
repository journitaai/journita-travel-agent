#!/usr/bin/env python3

import os
from dotenv import load_dotenv

print("🔧 API Key Validator and Fixer")
print("=" * 40)

# Load current environment
load_dotenv()

def check_openai_key():
    """Check and validate OpenAI API key format"""
    key = os.getenv('OPENAI_API_KEY')
    
    if not key:
        print("❌ No OpenAI API key found in .env file")
        return False
    
    print(f"📋 Current key format: {key[:10]}...{key[-10:]}")
    
    # Check key format
    if key.startswith('sk-proj-'):
        print("✅ Key format: New project key (recommended)")
        return True
    elif key.startswith('sk-'):
        print("⚠️ Key format: Legacy format (may need updating)")
        return True
    else:
        print("❌ Key format: Invalid format")
        return False

def check_serpapi_key():
    """Check SerpAPI key"""
    key = os.getenv('SERPAPI_API_KEY')
    
    if not key:
        print("❌ No SerpAPI key found")
        return False
    
    print(f"📋 SerpAPI key: {key[:10]}...{key[-10:]}")
    
    if len(key) > 30:
        print("✅ SerpAPI key format looks good")
        return True
    else:
        print("⚠️ SerpAPI key might be too short")
        return False

def test_openai_connection():
    """Test OpenAI connection without making a real call"""
    try:
        from langchain_openai import ChatOpenAI
        
        # Just create the client, don't call it
        llm = ChatOpenAI(model='gpt-4o', temperature=0)
        print("✅ OpenAI client creation successful")
        return True
        
    except Exception as e:
        print(f"❌ OpenAI client creation failed: {e}")
        return False

def generate_instructions():
    """Generate instructions for fixing API keys"""
    print("\n🛠️ **INSTRUCTIONS TO FIX API KEYS:**")
    print()
    
    print("1. **OpenAI API Key:**")
    print("   - Go to: https://platform.openai.com/api-keys")
    print("   - Click 'Create new secret key'")
    print("   - Name: 'Travel Agent API'")
    print("   - Copy the key (starts with 'sk-proj-')")
    print("   - Replace in .env file")
    print()
    
    print("2. **SerpAPI Key (Optional):**")
    print("   - Go to: https://serpapi.com/dashboard")
    print("   - Copy your API key")
    print("   - Update in .env file")
    print()
    
    print("3. **Restart the server after updating keys**")
    print()
    
    print("📝 Example .env format:")
    print("```")
    print("OPENAI_API_KEY=sk-proj-your-new-key-here")
    print("SERPAPI_API_KEY=your-serpapi-key-here") 
    print("LANGSMITH_API_KEY=your-langsmith-key-here")
    print("```")

def main():
    print("🔍 Checking current API key configuration...\n")
    
    openai_ok = check_openai_key()
    serpapi_ok = check_serpapi_key()
    
    print(f"\n📊 **SUMMARY:**")
    print(f"OpenAI API Key: {'✅ Valid Format' if openai_ok else '❌ Needs Fix'}")
    print(f"SerpAPI Key: {'✅ Valid Format' if serpapi_ok else '❌ Needs Fix'}")
    
    if openai_ok:
        print(f"\n🧪 Testing OpenAI connection...")
        connection_ok = test_openai_connection()
        
        if not connection_ok:
            print("⚠️ Key format is valid but connection failed")
            print("💡 This usually means the key is expired or invalid")
            openai_ok = False
    
    if not openai_ok or not serpapi_ok:
        generate_instructions()
    else:
        print("\n🎉 All API keys look good!")
        print("🚀 You should be able to use Real AI mode!")

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"💥 Error: {e}")
        import traceback
        traceback.print_exc()
