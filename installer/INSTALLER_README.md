# Case Plugins for Revit 2026 - Installer Guide

## Overview

This directory contains the Windows Installer (MSI) package builder for Case Plugins for Revit 2026. The installer packages all 44 plugins and their required files into a professional Windows MSI installer.

## Contents

- **Case.Plugins.2026.Installer.wixproj** - WiX project file
- **Product.wxs** - Product definition and UI configuration
- **Files.wxs** - File/directory installation layout
- **Registry.wxs** - Registry entry configurations
- **Build-Installer.ps1** - PowerShell build script
- **License.rtf** - End-user license agreement (EULA)

## Prerequisites

### Required Software

1. **Visual Studio 2019 or 2022** with C# workload
2. **WiX Toolset 3.x or higher**
   - Download from: https://wixtoolset.org/
   - Or: `choco install wix310` (if using Chocolatey)
3. **MSBuild** (included with Visual Studio)

### System Requirements

- Windows 7 or later (x64)
- 500 MB disk space for installation
- Revit 2026 installation

## Building the Installer

### Step 1: Compile Plugins

Run the build script to compile all plugins and prepare installer files:

```powershell
# From the installer directory
.\Build-Installer.ps1 -Configuration Release
```

This script will:
- ✓ Find all 44 Revit 2026 plugins
- ✓ Compile each plugin using MSBuild
- ✓ Gather compiled DLLs
- ✓ Generate Revit .addin manifest files
- ✓ Organize files for packaging

**Expected output:**
```
Binaries/          - 44 plugin DLLs
Manifests/         - 44 .addin manifest files
Documentation/     - Plugin documentation
```

### Step 2: Build the MSI Package

After running the build script, create the MSI installer:

```cmd
cd installer
msbuild Case.Plugins.2026.Installer.wixproj /p:Configuration=Release /p:Platform=x64
```

Or using Visual Studio:
1. Open `Case.Plugins.2026.Installer.wixproj` in Visual Studio
2. Right-click project → Build
3. Output MSI will be in `bin\Release\Case.Plugins.2026.Installer.msi`

### Step 3: Distribute

The generated MSI can be:
- Distributed to end users
- Integrated into deployment systems
- Packaged with Revit installation media
- Published to software distribution platforms

## Installation Process

### For End Users

1. **Run the installer:**
   ```
   Case.Plugins.2026.Installer.msi
   ```

2. **Follow the installation wizard:**
   - Accept the End User License Agreement
   - Choose installation location (default: Program Files)
   - Complete installation

3. **Restart Revit 2026**
   - All plugins will be automatically loaded
   - Check Revit Add-ins tab to verify plugins are loaded

### For System Administrators

Install silently on multiple machines:

```cmd
msiexec /i Case.Plugins.2026.Installer.msi /quiet /norestart
```

Uninstall via command line:

```cmd
msiexec /x Case.Plugins.2026.Installer.msi /quiet /norestart
```

## Installer Customization

### Modify Product Information

Edit `Product.wxs` to customize:

```xml
<Product Id="*"
         Name="Your Company - Plugins for Revit 2026"
         Language="1033"
         Version="1.0.0.0"
         Manufacturer="Your Company Name"
         UpgradeCode="550e8400-e29b-41d4-a716-446655440001">
```

### Update License Agreement

1. Replace `License.rtf` with your company's EULA
2. The RTF file is displayed during installation

### Customize Installation Directory

In `Product.wxs`:

```xml
<Directory Id="INSTALLFOLDER" Name="Your Custom Folder Name" />
```

## Installer Features

### What Gets Installed

- **Plugin Binaries** (44 DLLs)
  - Location: `Program Files\Case Plugins for Revit 2026\Binaries\`
  - All plugins compatible with Revit 2026

- **Manifest Files** (44 .addin files)
  - Location: `Program Files\Case Plugins for Revit 2026\Manifests\`
  - Revit automatically discovers and loads these

- **Documentation**
  - Location: `Program Files\Case Plugins for Revit 2026\Documentation\`
  - Reference materials and usage guides

### Registry Entries

The installer creates these registry entries:

```
HKEY_CURRENT_USER\Software\Case\Revit\Plugins\2026\
  InstallPath = Installation directory
  Version = 1.0.0.0
  InstallDate = Installation timestamp
  PluginCount = 44
```

### User Experience

- Clean uninstall (removes all files and registry entries)
- Per-machine or per-user installation
- Repair/reinstall support
- Automatic add-in discovery by Revit

## Troubleshooting

### Build Fails: "WiX toolset not found"

**Solution:** Install WiX Toolset
```powershell
choco install wix310
# Or download from https://wixtoolset.org/
```

### Plugins Not Loading in Revit

1. Check installation location:
   ```
   C:\Program Files\Case Plugins for Revit 2026\Binaries\
   ```

2. Verify manifest files are present:
   ```
   C:\Program Files\Case Plugins for Revit 2026\Manifests\
   ```

3. Check Revit Add-ins dialog:
   - Manage → Add-ins → Revit Add-ins
   - Verify plugins appear in the list

4. Check Windows Event Viewer for Revit errors:
   - Windows Logs → Application
   - Filter for "Revit" errors

### MSI Installation Fails

**Enable verbose logging:**
```cmd
msiexec /i Case.Plugins.2026.Installer.msi /l*vx installer.log
```

Review `installer.log` for detailed error information.

### Plugins Load but Don't Work

1. Verify .NET Framework 4.8 is installed
2. Check Revit version compatibility (should be 2026)
3. Review Revit journal log:
   ```
   C:\ProgramData\Autodesk\Revit\Addins\2026\
   ```

## Advanced Options

### Silent Installation with Custom Path

```cmd
msiexec /i Case.Plugins.2026.Installer.msi ^
  INSTALLFOLDER="D:\Revit\Plugins\" ^
  /quiet /norestart
```

### Deployment via Group Policy

1. Package MSI on network share
2. Create Group Policy object
3. Deploy via Software Installation policy

See: [Deploy Windows Installer Packages via GPO](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec)

### Code Signing (Optional)

For enterprise deployments, sign the MSI:

```cmd
signtool sign /f MyCert.pfx /p password Case.Plugins.2026.Installer.msi
```

## File Structure

```
installer/
├── Case.Plugins.2026.Installer.wixproj    # WiX project file
├── Product.wxs                             # Product configuration
├── Files.wxs                               # File layout
├── Registry.wxs                            # Registry entries
├── Build-Installer.ps1                     # Build script
├── License.rtf                             # EULA
├── bin/
│   └── Release/
│       ├── Binaries/                       # Compiled plugins (44 DLLs)
│       ├── Manifests/                      # Revit manifest files (44 .addin)
│       └── Documentation/                  # Plugin docs
└── INSTALLER_README.md                     # This file
```

## Version Management

### Updating for New Releases

1. Update version in `Product.wxs`:
   ```xml
   <Product Version="2.0.0.0" ... />
   ```

2. Recompile plugins:
   ```powershell
   .\Build-Installer.ps1 -Configuration Release
   ```

3. Rebuild MSI:
   ```cmd
   msbuild Case.Plugins.2026.Installer.wixproj /p:Configuration=Release
   ```

### Upgrade Behavior

The installer uses upgrade code to:
- Detect previous versions
- Offer to repair/upgrade
- Prevent multiple installations
- Manage backward compatibility

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review WiX documentation: https://wixtoolset.org/documentation/
3. Check Revit API documentation for add-in deployment
4. Contact your development team

## Security Considerations

- All plugins are compiled with .NET Framework 4.8
- No elevated privileges required for installation
- Registry entries are user-level (HKCU)
- Files are placed in standard Program Files location
- No network access or external dependencies
- No auto-update mechanism (must reinstall for updates)

## License

See License.rtf for the End User License Agreement.

## Change Log

### Version 1.0.0.0
- Initial release
- Support for Revit 2026
- 44 plugins included
- All plugins compiled and tested
- Windows x64 installer

---

**Generated:** February 2026
**For:** Case Plugins for Revit 2026
**Compatibility:** Revit 2026 (x64 only)
