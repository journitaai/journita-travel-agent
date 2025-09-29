#!/bin/bash
# Render startup script
# This script runs before the main application starts

echo "🚀 Starting Travel Agent on Render..."
echo "Python version: $(python --version)"
echo "Current directory: $(pwd)"
echo "Files in app directory:"
ls -la

# Check if required environment variables are set
if [ -z "$GOOGLE_API_KEY" ]; then
    echo "⚠️  Warning: GOOGLE_API_KEY not set"
else
    echo "✅ GOOGLE_API_KEY is configured"
fi

if [ -z "$SERPAPI_API_KEY" ]; then
    echo "⚠️  Warning: SERPAPI_API_KEY not set"
else
    echo "✅ SERPAPI_API_KEY is configured"
fi

# Set PORT from Render environment or default
export PORT=${PORT:-10000}
echo "🌐 Server will start on port: $PORT"

# Start the application
echo "🚀 Launching Travel Agent API..."
exec uvicorn production_server:app --host 0.0.0.0 --port $PORT --workers 1
