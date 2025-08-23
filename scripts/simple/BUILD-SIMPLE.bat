@echo off
echo.
echo ========================================
echo     HOSPITAL APP - BUILD PROJECT
echo ========================================
echo.

cd /d "%~dp0..\.."

echo Building project from: %CD%
echo.

REM Try to use Maven directly if available
where mvn >nul 2>&1
if %errorlevel% equ 0 (
    echo [INFO] Using system Maven installation
    set "MAVEN_CMD=mvn"
) else (
    echo [INFO] System Maven not found, trying Maven wrapper
    if exist "mvnw.cmd" (
        set "MAVEN_CMD=mvnw.cmd"
    ) else (
        echo [ERROR] Neither Maven nor Maven wrapper found!
        echo Please install Maven or ensure mvnw.cmd exists.
        pause
        exit /b 1
    )
)

echo [1/4] Cleaning previous build...
call %MAVEN_CMD% clean
if errorlevel 1 (
    echo [ERROR] Clean failed!
    pause
    exit /b 1
)
echo [✓] Clean completed

echo.
echo [2/4] Installing dependencies...
call %MAVEN_CMD% dependency:resolve
if errorlevel 1 (
    echo [ERROR] Dependency resolution failed!
    pause
    exit /b 1
)
echo [✓] Dependencies resolved

echo.
echo [3/4] Building frontend assets...
call %MAVEN_CMD% compile -DskipTests
if errorlevel 1 (
    echo [ERROR] Frontend build failed!
    pause
    exit /b 1
)
echo [✓] Frontend assets built

echo.
echo [4/4] Creating JAR file...
call %MAVEN_CMD% package -DskipTests
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
