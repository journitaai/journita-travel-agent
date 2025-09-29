# 🆓 FREE HOSTING DEPLOYMENT GUIDE
# Journita Travel Agent - Deploy to Render.com for FREE

## 🚀 INSTANT DEPLOYMENT STEPS

### Step 1: Go to Render.com
1. Open your web browser
2. Go to: **https://render.com**
3. Click **"Get Started for Free"**

### Step 2: Connect GitHub
1. Click **"GitHub"** to sign up with GitHub
2. Authorize Render to access your repositories
3. You'll be redirected to the Render dashboard

### Step 3: Create Web Service
1. Click **"New +"** button (top right)
2. Select **"Web Service"**
3. Click **"Connect account"** if needed
4. Find your repository: **journitaai/journita-travel-agent**
5. Click **"Connect"**

### Step 4: Configure Deployment
Render will auto-detect your `render.yaml` file! You'll see:

**✅ Detected Configuration:**
- Service Name: `journita-travel-agent`
- Runtime: `Docker`
- Plan: `Free` (0$/month)
- Region: `Oregon`
- Branch: `main`

### Step 5: Add Environment Variables
In the "Environment Variables" section, add:

**Required Variables:**
```
GOOGLE_API_KEY = AIzaSyA6sguZtHPjMlm98Vs67L1_Z-N8rZpAd3c
SERPAPI_API_KEY = b780bdfaefd3f5cbf1d17e85a4afd8afd550d4f6c994372941d6fb03aa925744
```

**Optional Variables (already configured):**
```
ENVIRONMENT = production
PORT = 8080
```

### Step 6: Deploy!
1. Click **"Create Web Service"**
2. Render will automatically:
   - Clone your repository
   - Build your Docker container
   - Deploy your application
   - Provide a live URL

## 🎉 YOUR FREE LIVE URLs

After deployment (5-10 minutes), your app will be available at:

**🌍 Main App:** https://journita-travel-agent.onrender.com
**📚 API Docs:** https://journita-travel-agent.onrender.com/docs
**❤️ Health Check:** https://journita-travel-agent.onrender.com/health

## 🆓 FREE TIER FEATURES

**✅ What's Included (FREE):**
- 512 MB RAM
- Shared CPU
- 100 GB bandwidth/month
- Custom domain support
- Automatic HTTPS/SSL
- GitHub integration
- Automatic deploys on git push
- Build time: Up to 90 minutes/month

**⚠️ Free Tier Limitations:**
- Apps sleep after 15 minutes of inactivity
- Cold start: 10-30 seconds wake-up time
- Limited to 100 hours/month of active usage

## 🚀 UPGRADE OPTIONS (Later)

If you need more power:
- **Starter Plan ($7/month)**: Always online, faster builds
- **Standard Plan ($25/month)**: More RAM, dedicated CPU
- **Pro Plan ($85/month)**: High performance, priority support

## 🔄 AUTOMATIC UPDATES

Your app will automatically redeploy when you:
1. Push changes to the `main` branch on GitHub
2. Render detects changes and rebuilds
3. New version goes live automatically

## 🎯 WHAT YOUR USERS WILL GET

**🤖 AI Travel Assistant**
- Powered by Google Gemini 2.0 Flash
- Natural conversation about travel plans
- Personalized recommendations

**✈️ Real-time Flight Search**
- Live flight data via SerpAPI
- Price comparisons
- Booking assistance

**🏨 Hotel Recommendations**
- Real-time availability
- Price comparisons
- Location-based suggestions

**📱 Modern Interface**
- Responsive design (mobile + desktop)
- Fast, modern React frontend
- Streaming AI responses

## 🆘 TROUBLESHOOTING

**If deployment fails:**
1. Check environment variables are set correctly
2. Ensure GitHub repository is public or accessible
3. Check build logs in Render dashboard
4. Verify Dockerfile.gcp exists in repository

**If app shows errors:**
1. Check environment variables contain valid API keys
2. Verify health endpoint: `/health`
3. Check application logs in Render dashboard

## 📞 SUPPORT

**Free Support:**
- Render community forum
- GitHub issues in your repository
- Render documentation

**Need Help?**
1. Check Render dashboard logs
2. Test locally first: `python gcp_server.py`
3. Verify API keys are working

---

## ⚡ QUICK SUMMARY

1. **Go to:** https://render.com
2. **Connect:** Your GitHub account
3. **Create:** New Web Service from `journitaai/journita-travel-agent`
4. **Add:** Your API keys as environment variables
5. **Deploy:** Click "Create Web Service"
6. **Wait:** 5-10 minutes for build
7. **Access:** Your live app at the provided URL

🎉 **That's it! Your AI travel agent is now live and FREE!**
