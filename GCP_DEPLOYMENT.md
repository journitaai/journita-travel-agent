# Journita Travel Agent - GCP Deployment Guide

## 🚀 Deploy to Google Cloud Platform

This guide will help you deploy your Journita Travel Agent to Google Cloud Platform using multiple deployment options.

## 📋 Prerequisites

### 1. Install Google Cloud SDK
```bash
# Download and install from: https://cloud.google.com/sdk/docs/install
gcloud --version
```

### 2. Set up GCP Project
```bash
# Create new project or use existing
gcloud projects create journita-travel-agent --name="Journita Travel Agent"

# Set the project
gcloud config set project journita-travel-agent

# Enable required APIs
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable appengine.googleapis.com
```

### 3. Set up Authentication
```bash
gcloud auth login
gcloud auth application-default login
```

## 🎯 Deployment Options

### Option 1: Google Cloud Run (Recommended)

**Step 1: Build and Deploy**
```bash
cd journita-travel-agent

# Build the container
gcloud builds submit --tag gcr.io/journita-travel-agent/travel-agent .

# Deploy to Cloud Run
gcloud run deploy journita-travel-agent \
  --image gcr.io/journita-travel-agent/travel-agent \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars GOOGLE_API_KEY=your_google_api_key,SERPAPI_API_KEY=your_serpapi_key \
  --memory 2Gi \
  --cpu 1 \
  --max-instances 10
```

**Step 2: Get the URL**
```bash
gcloud run services describe journita-travel-agent \
  --platform managed \
  --region us-central1 \
  --format 'value(status.url)'
```

### Option 2: Google App Engine

**Step 1: Deploy**
```bash
cd journita-travel-agent

# Set environment variables
export GOOGLE_API_KEY=your_google_api_key
export SERPAPI_API_KEY=your_serpapi_key

# Deploy
gcloud app deploy app.yaml
```

**Step 2: Open the app**
```bash
gcloud app browse
```

### Option 3: Cloud Build (CI/CD)

**Step 1: Set up Build Trigger**
```bash
# Connect your repository and create a trigger
gcloud builds triggers create github \
  --repo-name=journita-travel-agent \
  --repo-owner=journitaai \
  --branch-pattern="^main$" \
  --build-config=cloudbuild.yaml
```

**Step 2: Set substitution variables**
- `_GOOGLE_API_KEY`: Your Google API key
- `_SERPAPI_API_KEY`: Your SerpAPI key

## 🔧 Configuration Files Created

### 1. `Dockerfile.gcp`
- Multi-stage Docker build
- Python 3.11 with Poetry
- Health checks included
- Runs on port 8080

### 2. `gcp_server.py` 
- Production-ready FastAPI server
- Environment variable configuration
- Static file serving for frontend
- CORS configured for production

### 3. `app.yaml`
- App Engine configuration
- Auto-scaling settings
- Environment variables

### 4. `cloudbuild.yaml`
- Cloud Build configuration
- Docker build and push
- Cloud Run deployment
- Environment variable injection

### 5. `main.py`
- App Engine entry point
- Production server configuration

## 🔐 Environment Variables

Set these in your GCP deployment:

```bash
GOOGLE_API_KEY=your_google_gemini_api_key
SERPAPI_API_KEY=your_serpapi_key
PORT=8080  # Automatically set by GCP
```

## 🌐 Frontend Configuration

The frontend will automatically connect to your GCP backend URL. No manual configuration needed!

## 📊 Monitoring & Logs

### View Logs
```bash
# Cloud Run logs
gcloud logs read --service journita-travel-agent

# App Engine logs  
gcloud logs read --service default
```

### Monitor Performance
- **Cloud Console**: https://console.cloud.google.com/
- **Cloud Run**: Monitor requests, latency, errors
- **App Engine**: View traffic, instances, versions

## 💰 Cost Optimization

### Cloud Run
- **Free Tier**: 2 million requests/month
- **Pay per use**: Only when serving requests
- **Auto-scaling**: Scales to zero when idle

### App Engine
- **Free Tier**: 28 instance hours/day
- **Standard Environment**: Good for consistent traffic

## 🚀 Quick Deploy Commands

### For Cloud Run:
```bash
# One-command deploy
gcloud run deploy journita-travel-agent \
  --source . \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars GOOGLE_API_KEY=YOUR_KEY,SERPAPI_API_KEY=YOUR_KEY
```

### For App Engine:
```bash
# One-command deploy
gcloud app deploy
```

## 🎉 After Deployment

1. **Test the API**: Visit your deployment URL
2. **Check Health**: `{your-url}/health`
3. **View Docs**: `{your-url}/docs`
4. **Use Frontend**: Available at root URL
5. **Monitor**: Check Cloud Console for metrics

## 🐛 Troubleshooting

### Common Issues:
- **Build Failures**: Check Docker build logs
- **API Key Errors**: Verify environment variables
- **Memory Issues**: Increase memory allocation
- **Cold Starts**: Consider min instances setting

### Debug Commands:
```bash
# Check service status
gcloud run services list

# View service details
gcloud run services describe journita-travel-agent

# Check build history
gcloud builds list
```

Your Journita Travel Agent will be live on GCP! 🌍✈️
