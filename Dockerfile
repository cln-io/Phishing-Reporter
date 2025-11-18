# Build environment for Phishing Reporter
# Note: This requires Windows containers (not available natively on Mac)
# Use with: docker build --platform windows/amd64 -t phishing-reporter-builder .

FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019

# Set working directory
WORKDIR C:\\build

# Install Chocolatey
RUN powershell -Command \
    Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install build dependencies
RUN choco install -y netfx-4.6.1-devpack
RUN choco install -y nuget.commandline

# Install Visual Studio Build Tools 2022 with Office tools
RUN choco install -y visualstudio2022buildtools --package-parameters "--add Microsoft.VisualStudio.Workload.OfficeDevTools --add Microsoft.VisualStudio.Workload.NetFramework --includeRecommended --quiet"

# Copy project files
COPY . C:\\build

# Restore NuGet packages
RUN nuget restore PhishingReporter.sln

# Build the project
RUN msbuild PhishingReporter\PhishingReporter.csproj /t:"ResolveReferences;CoreCompile;_CopyFilesMarkedCopyLocal;_CopyAppConfigFile;CopyFilesToOutputDirectory" /p:Configuration=Release /p:Platform=AnyCPU /p:VisualStudioVersion=17.0

# Output artifacts
CMD ["powershell", "-Command", "Copy-Item -Path 'PhishingReporter\\bin\\Release\\*' -Destination 'C:\\output' -Recurse -Force"]
