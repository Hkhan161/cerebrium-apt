#!/bin/bash
# Test script for Cerebrium APT repository

echo "Testing Cerebrium APT Repository"
echo "================================"

# Test 1: Check if GPG key is accessible
echo -n "Testing GPG key download... "
if curl -fsSL https://cerebriumai.github.io/cerebrium-apt/cerebrium.gpg >/dev/null 2>&1; then
    echo "✓ OK"
else
    echo "✗ FAILED"
    exit 1
fi

# Test 2: Check Release file
echo -n "Testing Release file... "
if curl -fsSL https://cerebriumai.github.io/cerebrium-apt/dists/stable/Release >/dev/null 2>&1; then
    echo "✓ OK"
else
    echo "✗ FAILED"
    exit 1
fi

# Test 3: Check signed Release files
echo -n "Testing Release.gpg... "
if curl -fsSL https://cerebriumai.github.io/cerebrium-apt/dists/stable/Release.gpg >/dev/null 2>&1; then
    echo "✓ OK"
else
    echo "✗ FAILED"
    exit 1
fi

echo -n "Testing InRelease... "
if curl -fsSL https://cerebriumai.github.io/cerebrium-apt/dists/stable/InRelease >/dev/null 2>&1; then
    echo "✓ OK"
else
    echo "✗ FAILED"
    exit 1
fi

# Test 4: Check Packages files
for arch in amd64 arm64; do
    echo -n "Testing Packages file for $arch... "
    if curl -fsSL https://cerebriumai.github.io/cerebrium-apt/dists/stable/main/binary-$arch/Packages.gz >/dev/null 2>&1; then
        echo "✓ OK"
    else
        echo "✗ FAILED"
        exit 1
    fi
done

# Test 5: Check actual .deb packages
for arch in amd64 arm64; do
    echo -n "Testing .deb package for $arch... "
    if curl -fsSL https://cerebriumai.github.io/cerebrium-apt/pool/main/c/cerebrium/cerebrium_2.0.0_linux_$arch.deb >/dev/null 2>&1; then
        echo "✓ OK"
    else
        echo "✗ FAILED"
        exit 1
    fi
done

echo ""
echo "All tests passed! ✓"
echo ""
echo "To install on a Debian/Ubuntu system:"
echo "--------------------------------------"
echo "curl -fsSL https://cerebriumai.github.io/cerebrium-apt/cerebrium.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cerebrium-keyring.gpg"
echo "echo \"deb [signed-by=/usr/share/keyrings/cerebrium-keyring.gpg] https://cerebriumai.github.io/cerebrium-apt/ stable main\" | sudo tee /etc/apt/sources.list.d/cerebrium.list"
echo "sudo apt update"
echo "sudo apt install cerebrium"
