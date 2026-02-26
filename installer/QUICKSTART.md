# Quick Start: Building the Installer

## 5-Minute Setup

### 1. Install Prerequisites

```powershell
# Install WiX Toolset (if not already installed)
choco install wix310 dotnet-runtime

# Or download from https://wixtoolset.org/
```

### 2. Run Build Script

```powershell
cd installer
.\Build-Installer.ps1 -Configuration Release
```

**Expected output:**
```
✓ All plugins compiled successfully
✓ Copied 44 plugin binaries
✓ Generated 44 manifest files
```

### 3. Create MSI

```cmd
cd installer
msbuild Case.Plugins.2026.Installer.wixproj /p:Configuration=Release /p:Platform=x64
```

**Output file:**
```
installer\bin\Release\Case.Plugins.2026.Installer.msi
```

### 4. Test Installation

Double-click the MSI file and follow the wizard.

---

## What the Installer Does

✓ Installs 44 Case plugins for Revit 2026
✓ Creates Revit add-in manifest files
✓ Registers plugins in Windows registry
✓ Creates uninstall entry in Control Panel

## Troubleshooting

### Build fails with "WiX not found"
→ Install WiX Toolset from https://wixtoolset.org/

### MSI creation fails
→ Ensure Visual Studio with C# workload is installed
→ Run in Administrator command prompt

### Plugins don't load in Revit
→ Check "Manage → Add-ins → Revit Add-ins"
→ Verify installation path in registry

## Next Steps

- Review full documentation: [INSTALLER_README.md](INSTALLER_README.md)
- Customize product info in [Product.wxs](Product.wxs)
- Update license agreement in [License.rtf](License.rtf)
- Deploy to end users using the generated MSI

---

**For detailed instructions, see INSTALLER_README.md**
