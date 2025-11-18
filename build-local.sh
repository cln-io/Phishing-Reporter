#!/bin/bash
# Local build script for Mac - Downloads artifacts from GitHub Actions
# This is the recommended approach for building on Mac since .NET Framework
# requires Windows containers which aren't natively supported on Mac.

set -e

echo "🔍 Checking for latest successful build..."

# Get the latest successful workflow run
RUN_ID=$(gh run list --workflow=build.yml --status=success --limit=1 --json databaseId --jq '.[0].databaseId')

if [ -z "$RUN_ID" ]; then
    echo "❌ No successful builds found. Triggering a new build..."
    gh workflow run build.yml
    echo "⏳ Waiting for build to start..."
    sleep 10

    # Wait for the build to complete
    gh run watch

    # Get the new run ID
    RUN_ID=$(gh run list --workflow=build.yml --status=success --limit=1 --json databaseId --jq '.[0].databaseId')
fi

echo "✅ Found successful build: $RUN_ID"
echo "📥 Downloading artifacts..."

# Create output directory
mkdir -p ./output

# Download artifacts
gh run download $RUN_ID -n PhishingReporter-Build -D ./output

echo "✅ Build artifacts downloaded to ./output"
echo ""
echo "📦 Contents:"
ls -lh ./output

echo ""
echo "🎉 Done! The compiled DLL is in ./output/PhishingReporter.dll"
