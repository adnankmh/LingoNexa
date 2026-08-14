@echo off
setlocal
cd /d "%~dp0"
echo ============================================
echo  LingoNexa Laravel - First Time Setup
echo ============================================
where php >nul 2>&1 || (echo [ERROR] PHP is not in PATH.& pause & exit /b 1)
where composer >nul 2>&1 || (echo [ERROR] Composer is not in PATH.& pause & exit /b 1)
if not exist .env copy /Y .env.example .env >nul
if not exist database\database.sqlite type nul > database\database.sqlite
echo [1/4] Installing PHP dependencies...
call composer install --no-interaction || goto :fail
echo [2/4] Generating app key...
php artisan key:generate --force || goto :fail
echo [3/4] Running migrations...
php artisan migrate --force || goto :fail
echo [4/4] Clearing caches...
php artisan optimize:clear || goto :fail
echo.
echo [OK] Setup complete.
echo Run START_WINDOWS.bat and open http://127.0.0.1:8000
pause
exit /b 0
:fail
echo.
echo [ERROR] Setup stopped. Read the error above.
pause
exit /b 1
