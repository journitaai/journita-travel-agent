@echo off
echo 🧪 TESTING YOUR DEPLOYED APP
echo ============================
echo.

set /p URL="Enter your Render app URL (or press Enter for default): "
if "%URL%"=="" set URL=https://journita-travel-agent.onrender.com

echo.
echo 🔍 Testing your deployed app at: %URL%
echo.

echo 1. Testing health endpoint...
curl -s "%URL%/health" > nul
if %errorlevel% equ 0 (
    echo ✅ Health check: PASSED
) else (
    echo ❌ Health check: FAILED
)

echo.
echo 2. Testing API documentation...
curl -s "%URL%/docs" > nul
if %errorlevel% equ 0 (
    echo ✅ API docs: ACCESSIBLE
) else (
    echo ❌ API docs: INACCESSIBLE
)

echo.
echo 3. Testing main frontend...
curl -s "%URL%/" > nul
if %errorlevel% equ 0 (
    echo ✅ Frontend: ACCESSIBLE
) else (
    echo ❌ Frontend: INACCESSIBLE
)

echo.
echo 🌐 ACCESS YOUR APP:
echo Frontend: %URL%
echo API Docs: %URL%/docs
echo Health: %URL%/health
echo.

echo 🎯 TEST FEATURES:
echo 1. Open frontend URL in browser
echo 2. Try asking: "Plan a trip to Paris"
echo 3. Test flight search: "Find flights from NYC to London"
echo 4. Test hotel search: "Hotels in Tokyo under $200"
echo.

start %URL%
echo.
echo 🎉 Browser opened with your live app!
echo.
pause
