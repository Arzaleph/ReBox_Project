@echo off
echo ========================================
echo   Starting ReBox Laravel Server
echo ========================================
echo.

cd /d "%~dp0..\BE"

echo Server will run at:
echo   http://10.4.5.19:8000
echo.
echo API endpoint:
echo   http://10.4.5.19:8000/api
echo.
echo Press Ctrl+C to stop the server
echo.
echo ========================================
echo.

call php artisan serve --host=10.4.5.19 --port=8000

pause
