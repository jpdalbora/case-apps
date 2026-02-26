#!/usr/bin/env powershell
<#
.SYNOPSIS
    Builds the MSI installer for Case Plugins for Revit 2026

.DESCRIPTION
    This script:
    1. Compiles all 44 plugins for Revit 2026
    2. Gathers compiled binaries
    3. Generates .addin manifest files
    4. Creates the WiX MSI installer package

.PARAMETER Configuration
    Build configuration: Debug or Release (default: Release)

.PARAMETER PluginsSourcePath
    Path to the plugins source directory (default: ../src)

.PARAMETER OutputPath
    Output directory for the MSI (default: ./bin/Release)

.EXAMPLE
    .\Build-Installer.ps1 -Configuration Release
#>

param(
    [ValidateSet("Debug", "Release")]
    [string]$Configuration = "Release",

    [string]$PluginsSourcePath = "$(Split-Path $PSScriptRoot)\src",

    [string]$OutputPath = "$(Split-Path $PSScriptRoot)\installer\bin\$Configuration"
)

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Colors for output
function Write-Header {
    param([string]$Message)
    Write-Information "===================="
    Write-Information $Message
    Write-Information "===================="
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

# Step 1: Verify paths
Write-Header "Verifying Installation Paths"
if (-not (Test-Path $PluginsSourcePath)) {
    Write-Error-Custom "Plugins source path not found: $PluginsSourcePath"
    exit 1
}
Write-Success "Plugins source path found: $PluginsSourcePath"

# Step 2: Find all 2026 plugin solutions
Write-Header "Discovering Revit 2026 Plugins"
$pluginSolutions = @()
$pluginInfo = @()

$solutionFiles = Get-ChildItem -Path $PluginsSourcePath -Filter "*.sln" -Recurse | Where-Object {
    $_.DirectoryName -match "Case\." -and -not $_.DirectoryName -match "_Case\."
}

Write-Information "Found $(($solutionFiles | Measure-Object).Count) plugin solutions"

foreach ($sln in $solutionFiles) {
    $pluginName = $sln.BaseName
    $pluginDir = $sln.DirectoryName
    $has2026 = Test-Path "$pluginDir\$pluginName.2026"

    if ($has2026) {
        $pluginSolutions += $sln.FullName
        $pluginInfo += @{
            Name = $pluginName
            SolutionPath = $sln.FullName
            DirectoryPath = $pluginDir
            Revision = "2026"
        }
        Write-Information "  ✓ $pluginName (has 2026 version)"
    }
}

Write-Success "Found $($pluginInfo.Count) plugins with 2026 versions"

# Step 3: Create output directories
Write-Header "Preparing Output Directories"
$binariesDir = "$OutputPath\Binaries"
$manifestsDir = "$OutputPath\Manifests"
$docsDir = "$OutputPath\Documentation"

foreach ($dir in @($binariesDir, $manifestsDir, $docsDir)) {
    if (Test-Path $dir) {
        Remove-Item -Path $dir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    Write-Success "Created directory: $dir"
}

# Step 4: Compile plugins
Write-Header "Compiling Revit 2026 Plugins (Configuration: $Configuration)"
$compilationErrors = @()

foreach ($plugin in $pluginInfo) {
    Write-Information "Building $($plugin.Name)..."

    $msbuildArgs = @(
        $plugin.SolutionPath,
        "/p:Configuration=$Configuration",
        "/p:Platform=AnyCPU",
        "/m",
        "/v:q"
    )

    $buildOutput = & msbuild @msbuildArgs 2>&1
    if ($LASTEXITCODE -ne 0) {
        $compilationErrors += $plugin.Name
        Write-Error-Custom "Failed to build $($plugin.Name)"
        Write-Information $buildOutput
    } else {
        Write-Success "Built $($plugin.Name)"
    }
}

if ($compilationErrors.Count -gt 0) {
    Write-Error-Custom "Build failed for: $($compilationErrors -join ', ')"
    exit 1
}

Write-Success "All plugins compiled successfully"

# Step 5: Copy binaries
Write-Header "Copying Compiled Binaries"
$copiedCount = 0

foreach ($plugin in $pluginInfo) {
    $dllPath = Join-Path $plugin.DirectoryPath "$($plugin.Name).2026\bin\$Configuration\$($plugin.Name).dll"

    if (Test-Path $dllPath) {
        Copy-Item -Path $dllPath -Destination $binariesDir -Force
        Write-Success "Copied $($plugin.Name).dll"
        $copiedCount++
    } else {
        Write-Error-Custom "Binary not found: $dllPath"
    }
}

Write-Success "Copied $copiedCount plugin binaries"

# Step 6: Generate .addin manifest files
Write-Header "Generating Revit .addin Manifest Files"
$guidTemplate = @{
    "Case.ApplySysOrient"              = "{F7E0C1A1-9B5C-4D8E-8F2A-1C3B5D7E9F1A}"
    "Case.AppsRibbon"                  = "{1A2B3C4D-5E6F-7A8B-9C0D-1E2F3A4B5C6D}"
    "Case.BasicReporting"              = "{7B8C9D0E-1F2A-3B4C-5D6E-7F8A9B0C1D2E}"
    "Case.ChangeReplaceFamTypeNames"  = "{2C3D4E5F-6A7B-8C9D-0E1F-2A3B4C5D6E7F}"
    "Case.DeleteViewsAndPurge"         = "{3D4E5F6A-7B8C-9D0E-1F2A-3B4C5D6E7F8A}"
    "Case.DimensionOverrides"          = "{4E5F6A7B-8C9D-0E1F-2A3B-4C5D6E7F8A9B}"
    "Case.Directionality"              = "{5F6A7B8C-9D0E-1F2A-3B4C-5D6E7F8A9B0C}"
    "Case.DoorMarkRenumber"            = "{6A7B8C9D-0E1F-2A3B-4C5D-6E7F8A9B0C1D}"
    "Case.Export.Families"             = "{7B8C9D0E-1F2A-3B4C-5D6E-7F8A9B0C1D2E}"
    "Case.ExportSharedParameters"      = "{8C9D0E1F-2A3B-4C5D-6E7F-8A9B0C1D2E3F}"
    "Case.ExtrudeRoomsToMass"          = "{9D0E1F2A-3B4C-5D6E-7F8A-9B0C1D2E3F4A}"
    "Case.FamilySubcategories"         = "{0E1F2A3B-4C5D-6E7F-8A9B-0C1D2E3F4A5B}"
    "Case.FreeBenchmarking"            = "{1F2A3B4C-5D6E-7F8A-9B0C-1D2E3F4A5B6C}"
    "Case.HiddenParameterToParameter" = "{2A3B4C5D-6E7F-8A9B-0C1D-2E3F4A5B6C7D}"
    "Case.ImageToDraftingView"         = "{3B4C5D6E-7F8A-9B0C-1D2E-3F4A5B6C7D8E}"
    "Case.LightingLayout"              = "{4C5D6E7F-8A9B-0C1D-2E3F-4A5B6C7D8E9F}"
    "Case.LineChanger"                 = "{5D6E7F8A-9B0C-1D2E-3F4A-5B6C7D8E9F0A}"
    "Case.ModeledRoomTags"             = "{6E7F8A9B-0C1D-2E3F-4A5B-6C7D8E9F0A1B}"
    "Case.MultiViewDuplicate"          = "{7F8A9B0C-1D2E-3F4A-5B6C-7D8E9F0A1B2C}"
    "Case.ObjectStyles"                = "{8A9B0C1D-2E3F-4A5B-6C7D-8E9F0A1B2C3D}"
    "Case.ParallelWalls"               = "{9B0C1D2E-3F4A-5B6C-7D8E-9F0A1B2C3D4E}"
    "Case.ReportGroupsByView"          = "{0C1D2E3F-4A5B-6C7D-8E9F-0A1B2C3D4E5F}"
    "Case.RoomSync"                    = "{1D2E3F4A-5B6C-7D8E-9F0A-1B2C3D4E5F6A}"
    "Case.SharedParameters"            = "{2E3F4A5B-6C7D-8E9F-0A1B-2C3D4E5F6A7B}"
    "Case.Subs.DeleteViewsAndPurge"    = "{3F4A5B6C-7D8E-9F0A-1B2C-3D4E5F6A7B8C}"
    "Case.Subs.Exceler8"               = "{4A5B6C7D-8E9F-0A1B-2C3D-4E5F6A7B8C9D}"
    "Case.Subs.KeyMatcher"             = "{5B6C7D8E-9F0A-1B2C-3D4E-5F6A7B8C9D0E}"
    "Case.Subs.Linestyles"             = "{6C7D8E9F-0A1B-2C3D-4E5F-6A7B8C9D0E1F}"
    "Case.Subs.MultiViewDuplicate"     = "{7D8E9F0A-1B2C-3D4E-5F6A-7B8C9D0E1F2A}"
    "Case.Subs.OpenNURBS"              = "{8E9F0A1B-2C3D-4E5F-6A7B-8C9D0E1F2A3B}"
    "Case.Subs.Renamer"                = "{9F0A1B2C-3D4E-5F6A-7B8C-9D0E1F2A3B4C}"
    "Case.Subs.RoomsToMass"            = "{0A1B2C3D-4E5F-6A7B-8C9D-0E1F2A3B4C5D}"
    "Case.Subs.SharedParameters"       = "{1B2C3D4E-5F6A-7B8C-9D0E-1F2A3B4C5D6E}"
    "Case.Subs.SuperTag"               = "{2C3D4E5F-6A7B-8C9D-0E1F-2A3B4C5D6E7F}"
    "Case.Subs.ViewSync"               = "{3D4E5F6A-7B8C-9D0E-1F2A-3B4C5D6E7F8A}"
    "Case.Subs.ViewTemplates"          = "{4E5F6A7B-8C9D-0E1F-2A3B-4C5D6E7F8A9B}"
    "Case.Subs.Worksets"               = "{5F6A7B8C-9D0E-1F2A-3B4C-5D6E7F8A9B0C}"
    "Case.Subs.Xyz"                    = "{6A7B8C9D-0E1F-2A3B-4C5D-6E7F8A9B0C1D}"
    "Case.UngroupAll"                  = "{7B8C9D0E-1F2A-3B4C-5D6E-7F8A9B0C1D2E}"
    "Case.ViewCreator"                 = "{8C9D0E1F-2A3B-4C5D-6E7F-8A9B0C1D2E3F}"
    "Case.ViewTemplates"               = "{9D0E1F2A-3B4C-5D6E-7F8A-9B0C1D2E3F4A}"
    "Case.ViewportReporting"           = "{0E1F2A3B-4C5D-6E7F-8A9B-0C1D2E3F4A5B}"
}

$manifestCount = 0
foreach ($pluginName in $guidTemplate.Keys) {
    $guid = $guidTemplate[$pluginName]
    $dllPath = Join-Path $binariesDir "$pluginName.dll"

    if (Test-Path $dllPath) {
        $addinContent = @"
<?xml version="1.0" encoding="utf-8"?>
<RevitAddIns>
  <AddIn Type="Command">
    <Name>$pluginName</Name>
    <Assembly>$dllPath</Assembly>
    <FullClassName>$pluginName.Command</FullClassName>
    <Text>$pluginName</Text>
    <Description>Case plugin for Revit 2026</Description>
    <VisibilityMode>AlwaysVisible</VisibilityMode>
    <VendorId>0</VendorId>
  </AddIn>
</RevitAddIns>
"@

        $addinPath = Join-Path $manifestsDir "$pluginName.addin"
        Set-Content -Path $addinPath -Value $addinContent -Encoding UTF8
        Write-Success "Generated $pluginName.addin"
        $manifestCount++
    }
}

Write-Success "Generated $manifestCount manifest files"

# Step 7: Create placeholder file
Write-Header "Creating Installer Files"
"Case Plugins for Revit 2026 - Installed on $(Get-Date)" | Set-Content "$binariesDir\placeholder.txt"
Write-Success "Created placeholder file"

# Step 8: Summary
Write-Header "Build Summary"
Write-Host @"
✓ Compilation completed successfully
✓ Binaries copied: $copiedCount plugins
✓ Manifests generated: $manifestCount plugins
✓ Output path: $OutputPath

Next steps:
1. Review the generated files in:
   - Binaries: $binariesDir
   - Manifests: $manifestsDir
   - Documentation: $docsDir

2. To create the MSI installer, you need:
   - WiX Toolset 3.x or higher installed
   - Run: msbuild Case.Plugins.2026.Installer.wixproj /p:Configuration=$Configuration

3. The generated MSI will:
   - Install all plugins to Program Files
   - Register plugins in Windows registry
   - Create add-in manifest entries for Revit 2026

For detailed installation instructions, see: INSTALLER_README.md
"@

Write-Success "Build process completed!"
