# Final Deployment Script for Journita Travel Agent
# Run this script to deploy your travel agent to the cloud

Write-Host "🚀 JOURNITA TRAVEL AGENT - FINAL DEPLOYMENT" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

# Check current directory
$currentDir = Get-Location
Write-Host "📁 Current Directory: $currentDir" -ForegroundColor Blue

# Check if we're in the right directory
if (-not (Test-Path "pyproject.toml")) {
    Write-Host "❌ Error: Not in the project directory!" -ForegroundColor Red
    Write-Host "Please navigate to the journita-travel-agent directory first." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "✅ Project directory confirmed" -ForegroundColor Green
Write-Host ""

# Check environment variables
Write-Host "🔑 Checking Environment Variables..." -ForegroundColor Cyan
$envFile = Get-Content ".env" -ErrorAction SilentlyContinue
if ($envFile) {
    Write-Host "✅ .env file found" -ForegroundColor Green
    $googleKey = ($envFile | Where-Object { $_ -match "GOOGLE_API_KEY=" }) -replace "GOOGLE_API_KEY=", ""
    $serpKey = ($envFile | Where-Object { $_ -match "SERPAPI_API_KEY=" }) -replace "SERPAPI_API_KEY=", ""
    
    if ($googleKey) {
        Write-Host "✅ Google API Key: $($googleKey.Substring(0, [Math]::Min(10, $googleKey.Length)))..." -ForegroundColor Green
    }
    if ($serpKey) {
        Write-Host "✅ SerpAPI Key: $($serpKey.Substring(0, [Math]::Min(10, $serpKey.Length)))..." -ForegroundColor Green
    }
} else {
    Write-Host "❌ .env file not found" -ForegroundColor Red
}

Write-Host ""

# Check git status
Write-Host "📋 Checking Git Status..." -ForegroundColor Cyan
try {
    $gitStatus = git status --porcelain 2>$null
    if ($gitStatus) {
        Write-Host "⚠️ Uncommitted changes found:" -ForegroundColor Yellow
        git status --short
    } else {
        Write-Host "✅ All changes committed" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Git not available or not a git repository" -ForegroundColor Red
}

Write-Host ""

# Deployment options
Write-Host "🌍 DEPLOYMENT OPTIONS:" -ForegroundColor Cyan
Write-Host "1. 🔥 Render.com (Recommended - Free Tier)" -ForegroundColor Yellow
Write-Host "2. ☁️ Google Cloud Run (Scalable)" -ForegroundColor Yellow
Write-Host "3. 🐳 Local Docker Test" -ForegroundColor Yellow
Write-Host "4. 🔧 Prepare Files Only" -ForegroundColor Yellow
Write-Host ""

$choice = Read-Host "Choose deployment option (1-4)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "🔥 RENDER.COM DEPLOYMENT" -ForegroundColor Green
        Write-Host "========================" -ForegroundColor Green
        Write-Host ""
        
        Write-Host "Step 1: Commit and push changes to GitHub..." -ForegroundColor Yellow
        
        # Add all files
        git add .
        
        # Commit changes
        $commitMessage = "Final deployment - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
        git commit -m $commitMessage
        
        # Push to GitHub
        Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
        git push origin main
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Code pushed to GitHub successfully!" -ForegroundColor Green
            Write-Host ""
            Write-Host "Step 2: Deploy to Render.com" -ForegroundColor Yellow
            Write-Host "----------------------------" -ForegroundColor Yellow
            Write-Host "1. Go to: https://render.com" -ForegroundColor Blue
            Write-Host "2. Sign up/Login with your GitHub account" -ForegroundColor Blue
            Write-Host "3. Click 'New +' → 'Web Service'" -ForegroundColor Blue
            Write-Host "4. Connect repository: journitaai/journita-travel-agent" -ForegroundColor Blue
            Write-Host "5. Render will detect your render.yaml automatically!" -ForegroundColor Blue
            Write-Host ""
            Write-Host "Environment Variables to add:" -ForegroundColor Cyan
            if ($googleKey) {
                Write-Host "GOOGLE_API_KEY = $googleKey" -ForegroundColor Blue
            }
            if ($serpKey) {
                Write-Host "SERPAPI_API_KEY = $serpKey" -ForegroundColor Blue
            }
            Write-Host ""
            Write-Host "🎉 Your app will be live at: https://journita-travel-agent.onrender.com" -ForegroundColor Green
        } else {
            Write-Host "❌ Failed to push to GitHub" -ForegroundColor Red
            Write-Host "Please check your GitHub credentials and try again." -ForegroundColor Yellow
        }
    }
    
    "2" {
        Write-Host ""
        Write-Host "☁️ GOOGLE CLOUD RUN DEPLOYMENT" -ForegroundColor Green
        Write-Host "==============================" -ForegroundColor Green
        Write-Host ""
        
        # Check if gcloud is installed
        try {
            $gcloudVersion = gcloud --version 2>$null
            Write-Host "✅ Google Cloud SDK found" -ForegroundColor Green
            
            $projectId = Read-Host "Enter your GCP Project ID"
            
            if ($projectId) {
                Write-Host "Setting up GCP deployment..." -ForegroundColor Yellow
                
                # Set project
                gcloud config set project $projectId
                
                # Enable APIs
                gcloud services enable cloudbuild.googleapis.com
                gcloud services enable run.googleapis.com
                
                # Build and deploy
                Write-Host "Building container..." -ForegroundColor Yellow
                gcloud builds submit --tag "gcr.io/$projectId/journita-travel-agent" --file Dockerfile.gcp .
                
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "Deploying to Cloud Run..." -ForegroundColor Yellow
                    gcloud run deploy journita-travel-agent `
                        --image "gcr.io/$projectId/journita-travel-agent" `
                        --platform managed `
                        --region us-central1 `
                        --allow-unauthenticated `
                        --set-env-vars "GOOGLE_API_KEY=$googleKey,SERPAPI_API_KEY=$serpKey" `
                        --memory 2Gi `
                        --cpu 1 `
                        --max-instances 10
                    
                    if ($LASTEXITCODE -eq 0) {
                        Write-Host ""
                        Write-Host "🎉 Deployment successful!" -ForegroundColor Green
                        $serviceUrl = gcloud run services describe journita-travel-agent --platform managed --region us-central1 --format 'value(status.url)'
                        Write-Host "🌍 Your app is live at: $serviceUrl" -ForegroundColor Blue
                    }
                }
            }
        } catch {
            Write-Host "❌ Google Cloud SDK not found" -ForegroundColor Red
            Write-Host "Please install from: https://cloud.google.com/sdk/docs/install" -ForegroundColor Blue
        }
    }
    
    "3" {
        Write-Host ""
        Write-Host "🐳 LOCAL DOCKER TEST" -ForegroundColor Green
        Write-Host "====================" -ForegroundColor Green
        Write-Host ""
        
        try {
            $dockerVersion = docker --version
            Write-Host "✅ Docker found: $dockerVersion" -ForegroundColor Green
            
            Write-Host "Building Docker image..." -ForegroundColor Yellow
            docker build -f Dockerfile.gcp -t journita-travel-agent .
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Docker image built successfully!" -ForegroundColor Green
                Write-Host ""
                Write-Host "Starting container on port 8080..." -ForegroundColor Yellow
                Write-Host "Your app will be available at: http://localhost:8080" -ForegroundColor Blue
                Write-Host "Press Ctrl+C to stop the container" -ForegroundColor Yellow
                Write-Host ""
                
                docker run -p 8080:8080 --env-file .env journita-travel-agent
            } else {
                Write-Host "❌ Docker build failed" -ForegroundColor Red
            }
        } catch {
            Write-Host "❌ Docker not found" -ForegroundColor Red
            Write-Host "Please install Docker from: https://www.docker.com/products/docker-desktop" -ForegroundColor Blue
        }
    }
    
    "4" {
        Write-Host ""
        Write-Host "🔧 PREPARING FILES FOR DEPLOYMENT" -ForegroundColor Green
        Write-Host "==================================" -ForegroundColor Green
        Write-Host ""
        
        Write-Host "Adding all files to git..." -ForegroundColor Yellow
        git add .
        
        Write-Host "Checking what will be committed..." -ForegroundColor Yellow
        git status
        
        Write-Host ""
        Write-Host "✅ Files prepared for deployment!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Cyan
        Write-Host "1. Review the changes above" -ForegroundColor Blue
        Write-Host "2. Run: git commit -m 'Ready for deployment'" -ForegroundColor Blue
        Write-Host "3. Run: git push origin main" -ForegroundColor Blue
        Write-Host "4. Deploy to your chosen platform" -ForegroundColor Blue
    }
    
    default {
        Write-Host "❌ Invalid choice" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "📋 DEPLOYMENT SUMMARY" -ForegroundColor Cyan
Write-Host "=====================" -ForegroundColor Cyan
Write-Host "✅ Project: Journita Travel Agent" -ForegroundColor Green
Write-Host "✅ Features: AI Chat, Flight Search, Hotel Booking" -ForegroundColor Green
Write-Host "✅ AI Model: Google Gemini 2.0 Flash" -ForegroundColor Green
Write-Host "✅ Search API: SerpAPI for real-time data" -ForegroundColor Green
Write-Host "✅ Frontend: React TypeScript + FastAPI backend" -ForegroundColor Green
Write-Host "✅ Deployment: Ready for cloud platforms" -ForegroundColor Green
Write-Host ""
Write-Host "🌟 Your travel agent is ready to help users plan amazing trips!" -ForegroundColor Yellow
Write-Host ""

Read-Host "Press Enter to exit"
