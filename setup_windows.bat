@echo off
setlocal
echo [1/5] Checking Flutter...
where flutter >nul 2>nul || (
  echo Flutter was not found in PATH. Install Flutter Stable first.
  exit /b 1
)
echo [2/5] Completing Android and Web platform files...
set "BACKUP_DIR=%TEMP%\lingonexa_platform_backup"
if exist "%BACKUP_DIR%" rmdir /s /q "%BACKUP_DIR%"
mkdir "%BACKUP_DIR%"
xcopy android "%BACKUP_DIR%\android\" /E /I /Q /Y >nul
xcopy web "%BACKUP_DIR%\web\" /E /I /Q /Y >nul
call flutter create --platforms=android,web --org com.lingonexa . || exit /b 1
xcopy "%BACKUP_DIR%\android" android\ /E /I /Q /Y >nul
xcopy "%BACKUP_DIR%\web" web\ /E /I /Q /Y >nul
rmdir /s /q "%BACKUP_DIR%"
echo [3/5] Installing packages...
call flutter pub get || exit /b 1
echo [4/5] Analyzing source...
call flutter analyze --no-fatal-infos --no-fatal-warnings || exit /b 1
echo [5/5] Running tests...
call flutter test || exit /b 1
echo.
echo LingoNexa is ready. Run: flutter run
endlocal
