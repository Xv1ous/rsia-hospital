# Cross-Platform Build Setup

## Overview

This project now supports seamless building on both **Windows** and **Linux/macOS** environments. The build system automatically detects your operating system and uses the appropriate npm executables and commands.

## Key Features

- ✅ **Automatic OS Detection**: Maven profiles automatically detect Windows vs Unix systems
- ✅ **Cross-Platform npm Commands**: Uses `npm.cmd` on Windows, `npm` on Unix
- ✅ **Environment Variable Handling**: Uses `cross-env` for Windows compatibility
- ✅ **Frontend Asset Building**: Automatic Tailwind CSS compilation during build
- ✅ **Development Mode**: File watching with hot reload support

## Build System Components

### 1. Maven Profiles

The POM.xml includes OS-specific profiles:

```xml
<profiles>
    <!-- Windows profile -->
    <profile>
        <id>windows</id>
        <activation>
            <os><family>windows</family></os>
        </activation>
        <properties>
            <npm.executable>npm.cmd</npm.executable>
            <npx.executable>npx.cmd</npx.executable>
        </properties>
    </profile>
    
    <!-- Unix profile (Linux/Mac) -->
    <profile>
        <id>unix</id>
        <activation>
            <os><family>unix</family></os>
        </activation>
        <properties>
            <npm.executable>npm</npm.executable>
            <npx.executable>npx</npx.executable>
        </properties>
    </profile>
</profiles>
```

### 2. Frontend Build Pipeline

Uses the `paseq-maven-plugin` to orchestrate frontend builds:

- **Phase**: `compile` - Runs during Maven compile phase
- **Tasks**: 
  1. `npm install` - Install dependencies
  2. `npm run build` - Build and minify CSS

### 3. Cross-Platform Package Scripts

The `package.json` uses `cross-env` for environment variables:

```json
{
  "scripts": {
    "build": "cross-env NODE_ENV=production tailwindcss -i ./main.css -o ../resources/static/main.css --minify",
    "build:dev": "tailwindcss -i ./main.css -o ../resources/static/main.css",
    "watch": "tailwindcss -i ./main.css -o ../resources/static/main.css --watch"
  }
}
```

## Build Commands

### Standard Build

```bash
# Windows
.\mvnw.cmd clean compile

# Linux/macOS
./mvnw clean compile
```

### Full Package Build

```bash
# Windows
.\mvnw.cmd clean package -DskipTests

# Linux/macOS  
./mvnw clean package -DskipTests
```

### Development Mode (with file watching)

```bash
# Windows
.\mvnw.cmd paseq:exec@dev

# Linux/macOS
./mvnw paseq:exec@dev
```

## Build Scripts

Convenient build scripts are available in `scripts/simple/`:

### Windows
- `BUILD.bat` - Full build process
- `START.bat` - Start the application
- `STOP.bat` - Stop the application

### Linux/macOS
- `build.sh` - Full build process
- `start.sh` - Start the application
- `stop.sh` - Stop the application

## Prerequisites

### Required Software

1. **Java 21** - Required for Spring Boot 3.5.3
2. **Node.js & npm** - For frontend asset building
   - Windows: Ensure Node.js is in your PATH
   - Linux/macOS: Install via package manager or nvm

### Verification

Check your setup:

```bash
# Check Java version
java -version

# Check Node.js and npm
node --version
npm --version
```

## Troubleshooting

### Common Issues

#### 1. "npm command not found" on Windows

**Problem**: Maven can't find npm even though it's installed.

**Solutions**:
- Restart your terminal/IDE after installing Node.js
- Verify Node.js is in your PATH: `echo $env:PATH` (PowerShell)
- Try running: `npm --version` in your terminal

#### 2. SSL Certificate Issues

**Problem**: Maven fails to download dependencies with SSL errors.

**Solution**: Ensure your system clock is correct. SSL certificates are time-sensitive.

#### 3. Frontend Build Fails

**Problem**: Tailwind CSS build errors.

**Solutions**:
- Run `npm install` manually in `src/main/frontend/`
- Check if `tailwind.config.js` exists
- Verify `main.css` exists in the frontend directory

### Debug Mode

Run Maven with debug flags for detailed error information:

```bash
# Windows
.\mvnw.cmd clean compile -X -e

# Linux/macOS
./mvnw clean compile -X -e
```

## Development Workflow

### 1. Initial Setup

```bash
# Clone repository
git clone <your-repo-url>
cd rsia-hospital

# First build (installs dependencies)
.\mvnw.cmd clean compile  # Windows
./mvnw clean compile     # Linux/macOS
```

### 2. Development Mode

For active development with file watching:

```bash
# Start development mode
.\mvnw.cmd paseq:exec@dev  # Windows
./mvnw paseq:exec@dev     # Linux/macOS
```

This will:
- Install npm dependencies
- Start Tailwind CSS file watching
- Start Spring Boot application
- Auto-reload CSS changes

### 3. Production Build

```bash
# Create production JAR
.\mvnw.cmd clean package -DskipTests  # Windows
./mvnw clean package -DskipTests     # Linux/macOS
```

The production JAR will be available at:
`target/hospital-0.0.1-SNAPSHOT.jar`

## File Structure

```
rsia-hospital/
├── src/main/frontend/          # Frontend source files
│   ├── package.json           # npm dependencies & scripts
│   ├── tailwind.config.js     # Tailwind configuration
│   └── main.css              # Source CSS file
├── src/main/resources/static/ # Built frontend assets
│   └── main.css              # Compiled & minified CSS
├── scripts/simple/            # Build scripts
│   ├── BUILD.bat             # Windows build script
│   └── build.sh              # Unix build script
└── pom.xml                   # Maven configuration
```

## Continuous Integration

For CI/CD pipelines, use the appropriate commands:

```yaml
# GitHub Actions example
- name: Build on Windows
  if: runner.os == 'Windows'
  run: .\mvnw.cmd clean package -DskipTests

- name: Build on Unix
  if: runner.os != 'Windows'  
  run: ./mvnw clean package -DskipTests
```

## Contributing

When contributing to the project:

1. Test builds on both Windows and Linux if possible
2. Ensure frontend changes work with the build pipeline
3. Update documentation for any build-related changes
4. Run the full build before submitting PRs

## Support

For build-related issues:
1. Check this documentation first
2. Review the troubleshooting section
3. Run builds with debug flags (`-X -e`)
4. Create an issue with full error logs
