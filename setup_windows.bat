@echo off
setlocal
echo [1/6] Checking Flutter...
where flutter >nul 2>nul || (
  echo Flutter was not found in PATH. Install Flutter Stable first.
  exit /b 1
)
echo [2/6] Completing Android and Web platform files...
set "BACKUP_DIR=%TEMP%\lingonexa_platform_backup"
if exist "%BACKUP_DIR%" rmdir /s /q "%BACKUP_DIR%"
mkdir "%BACKUP_DIR%"
xcopy android "%BACKUP_DIR%\android\" /E /I /Q /Y >nul
xcopy web "%BACKUP_DIR%\web\" /E /I /Q /Y >nul
call flutter create --platforms=android,web --org com.lingonexa . || exit /b 1
xcopy "%BACKUP_DIR%\android" android\ /E /I /Q /Y >nul
xcopy "%BACKUP_DIR%\web" web\ /E /I /Q /Y >nul
rmdir /s /q "%BACKUP_DIR%"
if exist "android\settings.gradle.kts" del /q "android\settings.gradle" 2>nul
if exist "android\build.gradle.kts" del /q "android\build.gradle" 2>nul
if exist "android\app\build.gradle.kts" del /q "android\app\build.gradle" 2>nul
echo [3/6] Installing packages...
call flutter pub get || exit /b 1
echo [4/6] Formatting Dart sources...
call dart format lib test tool || exit /b 1
call dart format --output=none --set-exit-if-changed lib test tool || exit /b 1
call dart run tool\verify_academy.dart || exit /b 1
echo [5/6] Analyzing source...
call flutter analyze --no-fatal-infos --no-fatal-warnings || exit /b 1
echo [6/6] Running tests...
call flutter test || exit /b 1
echo.
echo LingoNexa is ready. Run: flutter run
endlocal
