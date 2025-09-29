#!/bin/bash

echo "🚀 Building Docker container locally..."

# Build the Docker image
docker build -f Dockerfile.gcp -t journita-travel-agent .

echo "✅ Docker image built successfully!"

echo "🌍 Running locally on port 8080..."
echo "Press Ctrl+C to stop"

# Run the container with environment variables from .env file
docker run -p 8080:8080 --env-file .env journita-travel-agent
