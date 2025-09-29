# Google Cloud Platform Deployment Scripts

Write-Host "🚀 Journita Travel Agent - GCP Deployment Helper" -ForegroundColor Green
Write-Host ""

# Check if gcloud is installed
try {
    $gcloudVersion = gcloud --version 2>$null
    Write-Host "✅ Google Cloud SDK found" -ForegroundColor Green
} catch {
    Write-Host "❌ Google Cloud SDK not found. Please install from:" -ForegroundColor Red
    Write-Host "https://cloud.google.com/sdk/docs/install" -ForegroundColor Blue
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Please choose deployment option:" -ForegroundColor Cyan
Write-Host "1. 🌊 Cloud Run (Recommended - Serverless)" -ForegroundColor Yellow
Write-Host "2. 🏗️ App Engine (Platform as a Service)" -ForegroundColor Yellow
Write-Host "3. 🔧 Set up Cloud Build (CI/CD)" -ForegroundColor Yellow
Write-Host ""

$choice = Read-Host "Enter your choice (1-3)"

switch ($choice) {
    "1" {
        Write-Host "🌊 Deploying to Cloud Run..." -ForegroundColor Cyan
        
        # Get project ID
        $projectId = Read-Host "Enter your GCP Project ID"
        if (-not $projectId) {
            Write-Host "❌ Project ID required" -ForegroundColor Red
            exit 1
        }
        
        # Get API keys
        $googleApiKey = Read-Host "Enter your Google API Key (for Gemini)"
        $serpApiKey = Read-Host "Enter your SerpAPI Key"
        
        Write-Host ""
        Write-Host "📋 Configuration:" -ForegroundColor Blue
        Write-Host "Project: $projectId"
        Write-Host "Google API Key: $($googleApiKey.Substring(0, [Math]::Min(10, $googleApiKey.Length)))..."
        Write-Host "SerpAPI Key: $($serpApiKey.Substring(0, [Math]::Min(10, $serpApiKey.Length)))..."
        Write-Host ""
        
        $confirm = Read-Host "Deploy with these settings? (y/N)"
        if ($confirm -ne "y" -and $confirm -ne "Y") {
            Write-Host "❌ Deployment cancelled" -ForegroundColor Red
            exit 0
        }
        
        Write-Host ""
        Write-Host "🔧 Setting up GCP project..." -ForegroundColor Yellow
        
        # Set project
        gcloud config set project $projectId
        
        # Enable APIs
        Write-Host "🔌 Enabling required APIs..." -ForegroundColor Yellow
        gcloud services enable cloudbuild.googleapis.com
        gcloud services enable run.googleapis.com
        
        # Build and deploy
        Write-Host "🏗️ Building container..." -ForegroundColor Yellow
        gcloud builds submit --tag "gcr.io/$projectId/journita-travel-agent" --file Dockerfile.gcp .
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "❌ Build failed" -ForegroundColor Red
            Read-Host "Press Enter to exit"
            exit 1
        }
        
        Write-Host "🚀 Deploying to Cloud Run..." -ForegroundColor Yellow
        gcloud run deploy journita-travel-agent `
            --image "gcr.io/$projectId/journita-travel-agent" `
            --platform managed `
            --region us-central1 `
            --allow-unauthenticated `
            --set-env-vars "GOOGLE_API_KEY=$googleApiKey,SERPAPI_API_KEY=$serpApiKey" `
            --memory 2Gi `
            --cpu 1 `
            --max-instances 10
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "🎉 Deployment successful!" -ForegroundColor Green
            Write-Host ""
            Write-Host "Getting service URL..." -ForegroundColor Yellow
            $serviceUrl = gcloud run services describe journita-travel-agent --platform managed --region us-central1 --format 'value(status.url)'
            Write-Host ""
            Write-Host "🌍 Your app is live at:" -ForegroundColor Green
            Write-Host $serviceUrl -ForegroundColor Blue
            Write-Host ""
            Write-Host "📝 Useful URLs:" -ForegroundColor Cyan
            Write-Host "Frontend: $serviceUrl" -ForegroundColor Blue
            Write-Host "API Docs: $serviceUrl/docs" -ForegroundColor Blue
            Write-Host "Health Check: $serviceUrl/health" -ForegroundColor Blue
            Write-Host "Status: $serviceUrl/status" -ForegroundColor Blue
        } else {
            Write-Host "❌ Deployment failed" -ForegroundColor Red
        }
    }
    
    "2" {
        Write-Host "🏗️ Deploying to App Engine..." -ForegroundColor Cyan
        
        # Get project ID
        $projectId = Read-Host "Enter your GCP Project ID"
        if (-not $projectId) {
            Write-Host "❌ Project ID required" -ForegroundColor Red
            exit 1
        }
        
        # Get API keys
        $googleApiKey = Read-Host "Enter your Google API Key (for Gemini)"
        $serpApiKey = Read-Host "Enter your SerpAPI Key"
        
        # Set environment variables
        $env:GOOGLE_API_KEY = $googleApiKey
        $env:SERPAPI_API_KEY = $serpApiKey
        
        # Set project
        gcloud config set project $projectId
        
        # Enable App Engine API
        Write-Host "🔌 Enabling App Engine API..." -ForegroundColor Yellow
        gcloud services enable appengine.googleapis.com
        
        # Create App Engine app if it doesn't exist
        Write-Host "🏗️ Setting up App Engine..." -ForegroundColor Yellow
        gcloud app create --region=us-central 2>$null
        
        # Deploy
        Write-Host "🚀 Deploying to App Engine..." -ForegroundColor Yellow
        gcloud app deploy app.yaml --quiet
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "🎉 Deployment successful!" -ForegroundColor Green
            Write-Host ""
            Write-Host "🌍 Opening your app..." -ForegroundColor Yellow
            gcloud app browse
        } else {
            Write-Host "❌ Deployment failed" -ForegroundColor Red
        }
    }
    
    "3" {
        Write-Host "🔧 Setting up Cloud Build..." -ForegroundColor Cyan
        Write-Host ""
        Write-Host "This will set up automated deployments from your Git repository." -ForegroundColor Yellow
        Write-Host ""
        
        $projectId = Read-Host "Enter your GCP Project ID"
        $repoOwner = Read-Host "Enter your GitHub username/organization"
        $repoName = Read-Host "Enter your repository name"
        
        # Set project
        gcloud config set project $projectId
        
        # Enable APIs
        Write-Host "🔌 Enabling required APIs..." -ForegroundColor Yellow
        gcloud services enable cloudbuild.googleapis.com
        gcloud services enable run.googleapis.com
        gcloud services enable sourcerepo.googleapis.com
        
        Write-Host ""
        Write-Host "📋 Next steps:" -ForegroundColor Cyan
        Write-Host "1. Go to Cloud Console: https://console.cloud.google.com/cloud-build/triggers" -ForegroundColor Blue
        Write-Host "2. Click 'Create Trigger'" -ForegroundColor Blue
        Write-Host "3. Connect your GitHub repository: $repoOwner/$repoName" -ForegroundColor Blue
        Write-Host "4. Set branch pattern: ^main$" -ForegroundColor Blue
        Write-Host "5. Set build config: cloudbuild.yaml" -ForegroundColor Blue
        Write-Host "6. Add substitution variables:" -ForegroundColor Blue
        Write-Host "   _GOOGLE_API_KEY: your-google-api-key" -ForegroundColor Blue
        Write-Host "   _SERPAPI_API_KEY: your-serpapi-key" -ForegroundColor Blue
        Write-Host ""
        Write-Host "After setup, every push to main branch will trigger automatic deployment!" -ForegroundColor Green
    }
    
    default {
        Write-Host "❌ Invalid choice" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Read-Host "Press Enter to exit"
