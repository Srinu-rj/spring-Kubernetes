#!/bin/bash

# --- JFrog Artifactory Standalone (ZIP) Installation Script for Git Bash ---

echo "Starting JFrog Artifactory standalone installation script in Git Bash..."

# 1. Define variables
JFROG_INSTALL_DIR="$HOME/jfrog/artifactory" # Use Windows path format for Git Bash
DOWNLOAD_URL="https://releases.jfrog.io/artifactory/org/artifactory/oss/jfrog-artifactory-oss/7.90.0/jfrog-artifactory-oss-7.90.0-dist.zip" # CHECK JFROG FOR LATEST VERSION
ZIP_FILE="jfrog-artifactory-oss.zip"

echo "Installation directory: $JFROG_INSTALL_DIR"
echo "Download URL: $DOWNLOAD_URL"

# 2. Create installation directory
mkdir -p "$JFROG_INSTALL_DIR"
if [ $? -ne 0 ]; then
    echo "Failed to create directory $JFROG_INSTALL_DIR. Exiting."
    exit 1
fi
echo "Directory created: $JFROG_INSTALL_DIR"

# 3. Download Artifactory ZIP
echo "Downloading Artifactory ZIP file..."
curl -L -o "$ZIP_FILE" "$DOWNLOAD_URL"
if [ $? -ne 0 ]; then
    echo "Failed to download Artifactory ZIP. Exiting."
    rm -f "$ZIP_FILE" # Clean up partial download
    exit 1
fi
echo "Artifactory ZIP downloaded."

# 4. Unzip the archive
echo "Unzipping Artifactory to $JFROG_INSTALL_DIR..."
unzip "$ZIP_FILE" -d "$JFROG_INSTALL_DIR"
if [ $? -ne 0 ]; then
    echo "Failed to unzip Artifactory. Exiting."
    rm -f "$ZIP_FILE"
    exit 1
fi
echo "Artifactory unzipped."

# 5. Clean up downloaded ZIP
rm "$ZIP_FILE"
echo "Cleaned up ZIP file."

# 6. Start Artifactory (using the provided startup script within the unzipped folder)
# IMPORTANT: This will run in the foreground. For background, you need to manage the process.
# This script assumes you are running the service manually for now.
# For background service, you'd typically install it as a Windows service.

ART_HOME=$(ls -d "$JFROG_INSTALL_DIR"/artifactory-oss-*) # Adjust for Pro
if [ -d "$ART_HOME" ]; then
    echo "JFrog Artifactory installed to: $ART_HOME"
    echo "To start Artifactory, navigate to $ART_HOME/bin and run artifactory.bat (Windows batch file)."
    echo "Example: cd '$ART_HOME/bin' && ./artifactory.bat"
else
    echo "Could not locate Artifactory home directory after unzipping."
    exit 1
fi

echo "JFrog Artifactory installation script finished."
echo "Remember to configure Java (JDK 11 or 17) and environment variables if needed."
echo "For production, Docker/Kubernetes or official installers are highly recommended."