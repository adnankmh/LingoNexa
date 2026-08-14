@echo off
cd /d "%~dp0"
if not exist vendor\autoload.php (
  echo [ERROR] Dependencies are missing. Run SETUP_WINDOWS.bat first.
  pause
  exit /b 1
)
php artisan serve --host=0.0.0.0 --port=8000
