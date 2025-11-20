#!/bin/bash
# Add new package to Cerebrium APT repository

set -e

if [ $# -ne 1 ]; then
    echo "Usage: $0 <deb-file-path>"
    exit 1
fi

DEB_FILE="$1"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -f "$DEB_FILE" ]; then
    echo "Error: File $DEB_FILE not found"
    exit 1
fi

# Extract package info
ARCH=$(dpkg --field "$DEB_FILE" Architecture)
PACKAGE=$(dpkg --field "$DEB_FILE" Package)
VERSION=$(dpkg --field "$DEB_FILE" Version)

echo "Adding package: $PACKAGE $VERSION ($ARCH)"

# Create pool directory if needed
mkdir -p "$REPO_DIR/pool/main/${PACKAGE:0:1}/$PACKAGE"

# Copy package
cp "$DEB_FILE" "$REPO_DIR/pool/main/${PACKAGE:0:1}/$PACKAGE/"

echo "Package added. Running repository update..."
"$REPO_DIR/update-repo.sh"

echo "Package successfully added to repository!"
