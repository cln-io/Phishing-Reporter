# Building Phishing Reporter

This is a .NET Framework 4.6.1 VSTO (Visual Studio Tools for Office) add-in for Outlook.

## ⭐ Recommended: Download from GitHub Actions

The easiest and most reliable way to get compiled builds on Mac:

```bash
./build-local.sh
```

This downloads the latest successful build from GitHub Actions to `./output/`.

**Why this is best:**
- ✅ Works perfectly every time
- ✅ No local setup required
- ✅ Builds use proper Windows/.NET Framework environment
- ✅ Automatic builds on every push

## Option 2: Trigger Manual Build

```bash
# Trigger a new build
gh workflow run build.yml

# Watch the build
gh run watch $(gh run list --limit 1 --json databaseId --jq '.[0].databaseId')

# Download when complete
./build-local.sh
```

## Option 3: Build on Windows (If Available)

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

## About Docker/Mono Build

⚠️ **Note:** Docker builds with Mono are **not reliable** for VSTO projects. .NET Framework VSTO projects require Windows-specific APIs that don't work properly with Mono on Linux. The GitHub Actions approach above uses real Windows runners and is the recommended solution.

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

## GitHub Actions Workflow

The project automatically builds on:
- Every push to `master` branch
- Pull requests
- Manual workflow dispatch

View builds at: https://github.com/cln-io/Phishing-Reporter/actions
