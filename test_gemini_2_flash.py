"""
Test script for Google GenAI client with gemini-2.0-flash model
"""
import os
from google import genai
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

def test_gemini_2_flash():
    """Test the gemini-2.0-flash model with direct Google GenAI client"""
    
    # Initialize client with API key from environment
    api_key = os.getenv('GOOGLE_API_KEY')
    if not api_key:
        print("❌ GOOGLE_API_KEY not found in environment")
        return
    
    try:
        # Create client with v1alpha API version for gemini-2.0-flash
        client = genai.Client(api_key=api_key, http_options={'api_version': 'v1alpha'})
        
        # Generate content with gemini-2.0-flash
        response = client.models.generate_content(
            model='gemini-2.0-flash',
            contents="Explain how AI works in travel planning",
        )
        
        print("🤖 Gemini 2.0 Flash Response:")
        print("=" * 50)
        print(response.text)
        print("=" * 50)
        print("✅ Test successful!")
        
    except Exception as e:
        print(f"❌ Error testing Gemini 2.0 Flash: {e}")

if __name__ == "__main__":
    test_gemini_2_flash()
