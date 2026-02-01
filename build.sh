#!/bin/bash

# Build script for gost_bibliography_reference Flutter application
# Builds for Linux and Android on Linux/macOS host

set -e

APP_NAME="gost_bibliography_reference"
VERSION="1.0.0"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo "  Flutter Build Script - Linux/macOS Host"
echo -e "${GREEN}========================================${NC}"
echo

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}Error: Flutter is not installed or not in PATH${NC}"
    exit 1
fi

# Parse arguments
BUILD_LINUX=false
BUILD_ANDROID=false
BUILD_ALL=false
CLEAN=false

case "${1:-all}" in
    all)
        BUILD_ALL=true
        BUILD_LINUX=true
        BUILD_ANDROID=true
        ;;
    linux)
        BUILD_LINUX=true
        ;;
    android)
        BUILD_ANDROID=true
        ;;
    clean)
        CLEAN=true
        ;;
    help|--help|-h)
        echo "Usage: $0 [target]"
        echo ""
        echo "Targets:"
        echo "  all      - Build for all platforms (default)"
        echo "  linux    - Build for Linux only"
        echo "  android  - Build for Android only"
        echo "  clean    - Clean build artifacts"
        echo "  help     - Show this help message"
        exit 0
        ;;
    *)
        echo -e "${RED}Unknown target: $1${NC}"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac

# Create output directory
mkdir -p dist

# Clean build
if [ "$CLEAN" = true ]; then
    echo -e "${YELLOW}Cleaning build artifacts...${NC}"
    flutter clean
    rm -rf dist
    echo -e "${GREEN}Clean complete!${NC}"
    exit 0
fi

# Get dependencies
echo -e "${YELLOW}Getting dependencies...${NC}"
flutter pub get

# Build Linux
if [ "$BUILD_LINUX" = true ]; then
    echo
    echo -e "${YELLOW}Building for Linux...${NC}"

    # Check for required Linux build dependencies
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Check for required packages
        MISSING_DEPS=""
        for pkg in clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-12-dev; do
            if ! dpkg -l | grep -q "^ii  $pkg"; then
                MISSING_DEPS="$MISSING_DEPS $pkg"
            fi
        done

        if [ -n "$MISSING_DEPS" ]; then
            echo -e "${YELLOW}Note: Some build dependencies might be missing. If build fails, run:${NC}"
            echo "sudo apt-get install$MISSING_DEPS"
        fi

        flutter build linux --release

        # Package Linux build
        echo -e "${YELLOW}Packaging Linux build...${NC}"
        LINUX_BUILD_DIR="build/linux/x64/release/bundle"
        LINUX_OUTPUT="dist/${APP_NAME}-linux-x64-${VERSION}"

        rm -rf "$LINUX_OUTPUT"
        mkdir -p "$LINUX_OUTPUT"

        cp -r "$LINUX_BUILD_DIR"/* "$LINUX_OUTPUT/"

        # Create tar.gz archive
        echo -e "${YELLOW}Creating Linux tar.gz archive...${NC}"
        cd dist
        tar -czvf "${APP_NAME}-linux-x64-${VERSION}.tar.gz" "${APP_NAME}-linux-x64-${VERSION}"
        cd ..

        echo -e "${GREEN}Linux build complete: ${LINUX_OUTPUT}.tar.gz${NC}"
    else
        echo -e "${YELLOW}Skipping Linux build (not on Linux)${NC}"
    fi
fi

# Build Android
if [ "$BUILD_ANDROID" = true ]; then
    echo
    echo -e "${YELLOW}Building for Android (APK)...${NC}"
    flutter build apk --release

    # Copy APK to dist
    cp "build/app/outputs/flutter-apk/app-release.apk" "dist/${APP_NAME}-android-${VERSION}.apk"
    echo -e "${GREEN}Android APK complete: dist/${APP_NAME}-android-${VERSION}.apk${NC}"

    # Build Android App Bundle
    echo -e "${YELLOW}Building for Android (App Bundle)...${NC}"
    flutter build appbundle --release

    # Copy AAB to dist
    cp "build/app/outputs/bundle/release/app-release.aab" "dist/${APP_NAME}-android-${VERSION}.aab"
    echo -e "${GREEN}Android App Bundle complete: dist/${APP_NAME}-android-${VERSION}.aab${NC}"
fi

echo
echo -e "${GREEN}========================================${NC}"
echo "  Build Complete!"
echo -e "${GREEN}========================================${NC}"
echo
echo "Output files are in the 'dist' folder:"
ls -la dist/
echo
