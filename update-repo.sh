#!/bin/bash
# Update script for Cerebrium APT repository

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

echo "Updating Cerebrium APT repository..."

# Regenerate Packages files
echo "Scanning packages..."
dpkg-scanpackages --arch amd64 pool/ > dists/stable/main/binary-amd64/Packages
dpkg-scanpackages --arch arm64 pool/ > dists/stable/main/binary-arm64/Packages
dpkg-scanpackages --arch i386 pool/ > dists/stable/main/binary-i386/Packages

# Compress Packages files
echo "Compressing package lists..."
for arch in amd64 arm64 i386; do
    gzip -c dists/stable/main/binary-$arch/Packages > dists/stable/main/binary-$arch/Packages.gz
done

# Generate Release file
echo "Generating Release file..."
cat > dists/stable/Release << EOF
Origin: Cerebrium Inc
Label: Cerebrium
Suite: stable
Codename: stable
Version: 1.0
Architectures: amd64 arm64 i386
Components: main
Description: Cerebrium Official APT Repository
Date: $(date -R)
EOF

# Add checksums
echo "MD5Sum:" >> dists/stable/Release
for file in dists/stable/main/binary-*/Packages*; do
    if [ -f "$file" ]; then
        SIZE=$(stat -f%z "$file")
        MD5=$(md5 -q "$file")
        RELPATH=${file#dists/stable/}
        printf " %s %16d %s\n" "$MD5" "$SIZE" "$RELPATH" >> dists/stable/Release
    fi
done

echo "SHA256:" >> dists/stable/Release
for file in dists/stable/main/binary-*/Packages*; do
    if [ -f "$file" ]; then
        SIZE=$(stat -f%z "$file")
        SHA256=$(shasum -a 256 "$file" | cut -d" " -f1)
        RELPATH=${file#dists/stable/}
        printf " %s %16d %s\n" "$SHA256" "$SIZE" "$RELPATH" >> dists/stable/Release
    fi
done

# Sign Release file
echo "Signing Release file..."
gpg --default-key 61E31EFB9CDC52C1 -abs -o dists/stable/Release.gpg dists/stable/Release
gpg --default-key 61E31EFB9CDC52C1 --clearsign -o dists/stable/InRelease dists/stable/Release

echo "Repository updated successfully!"
echo ""
echo "Next steps:"
echo "1. Commit and push changes to GitHub"
echo "2. Ensure GitHub Pages is enabled for the repository"
