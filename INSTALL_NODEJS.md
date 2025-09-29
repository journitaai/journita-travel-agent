# Node.js Installation Guide for Windows

## 🚀 Quick Install Node.js

### Option 1: Download from Official Website (Recommended)

1. **Go to**: https://nodejs.org/
2. **Download**: LTS version (Long Term Support) - usually the green button
3. **Run**: the downloaded .msi installer
4. **Follow**: the installation wizard (accept defaults)
5. **Verify**: Open new PowerShell/Command Prompt and run:
   ```
   node --version
   npm --version
   ```

### Option 2: Using Chocolatey (if you have it)

```powershell
choco install nodejs
```

### Option 3: Using Winget (Windows Package Manager)

```powershell
winget install OpenJS.NodeJS
```

## 🎯 After Installation

Once Node.js is installed, you can run the frontend:

### Method 1: Using the Script
```bash
# Navigate to project directory
cd "C:\Users\PC\Desktop\journita-travel-agent"

# Run the frontend startup script
start_frontend.bat
```

### Method 2: Manual Steps
```bash
# Navigate to frontend directory
cd "C:\Users\PC\Desktop\journita-travel-agent\frontend"

# Install dependencies
npm install

# Start the development server
npm start
```

## 📝 What to Expect

- Node.js installation takes 2-3 minutes
- First `npm install` takes 1-2 minutes (downloads packages)
- `npm start` opens browser automatically at http://localhost:3000
- Frontend will connect to your backend at http://localhost:8000

## ⚠️ Troubleshooting

If you get permission errors:
1. Run PowerShell as Administrator
2. Or use Command Prompt instead

## 🔄 Next Steps

After installing Node.js:
1. **Restart your terminal/PowerShell**
2. **Run the backend** (if not already running): `python production_server.py`
3. **Run the frontend**: Use the startup script or manual commands above
4. **Open browser**: http://localhost:3000

The React frontend will automatically connect to your FastAPI backend!
