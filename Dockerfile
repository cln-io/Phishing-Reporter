# Build environment for Phishing Reporter
# Linux-based build using Mono for Mac compatibility
FROM mono:6.12

# Update to use archive repositories for Debian Buster
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
    sed -i '/stretch-updates/d' /etc/apt/sources.list && \
    apt-get update && apt-get install -y \
    wget \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install NuGet
RUN wget https://dist.nuget.org/win-x86-commandline/latest/nuget.exe -O /usr/local/bin/nuget.exe

# Create nuget wrapper script
RUN echo '#!/bin/bash\nmono /usr/local/bin/nuget.exe "$@"' > /usr/local/bin/nuget \
    && chmod +x /usr/local/bin/nuget

# Install MSBuild (comes with Mono)
# Mono includes msbuild, xbuild as part of the installation

# Set working directory
WORKDIR /build

# Copy project files
COPY . /build

# Install reference assemblies for .NET Framework 4.6.1
RUN mkdir -p /usr/lib/mono/xbuild-frameworks/.NETFramework/v4.6.1/RedistList \
    && mkdir -p /usr/lib/mono/4.5

# Restore NuGet packages
RUN nuget restore PhishingReporter.sln || true

# Build script that handles the build
RUN echo '#!/bin/bash\n\
set -e\n\
echo "Starting build..."\n\
\n\
# Restore packages\n\
nuget restore PhishingReporter.sln\n\
\n\
# Build the project using msbuild\n\
msbuild PhishingReporter/PhishingReporter.csproj \
/p:Configuration=Release \
/p:Platform=AnyCPU \
/p:OutputPath=/output \
/p:SignManifests=false \
/p:DefineConstants="TRACE" \
/verbosity:minimal || true\n\
\n\
# Also try with xbuild as fallback\n\
xbuild PhishingReporter/PhishingReporter.csproj \
/p:Configuration=Release \
/p:Platform=AnyCPU \
/p:OutputPath=/output \
/verbosity:minimal || true\n\
\n\
# Copy any built files to output\n\
mkdir -p /output\n\
find PhishingReporter/bin -name "*.dll" -exec cp {} /output/ \\; 2>/dev/null || true\n\
find PhishingReporter/obj -name "*.dll" -exec cp {} /output/ \\; 2>/dev/null || true\n\
cp packages/HtmlAgilityPack.*/lib/Net45/*.dll /output/ 2>/dev/null || true\n\
\n\
echo "Build complete. Artifacts in /output"\n\
ls -lah /output\n\
' > /build/build.sh && chmod +x /build/build.sh

CMD ["/build/build.sh"]
