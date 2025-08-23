@echo off
setlocal enabledelayedexpansion

echo.
echo ========================================
echo     HOSPITAL APP - BUILD PROJECT
echo ========================================
echo.

REM ========================================
REM Resolve project root (2 levels up)
REM ========================================
set "SCRIPT_DIR=%~dp0"
for %%i in ("%SCRIPT_DIR%..\..") do set "PROJECT_ROOT=%%~fi"

cd /d "%PROJECT_ROOT%"
echo Building project from: %PROJECT_ROOT%
echo.

REM ========================================
REM Check Java
REM ========================================
java -version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Java not found! Please install JDK and set JAVA_HOME.
    pause
    exit /b 1
)

REM ========================================
REM Maven options (skip tests + TLS fix)
REM ========================================
set "MAVEN_OPTS=-DskipTests -Dhttps.protocols=TLSv1.2,TLSv1.3"

REM ========================================
REM Step 1: Clean
REM ========================================
echo [1/4] Cleaning previous build...
call mvnw.cmd clean %MAVEN_OPTS%
if errorlevel 1 (
    echo [ERROR] Clean failed!
    pause
    exit /b 1
)
echo [✓] Clean completed

REM ========================================
REM Step 2: Resolve dependencies
REM ========================================
echo.
echo [2/4] Installing dependencies...
call mvnw.cmd dependency:resolve %MAVEN_OPTS%
if errorlevel 1 (
    echo [ERROR] Dependency resolution failed!
    pause
    exit /b 1
)
echo [✓] Dependencies resolved

REM ========================================
REM Step 3: Compile / build assets
REM ========================================
echo.
echo [3/4] Building frontend assets...
call mvnw.cmd compile %MAVEN_OPTS%
if errorlevel 1 (
    echo [ERROR] Frontend build failed!
    pause
    exit /b 1
)
echo [✓] Frontend assets built

REM ========================================
REM Step 4: Package JAR
REM ========================================
echo.
echo [4/4] Creating JAR file...
call mvnw.cmd package %MAVEN_OPTS%
if errorlevel 1 (
    echo [ERROR] JAR creation failed!
    pause
    exit /b 1
)
echo [✓] JAR file created

REM ========================================
REM Verify JAR output
REM ========================================
echo.
if exist "target\hospital-0.0.1-SNAPSHOT.jar" (
    for %%A in (target\hospital-0.0.1-SNAPSHOT.jar) do set "JAR_SIZE=%%~zA"
    set /a "JAR_SIZE_MB=!JAR_SIZE!/1024/1024"
    echo [✓] JAR file created: target\hospital-0.0.1-SNAPSHOT.jar (!JAR_SIZE_MB! MB)
) else (
    echo [ERROR] JAR file not found in target directory!
    pause
    exit /b 1
)

REM ========================================
REM Success message
REM ========================================
echo.
echo ========================================
echo     BUILD COMPLETED SUCCESSFULLY!
echo ========================================
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
