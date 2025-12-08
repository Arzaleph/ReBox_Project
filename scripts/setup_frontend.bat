@echo off
echo ========================================
echo   ReBox Frontend Setup Script
echo ========================================
echo.

cd /d "%~dp0..\"

echo [1/2] Installing Flutter dependencies...
call flutter pub get
if %errorlevel% neq 0 (
    echo Error: Flutter pub get failed!
    pause
    exit /b 1
)
echo.

echo [2/2] Checking Flutter configuration...
call flutter doctor
echo.

echo ========================================
echo   Setup Complete!
echo ========================================
echo.
echo Current API Configuration:
echo   Base URL: http://10.4.5.19:8000/api
echo.
echo To change API URL, edit:
echo   lib/core/services/api_service.dart
echo.
echo IMPORTANT:
echo   - For Android Emulator: http://10.0.2.2:8000/api
echo   - For Physical Device: http://10.4.5.19:8000/api
echo   - Make sure Laravel server is running!
echo.
echo To run the app:
echo   flutter run
echo.
pause
