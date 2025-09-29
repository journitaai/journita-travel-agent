@echo off
echo 🚀 Journita Travel Agent - GCP Deployment Commands
echo.

echo Step 1: Set your project ID
set /p PROJECT_ID="Enter your GCP Project ID: "

echo.
echo Step 2: Set project configuration
gcloud config set project %PROJECT_ID%

echo.
echo Step 3: Enable required APIs
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com

echo.
echo Step 4: Build the container
gcloud builds submit --tag gcr.io/%PROJECT_ID%/journita-travel-agent --file Dockerfile.gcp .

echo.
echo Step 5: Deploy to Cloud Run
gcloud run deploy journita-travel-agent ^
    --image gcr.io/%PROJECT_ID%/journita-travel-agent ^
    --platform managed ^
    --region us-central1 ^
    --allow-unauthenticated ^
    --set-env-vars GOOGLE_API_KEY=%GOOGLE_API_KEY%,SERPAPI_API_KEY=%SERPAPI_API_KEY% ^
    --memory 2Gi ^
    --cpu 1 ^
    --max-instances 10

echo.
echo 🎉 Deployment complete!
echo.
echo Getting service URL...
gcloud run services describe journita-travel-agent --platform managed --region us-central1 --format "value(status.url)"

pause
