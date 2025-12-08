@echo off
echo ========================================
echo   ReBox Backend Setup Script
echo ========================================
echo.

cd /d "%~dp0..\BE"

echo [1/6] Installing Composer dependencies...
call composer install
if %errorlevel% neq 0 (
    echo Error: Composer install failed!
    pause
    exit /b 1
)
echo.

echo [2/6] Copying .env file...
if not exist .env (
    copy .env.example .env
    echo .env file created!
) else (
    echo .env already exists, skipping...
)
echo.

echo [3/6] Generating application key...
call php artisan key:generate
echo.

echo [4/6] Running database migrations...
call php artisan migrate:fresh --seed
if %errorlevel% neq 0 (
    echo.
    echo ==========================================
    echo   WARNING: Migration failed!
    echo   Please check your database configuration
    echo   in the .env file and try again.
    echo ==========================================
    echo.
    echo Press any key to continue anyway...
    pause >nul
)
echo.

echo ========================================
echo   Setup Complete!
echo ========================================
echo.
echo Demo Accounts:
echo   - Email: demo@rebox.com
echo   - Password: password123
echo.
echo   - Email: john@example.com  
echo   - Password: password123
echo.
echo To start the server, run:
echo   php artisan serve --host=10.4.5.19 --port=8000
echo.
echo Or for localhost only:
echo   php artisan serve
echo.
pause
