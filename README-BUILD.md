# Building Phishing Reporter

This project is a .NET Framework 4.6.1 VSTO (Visual Studio Tools for Office) add-in for Outlook.

## Option 1: Build with Docker on Mac (Recommended) 🐳

Build locally using Docker with Mono (works on Mac M1/M2/Intel):

### Quick Start

```bash
# Build with Docker
make build

# Or using docker-compose directly
docker-compose build
docker-compose run --rm builder
```

Artifacts will be in `./output/`.

### Available Make Commands

```bash
make build      # Build the project with Docker
make clean      # Clean up build artifacts
make rebuild    # Clean and rebuild
make run        # Build and show artifacts
make shell      # Open shell in build container
make download   # Download from GitHub Actions instead
```

## Option 2: Download from GitHub Actions (Fast)

If you just need the compiled DLL without building locally:

```bash
# Download latest successful build
./build-local.sh
```

This downloads pre-built artifacts from GitHub Actions to `./output/`.

### Manual download

You can also manually download artifacts from:
https://github.com/cln-io/Phishing-Reporter/actions/workflows/build.yml

## Option 3: Trigger GitHub Actions Build Manually

```bash
# Trigger a new build
gh workflow run build.yml

# Watch the build
gh run watch

# Download artifacts when complete
./build-local.sh
```

## Option 4: Build Directly on Windows (If Available)

If you have access to a Windows machine:

1. Install Visual Studio 2022 with Office development tools
2. Install .NET Framework 4.6.1 Developer Pack
3. Open `PhishingReporter.sln`
4. Build in Visual Studio (Release configuration)

Or use MSBuild from command line:

```cmd
nuget restore PhishingReporter.sln
msbuild PhishingReporter\PhishingReporter.csproj /t:"ResolveReferences;CoreCompile;_CopyFilesMarkedCopyLocal;_CopyAppConfigFile;CopyFilesToOutputDirectory" /p:Configuration=Release /p:Platform=AnyCPU
```

## Artifacts

After building, you'll find:
- `PhishingReporter.dll` - The main add-in DLL
- `PhishingReporter.dll.manifest` - Application manifest
- `HtmlAgilityPack.dll` - Dependency
- `PhishingReporter.dll.config` - Configuration file

## Troubleshooting

**"gh: command not found"**
```bash
brew install gh
gh auth login
```

**No successful builds found**
- The script will automatically trigger a new build
- Or manually trigger: `gh workflow run build.yml`

**Want to build a specific commit**
```bash
# Trigger build for current commit
gh workflow run build.yml --ref $(git rev-parse --abbrev-ref HEAD)
```
