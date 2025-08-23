@echo off
echo.
echo ========================================
echo     HOSPITAL APP - BUILD PROJECT
echo ========================================
echo.

REM Navigate to project root more safely
set "CURRENT_DIR=%CD%"
if "%CURRENT_DIR:~-15%"=="scripts\simple" (
    cd ..\..
) else if "%CURRENT_DIR:~-8%"=="scripts" (
    cd ..
) else if "%CURRENT_DIR:~-7%"=="simple" (
    cd ..\..
)

echo Building project from: %CD%
echo.

if not exist "mvnw.cmd" (
    echo [ERROR] Maven wrapper not found!
    echo Please run this script from the project root directory.
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

if exist "target\hospital-0.0.1-SNAPSHOT.jar" (
    echo [✓] JAR file created successfully!
) else (
    echo [ERROR] JAR file not found!
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
