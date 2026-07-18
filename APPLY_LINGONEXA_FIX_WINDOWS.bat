@echo off
setlocal
cd /d "%~dp0"

echo Cleaning obsolete workflows and conflicting Android Gradle files...

if exist ".github\workflows\dart.yml" del /q ".github\workflows\dart.yml"
if exist ".github\workflows\dart.yaml" del /q ".github\workflows\dart.yaml"
if exist ".github\workflows\build.yml" del /q ".github\workflows\build.yml"

if exist "android\settings.gradle.kts" if exist "android\settings.gradle" del /q "android\settings.gradle"
if exist "android\build.gradle.kts" if exist "android\build.gradle" del /q "android\build.gradle"
if exist "android\app\build.gradle.kts" if exist "android\app\build.gradle" del /q "android\app\build.gradle"

echo.
echo Cleanup complete.
echo Return to GitHub Desktop, commit every change, then Push origin.
pause
endlocal
