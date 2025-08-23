# Build Troubleshooting Guide

This guide helps resolve common build issues encountered when building the RSIA Hospital application.

## Quick Diagnostics

Before diving into specific issues, run these commands to check your environment:

```bash
# Check Java version (should be 21+)
java -version

# Check Maven wrapper
.\mvnw.cmd --version  # Windows
./mvnw --version      # Linux/macOS

# Check Node.js and npm
node --version
npm --version

# Check if npm is accessible to Maven
where npm     # Windows
which npm     # Linux/macOS
```

## Common Issues & Solutions

### 1. "npm command not found" Error

**Error Message:**
```
Cannot run program "npm" (in directory "src\main\frontend"): 
CreateProcess error=2, The system cannot find the file specified
```

**Root Cause:** Maven cannot find the npm executable in the system PATH.

**Solutions:**

#### Windows Solutions:
1. **Restart Terminal/IDE:**
   ```bash
   # Close all terminals and IDE
   # Reopen PowerShell/Command Prompt
   # Try build again
   .\mvnw.cmd clean compile
   ```

2. **Verify Node.js Installation:**
   ```bash
   # Check if Node.js is installed
   node --version
   
   # Check if npm is in PATH
   where npm
   
   # If not found, reinstall Node.js from nodejs.org
   ```

3. **Manual PATH Update:**
   ```bash
   # Add Node.js to PATH temporarily
   $env:PATH += ";C:\Program Files\nodejs\"
   
   # Or permanently via System Properties > Environment Variables
   ```

#### Linux/macOS Solutions:
1. **Install Node.js via Package Manager:**
   ```bash
   # Ubuntu/Debian
   sudo apt update && sudo apt install nodejs npm
   
   # macOS with Homebrew
   brew install node
   
   # CentOS/RHEL
   sudo yum install nodejs npm
   ```

2. **Use Node Version Manager:**
   ```bash
   # Install nvm
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
   
   # Install latest LTS Node.js
   nvm install --lts
   nvm use --lts
   ```

### 2. SSL Certificate Validation Errors

**Error Message:**
```
PKIX path validation failed: java.security.cert.CertPathValidatorException: 
validity check failed
```

**Root Cause:** System clock is incorrect, causing SSL certificate validation to fail.

**Solutions:**

#### Windows:
1. **Sync System Clock:**
   ```bash
   # Open Command Prompt as Administrator
   w32tm /resync
   
   # Or manually sync via Settings > Time & Language > Date & time
   ```

2. **Check Date/Time:**
   ```bash
   # Verify current date
   Get-Date
   
   # Should show current date, not future date
   ```

#### Linux/macOS:
1. **Sync System Clock:**
   ```bash
   # Ubuntu/Debian
   sudo ntpdate -s time.nist.gov
   
   # macOS
   sudo sntp -sS time.apple.com
   ```

### 3. Frontend Build Failures

**Error Message:**
```
npm run build failed with exit code 1
```

**Solutions:**

1. **Clear npm Cache:**
   ```bash
   # Navigate to frontend directory
   cd src/main/frontend
   
   # Clear npm cache
   npm cache clean --force
   
   # Remove node_modules and reinstall
   rm -rf node_modules  # Linux/macOS
   rmdir /s node_modules  # Windows
   
   npm install
   ```

2. **Check Dependencies:**
   ```bash
   cd src/main/frontend
   
   # Check for missing dependencies
   npm audit
   
   # Fix vulnerabilities
   npm audit fix
   
   # Update dependencies
   npm update
   ```

3. **Manual Frontend Build:**
   ```bash
   cd src/main/frontend
   
   # Install dependencies
   npm install
   
   # Test build manually
   npm run build
   
   # If successful, try Maven build again
   ```

### 4. Java Version Issues

**Error Message:**
```
Unsupported class file major version XX
```

**Root Cause:** Wrong Java version (needs Java 21 for Spring Boot 3.5.3).

**Solutions:**

1. **Install Java 21:**
   ```bash
   # Download from Oracle or use package manager
   
   # Windows with Chocolatey
   choco install openjdk21
   
   # Linux
   sudo apt install openjdk-21-jdk  # Ubuntu
   sudo yum install java-21-openjdk  # CentOS
   
   # macOS with Homebrew
   brew install openjdk@21
   ```

2. **Set JAVA_HOME:**
   ```bash
   # Windows
   set JAVA_HOME=C:\Program Files\Java\jdk-21
   
   # Linux/macOS
   export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
   ```

### 5. Memory Issues

**Error Message:**
```
Java heap space
OutOfMemoryError
```

**Solutions:**

1. **Increase Maven Memory:**
   ```bash
   # Windows
   set MAVEN_OPTS=-Xmx2048m -XX:MaxPermSize=512m
   
   # Linux/macOS
   export MAVEN_OPTS="-Xmx2048m -XX:MaxPermSize=512m"
   ```

2. **Use Maven Wrapper with Memory Settings:**
   ```bash
   # Create .mvn/jvm.config file
   echo "-Xmx2048m" > .mvn/jvm.config
   ```

### 6. Permission Issues (Linux/macOS)

**Error Message:**
```
Permission denied
```

**Solutions:**

1. **Make Maven Wrapper Executable:**
   ```bash
   chmod +x mvnw
   ```

2. **Fix Directory Permissions:**
   ```bash
   # Fix permissions for project directory
   chmod -R 755 .
   
   # Fix specific script permissions
   chmod +x scripts/simple/*.sh
   ```

### 7. Port Already in Use

**Error Message:**
```
Port 8080 was already in use
```

**Solutions:**

1. **Find and Kill Process:**
   ```bash
   # Windows
   netstat -ano | findstr :8080
   taskkill /PID <PID> /F
   
   # Linux/macOS
   lsof -i :8080
   kill -9 <PID>
   ```

2. **Use Different Port:**
   ```bash
   # Add to application.properties
   server.port=8081
   
   # Or use environment variable
   export SERVER_PORT=8081
   ```

## Advanced Troubleshooting

### Enable Debug Logging

Run Maven with verbose output:

```bash
# Windows
.\mvnw.cmd clean compile -X -e

# Linux/macOS
./mvnw clean compile -X -e
```

### Check Plugin Configuration

Verify the paseq plugin is correctly configured:

```bash
# Show effective POM
.\mvnw.cmd help:effective-pom  # Windows
./mvnw help:effective-pom      # Linux/macOS
```

### Test Components Separately

1. **Test Java Build Only:**
   ```bash
   # Skip frontend build temporarily
   .\mvnw.cmd clean compile -Dmaven.paseq.skip=true
   ```

2. **Test Frontend Build Only:**
   ```bash
   cd src/main/frontend
   npm install
   npm run build
   ```

3. **Test Spring Boot Startup:**
   ```bash
   # After successful build
   java -jar target/hospital-0.0.1-SNAPSHOT.jar
   ```

## Environment-Specific Issues

### Windows Specific

1. **PowerShell Execution Policy:**
   ```powershell
   # If scripts won't run
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. **Long Path Issues:**
   ```bash
   # Enable long paths in Windows 10/11
   # Computer Configuration > Administrative Templates > System > Filesystem
   # Enable "Enable Win32 long paths"
   ```

### Linux/macOS Specific

1. **Missing Build Tools:**
   ```bash
   # Ubuntu/Debian
   sudo apt install build-essential
   
   # CentOS/RHEL
   sudo yum groupinstall "Development Tools"
   
   # macOS
   xcode-select --install
   ```

## Getting Help

If issues persist:

1. **Check Logs:** Look for specific error messages in Maven output
2. **Search Issues:** Check GitHub issues for similar problems
3. **Create Issue:** Include:
   - Operating system and version
   - Java version (`java -version`)
   - Node.js version (`node --version`)
   - Full error log with `-X -e` flags
   - Steps to reproduce

## Prevention Tips

1. **Keep Dependencies Updated:**
   ```bash
   # Check for updates regularly
   .\mvnw.cmd versions:display-dependency-updates
   ```

2. **Use Consistent Environments:**
   - Document required versions
   - Use Docker for consistent builds
   - Set up CI/CD with same versions

3. **Regular Maintenance:**
   ```bash
   # Clean builds occasionally
   .\mvnw.cmd clean
   
   # Clear npm cache
   npm cache clean --force
   
   # Update browserslist database
   npx update-browserslist-db@latest
   ```
