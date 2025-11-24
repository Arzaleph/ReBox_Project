@echo off
echo ========================================
echo   ReBox - Complete Setup
echo ========================================
echo.
echo This will setup both Backend and Frontend
echo.
pause

echo.
echo ========================================
echo   STEP 1: Backend Setup
echo ========================================
echo.
call "%~dp0setup_backend.bat"

echo.
echo ========================================
echo   STEP 2: Frontend Setup  
echo ========================================
echo.
call "%~dp0setup_frontend.bat"

echo.
echo ========================================
echo   ALL DONE!
echo ========================================
echo.
echo Next steps:
echo   1. Start Laravel server: scripts\start_server.bat
echo   2. Run Flutter app: flutter run
echo.
echo For detailed instructions, see README.md
echo.
pause
