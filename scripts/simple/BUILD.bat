@echo off
setlocal enabledelayedexpansion

echo.
echo ========================================
echo     HOSPITAL APP - BUILD PROJECT
echo ========================================
echo.

REM Get the directory where this script is located
set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%..\.."

REM Change to project root
cd /d "%PROJECT_ROOT%"

echo Building project from: %PROJECT_ROOT%
echo.

REM Check if Maven wrapper exists
if not exist "mvnw.cmd" (
    echo [ERROR] Maven wrapper (mvnw.cmd) not found!
    echo Please ensure you're running this script from the project root directory.
    pause
    exit /b 1
)

echo [1/4] Cleaning previous build...
call mvnw.cmd clean
if errorlevel 1 (
    echo [ERROR] Clean failed!
    pause
    exit /b 1
)
echo [✓] Clean completed

echo.
echo [2/4] Installing dependencies...
call mvnw.cmd dependency:resolve
if errorlevel 1 (
    echo [ERROR] Dependency resolution failed!
    pause
    exit /b 1
)
echo [✓] Dependencies resolved

echo.
echo [3/4] Building frontend assets...
call mvnw.cmd compile -DskipTests
if errorlevel 1 (
    echo [ERROR] Frontend build failed!
    pause
    exit /b 1
)
echo [✓] Frontend assets built

echo.
echo [4/4] Creating JAR file...
call mvnw.cmd package -DskipTests
if errorlevel 1 (
    echo [ERROR] JAR creation failed!
    pause
    exit /b 1
)
echo [✓] JAR file created

echo.
echo ========================================
echo     BUILD COMPLETED SUCCESSFULLY!
echo ========================================
echo.

REM Check if JAR file was created
if exist "target\hospital-0.0.1-SNAPSHOT.jar" (
    for %%A in (target\hospital-0.0.1-SNAPSHOT.jar) do set "JAR_SIZE=%%~zA"
    set /a "JAR_SIZE_MB=!JAR_SIZE!/1024/1024"
    echo [✓] JAR file created: target\hospital-0.0.1-SNAPSHOT.jar (!JAR_SIZE_MB! MB)
) else (
    echo [ERROR] JAR file not found in target directory!
    pause
    exit /b 1
)

echo.
echo 🎉 Project built successfully!
echo.
echo Next steps:
echo   🚀 Start application: scripts\simple\START.bat
echo   🗄️  Initialize database: scripts\simple\INITIALIZE-DB.bat
echo   🛑 Stop application: scripts\simple\STOP.bat
echo.
echo Application will be available at: http://localhost:8080
echo Admin login: admin / admin123
echo.

pause
