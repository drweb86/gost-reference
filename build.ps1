#Requires -Version 5.1
<#
.SYNOPSIS
    Build script for gost_bibliography_reference Flutter application.

.DESCRIPTION
    Builds the Flutter application for Windows, Linux, and Android platforms.

.PARAMETER Target
    Build target: all, windows, linux, android, clean (default: all)

.EXAMPLE
    .\build.ps1
    .\build.ps1 windows
    .\build.ps1 linux
    .\build.ps1 android
    .\build.ps1 clean
#>

param(
    [Parameter(Position = 0)]
    [ValidateSet("all", "windows", "linux", "android", "clean", "help")]
    [string]$Target = "all"
)

$ErrorActionPreference = "Stop"

# Configuration
$AppName = "gost_bibliography_reference"
$Version = "1.0.0"
$DistDir = "dist"

function Write-Info { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }
function Write-Success { param($Message) Write-Host "[OK] $Message" -ForegroundColor Green }
function Write-Error { param($Message) Write-Host "[ERROR] $Message" -ForegroundColor Red }

function Show-Help {
    Write-Host @"
========================================
  Flutter Build Script - PowerShell
========================================

Usage: .\build.ps1 [Target]

Targets:
  all      - Build for all platforms (default)
  windows  - Build for Windows only
  linux    - Build for Linux/Ubuntu only
  android  - Build for Android only
  clean    - Clean build artifacts
  help     - Show this help message

Examples:
  .\build.ps1              # Build all
  .\build.ps1 windows      # Build Windows only
  .\build.ps1 linux        # Build Linux only
  .\build.ps1 android      # Build Android only
  .\build.ps1 clean        # Clean build
"@
}

function Test-Flutter {
    try {
        $null = Get-Command flutter -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

function Invoke-FlutterClean {
    Write-Info "Cleaning build artifacts..."
    flutter clean
    if (Test-Path $DistDir) {
        Remove-Item -Path $DistDir -Recurse -Force
    }
    Write-Success "Clean complete!"
}

function Invoke-FlutterPubGet {
    Write-Info "Getting dependencies..."
    flutter pub get
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to get dependencies"
    }
}

function Build-Windows {
    Write-Host ""
    Write-Info "Building for Windows..."
    flutter build windows --release
    if ($LASTEXITCODE -ne 0) {
        throw "Windows build failed"
    }

    # Package Windows build
    Write-Info "Packaging Windows build..."
    $winBuildDir = "build\windows\x64\runner\Release"
    $winOutput = Join-Path $DistDir "$AppName-windows-x64-$Version"
    $winZip = "$winOutput.zip"

    if (Test-Path $winOutput) {
        Remove-Item -Path $winOutput -Recurse -Force
    }
    New-Item -ItemType Directory -Path $winOutput -Force | Out-Null

    Copy-Item -Path "$winBuildDir\*" -Destination $winOutput -Recurse -Force

    # Create zip archive
    Write-Info "Creating Windows zip archive..."
    if (Test-Path $winZip) {
        Remove-Item -Path $winZip -Force
    }
    Compress-Archive -Path "$winOutput\*" -DestinationPath $winZip -Force

    Write-Success "Windows build complete: $winZip"
}

function Build-Linux {
    Write-Host ""
    Write-Info "Building for Linux..."
    flutter build linux --release
    if ($LASTEXITCODE -ne 0) {
        throw "Linux build failed"
    }

    # Package Linux build
    Write-Info "Packaging Linux build..."
    $linuxBuildDir = "build/linux/x64/release/bundle"
    $linuxOutput = Join-Path $DistDir "$AppName-linux-x64-$Version"
    $linuxTar = "$linuxOutput.tar.gz"

    if (Test-Path $linuxOutput) {
        Remove-Item -Path $linuxOutput -Recurse -Force
    }
    New-Item -ItemType Directory -Path $linuxOutput -Force | Out-Null

    Copy-Item -Path "$linuxBuildDir/*" -Destination $linuxOutput -Recurse -Force

    # Create tar.gz archive
    Write-Info "Creating Linux tar.gz archive..."
    if (Test-Path $linuxTar) {
        Remove-Item -Path $linuxTar -Force
    }
    tar -czvf $linuxTar -C $DistDir "$AppName-linux-x64-$Version"

    Write-Success "Linux build complete: $linuxTar"
}

function Build-Android {
    Write-Host ""

    # Build APK
    Write-Info "Building for Android (APK)..."
    flutter build apk --release
    if ($LASTEXITCODE -ne 0) {
        throw "Android APK build failed"
    }

    # Copy APK to dist
    $apkSource = "build\app\outputs\flutter-apk\app-release.apk"
    $apkDest = Join-Path $DistDir "$AppName-android-$Version.apk"
    Copy-Item -Path $apkSource -Destination $apkDest -Force
    Write-Success "Android APK complete: $apkDest"

    # Build App Bundle
    Write-Info "Building for Android (App Bundle)..."
    flutter build appbundle --release
    if ($LASTEXITCODE -ne 0) {
        throw "Android App Bundle build failed"
    }

    # Copy AAB to dist
    $aabSource = "build\app\outputs\bundle\release\app-release.aab"
    $aabDest = Join-Path $DistDir "$AppName-android-$Version.aab"
    Copy-Item -Path $aabSource -Destination $aabDest -Force
    Write-Success "Android App Bundle complete: $aabDest"
}

# Main script
Write-Host "========================================"
Write-Host "  Flutter Build Script - PowerShell"
Write-Host "========================================"
Write-Host ""

if ($Target -eq "help") {
    Show-Help
    exit 0
}

# Check Flutter installation
if (-not (Test-Flutter)) {
    Write-Error "Flutter is not installed or not in PATH"
    exit 1
}

# Create dist directory
if (-not (Test-Path $DistDir)) {
    New-Item -ItemType Directory -Path $DistDir -Force | Out-Null
}

try {
    switch ($Target) {
        "clean" {
            Invoke-FlutterClean
        }
        "windows" {
            Invoke-FlutterPubGet
            Build-Windows
        }
        "linux" {
            Invoke-FlutterPubGet
            Build-Linux
        }
        "android" {
            Invoke-FlutterPubGet
            Build-Android
        }
        "all" {
            Invoke-FlutterPubGet
            Build-Windows
            Build-Linux
            Build-Android
        }
    }

    Write-Host ""
    Write-Host "========================================"
    Write-Host "  Build Complete!"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "Output files in '$DistDir' folder:"
    Get-ChildItem -Path $DistDir -Name
    Write-Host ""
}
catch {
    Write-Error $_.Exception.Message
    exit 1
}
