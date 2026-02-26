#!/usr/bin/env powershell
<#
.SYNOPSIS
    Builds all Revit 2026 plugins and populates the deploy/2026 folder

.DESCRIPTION
    This script:
    1. Compiles all 44 plugins for Revit 2026
    2. Copies the compiled DLLs to deploy/2026/
    3. Copies supporting files (families, templates, etc.)

.PARAMETER Configuration
    Build configuration: Debug or Release (default: Release)

.EXAMPLE
    .\Build-2026-Deploy.ps1 -Configuration Release
    .\Build-2026-Deploy.ps1 -Configuration Debug
#>

param(
    [ValidateSet("Debug", "Release")]
    [string]$Configuration = "Release"
)

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Get script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$srcDir = Join-Path $scriptDir "src"
$deployDir = Join-Path $scriptDir "deploy\2026"

# Colors for output
function Write-Header {
    param([string]$Message)
    Write-Host "===================" -ForegroundColor Cyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host "===================" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ $Message" -ForegroundColor Blue
}

# Verify source directory
Write-Header "Verifying Paths"
if (-not (Test-Path $srcDir)) {
    Write-Error-Custom "Source directory not found: $srcDir"
    exit 1
}
Write-Success "Source directory: $srcDir"

if (-not (Test-Path $deployDir)) {
    Write-Error-Custom "Deploy directory not found: $deployDir"
    Write-Info "Creating deploy/2026 folder..."
    New-Item -ItemType Directory -Path $deployDir -Force | Out-Null
    Write-Success "Created: $deployDir"
}

# Find all plugin solutions
Write-Header "Discovering Revit 2026 Plugins"
$plugins = @()
$solutionFiles = Get-ChildItem -Path $srcDir -Filter "*.sln" -Recurse | Where-Object {
    $_.DirectoryName -match "Case\.[A-Z]" -and -not $_.DirectoryName -match "_Case\."
}

Write-Info "Found $($solutionFiles.Count) plugin solutions"

foreach ($sln in $solutionFiles) {
    $pluginName = $sln.BaseName
    $pluginDir = $sln.DirectoryName
    $has2026 = Test-Path "$pluginDir\$pluginName.2026"

    if ($has2026) {
        $plugins += @{
            Name = $pluginName
            SolutionPath = $sln.FullName
            DirectoryPath = $pluginDir
            ProjectPath = "$pluginDir\$pluginName.2026\$pluginName.2026.vbproj"
        }
        Write-Info "  ✓ $pluginName"
    } else {
        Write-Info "  ✗ $pluginName (no 2026 version)"
    }
}

Write-Success "Found $($plugins.Count) plugins with 2026 versions"

# Compile each plugin
Write-Header "Compiling Revit 2026 Plugins (Configuration: $Configuration)"
$buildErrors = @()
$builtPlugins = @()

foreach ($plugin in $plugins) {
    Write-Host "Building $($plugin.Name)..." -ForegroundColor White

    try {
        $buildOutput = & msbuild $plugin.ProjectPath `
            /p:Configuration=$Configuration `
            /p:Platform=AnyCPU `
            /m `
            /v:q 2>&1

        if ($LASTEXITCODE -ne 0) {
            $buildErrors += $plugin.Name
            Write-Error-Custom "  Failed to build $($plugin.Name)"
            Write-Host ($buildOutput | Out-String) -ForegroundColor Red
        } else {
            Write-Success "  Built $($plugin.Name)"
            $builtPlugins += $plugin
        }
    } catch {
        $buildErrors += $plugin.Name
        Write-Error-Custom "  Error building $($plugin.Name): $_"
    }
}

if ($buildErrors.Count -gt 0) {
    Write-Error-Custom "`nBuild failed for: $($buildErrors -join ', ')"
    Write-Info "Continuing with successfully built plugins..."
}

# Copy DLLs
Write-Header "Copying Compiled DLLs to deploy/2026"
$copiedCount = 0

foreach ($plugin in $builtPlugins) {
    $dllPath = Join-Path $plugin.DirectoryPath "$($plugin.Name).2026\bin\$Configuration\$($plugin.Name).dll"

    if (Test-Path $dllPath) {
        Copy-Item -Path $dllPath -Destination $deployDir -Force
        Write-Success "Copied $($plugin.Name).dll"
        $copiedCount++
    } else {
        Write-Error-Custom "DLL not found: $dllPath"
    }
}

Write-Success "Copied $copiedCount DLLs to $deployDir"

# Copy supporting files from 2023 deploy (if they don't exist in 2026)
Write-Header "Copying Supporting Files"
$supportingFiles = @(
    "3D_RoomTag.rfa",
    "Mass.rft",
    "Newtonsoft.Json.dll",
    "RestSharp.dll",
    "Case.Subs.Exceler8.xls",
    "Case.Subs.Exceler8.xlsx",
    "Case.Subs.Exceler8_Schedule.xlsx",
    "Case.Subs.KeyMatcher.xlsx",
    "Case.Subs.Renamer.xlsx"
)

$source2023 = Join-Path $scriptDir "deploy\2023"

if (Test-Path $source2023) {
    $copiedSupporting = 0
    foreach ($file in $supportingFiles) {
        $sourcePath = Join-Path $source2023 $file
        if (Test-Path $sourcePath) {
            Copy-Item -Path $sourcePath -Destination $deployDir -Force
            Write-Info "  Copied $file"
            $copiedSupporting++
        }
    }
    Write-Success "Copied $copiedSupporting supporting files"
} else {
    Write-Info "2023 deploy folder not found, skipping supporting files"
}

# Display summary
Write-Header "Build Summary"

Write-Host @"
Build Configuration: $Configuration
Plugins Built: $($builtPlugins.Count) / $($plugins.Count)
DLLs Copied: $copiedCount
Deploy Location: $deployDir

Contents:
"@ -ForegroundColor White

Get-ChildItem -Path $deployDir -Name | ForEach-Object {
    Write-Host "  ✓ $_"
}

Write-Host ""

if ($buildErrors.Count -gt 0) {
    Write-Error-Custom "Build completed with errors: $($buildErrors -join ', ')"
} else {
    Write-Success "Build completed successfully!"
    Write-Info "`nThe deploy/2026 folder is now ready for distribution."
}

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Verify all DLLs are present in: $deployDir"
Write-Host "2. Test plugins in Revit 2026"
Write-Host "3. Update the MSI installer to include these files"
Write-Host ""
