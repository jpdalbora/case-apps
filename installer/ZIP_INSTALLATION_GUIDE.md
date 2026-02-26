# Case Plugins for Revit 2026 - ZIP Installation Guide

## Overview

This guide explains how to manually install Case Plugins for Revit 2026 using a ZIP file instead of the MSI installer. This approach is useful for:
- Manual installation and customization
- Network installations without admin privileges
- Portable/temporary installations
- Troubleshooting specific plugins
- Development environments

## Prerequisites

- **Revit 2026** (x64) installed
- **Windows 7 or later** (x64)
- **.NET Framework 4.8** or later (usually included with Revit)
- **Administrator access** (to modify Revit add-in directories)
- **File extraction tool** (Windows built-in or 7-Zip)

## File Structure

The ZIP file contains:

```
Case.Plugins.2026.zip
├── Binaries/                           # 44 compiled plugin DLLs
│   ├── Case.ApplySysOrient.dll
│   ├── Case.AppsRibbon.dll
│   ├── Case.BasicReporting.dll
│   ├── Case.ChangeReplaceFamTypeNames.dll
│   ├── Case.DeleteViewsAndPurge.dll
│   ├── Case.DimensionOverrides.dll
│   ├── Case.Directionality.dll
│   ├── Case.DoorMarkRenumber.dll
│   ├── Case.Export.Families.dll
│   ├── Case.ExportSharedParameters.dll
│   ├── Case.ExtrudeRoomsToMass.dll
│   ├── Case.FamilySubcategories.dll
│   ├── Case.FreeBenchmarking.dll
│   ├── Case.HiddenParameterToParameter.dll
│   ├── Case.ImageToDraftingView.dll
│   ├── Case.LightingLayout.dll
│   ├── Case.LineChanger.dll
│   ├── Case.ModeledRoomTags.dll
│   ├── Case.MultiViewDuplicate.dll
│   ├── Case.ObjectStyles.dll
│   ├── Case.ParallelWalls.dll
│   ├── Case.ReportGroupsByView.dll
│   ├── Case.RoomSync.dll
│   ├── Case.SharedParameters.dll
│   ├── Case.Subs.DeleteViewsAndPurge.dll
│   ├── Case.Subs.Exceler8.dll
│   ├── Case.Subs.KeyMatcher.dll
│   ├── Case.Subs.Linestyles.dll
│   ├── Case.Subs.MultiViewDuplicate.dll
│   ├── Case.Subs.OpenNURBS.dll
│   ├── Case.Subs.Renamer.dll
│   ├── Case.Subs.RoomsToMass.dll
│   ├── Case.Subs.SharedParameters.dll
│   ├── Case.Subs.SuperTag.dll
│   ├── Case.Subs.ViewSync.dll
│   ├── Case.Subs.ViewTemplates.dll
│   ├── Case.Subs.Worksets.dll
│   ├── Case.Subs.Xyz.dll
│   ├── Case.UngroupAll.dll
│   ├── Case.ViewCreator.dll
│   ├── Case.ViewTemplates.dll
│   └── Case.ViewportReporting.dll
│
├── Manifests/                          # 44 Revit .addin manifest files
│   ├── Case.ApplySysOrient.addin
│   ├── Case.AppsRibbon.addin
│   └── ... (one for each plugin)
│
├── Documentation/                      # Plugin reference guides
│   └── README.txt
│
└── ZIP_INSTALLATION_GUIDE.md           # This file
```

## Step-by-Step Installation

### Step 1: Extract the ZIP File

1. **Download** the `Case.Plugins.2026.zip` file
2. **Right-click** on the ZIP file
3. **Select** "Extract All..." (or use 7-Zip, WinRAR)
4. **Choose extraction location** (e.g., `C:\Case.Plugins.2026\`)
5. **Click Extract**

**Result:** All files extracted to your chosen directory

```
C:\Case.Plugins.2026\
├── Binaries\
├── Manifests\
├── Documentation\
└── ZIP_INSTALLATION_GUIDE.md
```

### Step 2: Choose Installation Location

You have two options:

#### **Option A: Program Files (Recommended for all users)**

Place plugins in the standard location:
```
C:\Program Files\Case Plugins for Revit 2026\
├── Binaries\
└── Manifests\
```

**Advantages:**
- Organized with other software
- Easy to find and manage
- Single installation for all users
- Standard Windows convention

**Steps:**
1. Create folder: `C:\Program Files\Case Plugins for Revit 2026\`
2. Copy `Binaries\` folder into it
3. Copy `Manifests\` folder into it

#### **Option B: Revit Add-ins Folder (Easier, per-user)**

Place plugins in Revit's default add-in directory:
```
C:\Users\YourUsername\AppData\Roaming\Autodesk\Revit\Addins\2026\
```

**Advantages:**
- No administrator required
- Automatic Revit discovery
- Easy to manage per user
- Per-user installation

**Steps:**
1. Open Windows Explorer
2. Navigate to: `%APPDATA%\Autodesk\Revit\Addins\2026\`
   - Or: `C:\Users\[YourUsername]\AppData\Roaming\Autodesk\Revit\Addins\2026\`
3. Create `Case.Plugins` folder
4. Copy `Binaries\` and `Manifests\` into it

### Step 3: Register Plugins with Revit

#### **If Using Option A (Program Files):**

Create registry entries so Revit can find the plugins:

**Method 1: Use Registry Editor (easiest)**

1. **Download** this registry file template (save as `Case.Plugins.2026.reg`):

```registry
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Autodesk\Revit\Addins\2026]

[HKEY_CURRENT_USER\Software\Autodesk\Revit\Addins\2026\Case.Plugins]
"LoadPath"="C:\\Program Files\\Case Plugins for Revit 2026\\Binaries\\"
"ManifestPath"="C:\\Program Files\\Case Plugins for Revit 2026\\Manifests\\"
```

2. **Edit the paths** if you chose a different installation location
3. **Double-click** the .reg file
4. **Click Yes** when prompted to add to registry

**Method 2: Manual Registry Entry**

1. **Open Registry Editor** (`regedit.exe`)
2. **Navigate to:**
   ```
   HKEY_CURRENT_USER\Software\Autodesk\Revit\Addins\2026
   ```
3. **Create new key** called `Case.Plugins`
4. **Create string values:**
   - Name: `LoadPath`
     Value: `C:\Program Files\Case Plugins for Revit 2026\Binaries\`
   - Name: `ManifestPath`
     Value: `C:\Program Files\Case Plugins for Revit 2026\Manifests\`

#### **If Using Option B (Revit Add-ins Folder):**

No registry entries needed! Revit automatically discovers plugins in this folder.

### Step 4: Copy Add-in Manifest Files

Revit needs `.addin` files to load plugins.

**From extracted ZIP:**
```
Manifests\
├── Case.ApplySysOrient.addin
├── Case.AppsRibbon.addin
├── Case.BasicReporting.addin
└── ... (all 44 files)
```

**Copy these files to:**
- **Option A users:** `C:\Program Files\Case Plugins for Revit 2026\Manifests\`
- **Option B users:** `C:\Users\[YourUsername]\AppData\Roaming\Autodesk\Revit\Addins\2026\`

### Step 5: Verify Installation

1. **Launch Revit 2026**
2. **Wait for it to fully load** (plugins load on startup)
3. **Check Add-ins Tab:**
   - Click **Add-ins** tab in Revit ribbon
   - Look for Case plugin buttons
   - Or click **Manage → Add-ins → Revit Add-ins**
4. **Verify plugins appear** in the add-ins list

**Expected result:**
- All 44 plugins listed
- Green checkmarks indicate loaded plugins
- Red X's indicate errors (see troubleshooting)

## Uninstalling Plugins

### **If Using Option A (Program Files):**

1. **Delete the folder:**
   ```
   C:\Program Files\Case Plugins for Revit 2026\
   ```

2. **Remove registry entries:**
   - Open Registry Editor (`regedit.exe`)
   - Navigate to: `HKEY_CURRENT_USER\Software\Autodesk\Revit\Addins\2026`
   - Right-click `Case.Plugins` → Delete

### **If Using Option B (Revit Add-ins Folder):**

1. **Delete the folder:**
   ```
   C:\Users\[YourUsername]\AppData\Roaming\Autodesk\Revit\Addins\2026\Case.Plugins\
   ```

Restart Revit - plugins will be gone.

## Troubleshooting

### Plugins Don't Load in Revit

**Problem:** Add-ins tab empty or plugins show red X

**Solutions:**

1. **Check if files are in correct location:**
   ```
   Option A: C:\Program Files\Case Plugins for Revit 2026\Binaries\
   Option B: C:\Users\[User]\AppData\Roaming\Autodesk\Revit\Addins\2026\
   ```

2. **Verify .addin manifest files exist:**
   ```
   Option A: C:\Program Files\Case Plugins for Revit 2026\Manifests\
   Option B: C:\Users\[User]\AppData\Roaming\Autodesk\Revit\Addins\2026\
   ```

3. **Check Revit Journal log for errors:**
   - Location: `C:\Users\[YourUsername]\AppData\Local\Autodesk\Revit\Autodesk Revit 2026\Logs\`
   - File: `journal.txt` or `RevitLog.txt`
   - Look for error messages about plugin loading

4. **Restart Revit:**
   - Fully close Revit
   - Wait 5 seconds
   - Relaunch Revit
   - Plugins load on startup

### "Access Denied" Error When Copying Files

**Problem:** Can't copy to Program Files

**Solution:**
1. Open Command Prompt **as Administrator**
2. Or use **Option B** (Revit Add-ins folder) - no admin required
3. Or copy to desktop first, then move to Program Files

### "File Not Found" Error in Revit

**Problem:** Revit loads plugin but shows error

**Cause:** DLL path in .addin manifest is incorrect

**Solution:**
1. **Edit the .addin file** with Notepad
2. **Find the line:** `<Assembly>`
3. **Update the path** to match your installation
4. **Example:**
   ```xml
   <Assembly>C:\Program Files\Case Plugins for Revit 2026\Binaries\Case.AppsRibbon.dll</Assembly>
   ```
5. **Save and restart Revit**

### "This Add-in requires .NET Framework 4.8"

**Problem:** .NET Framework missing or outdated

**Solution:**
1. **Check installed .NET version:**
   - Open Command Prompt
   - Type: `reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full"`
   - Look for version 4.8 or higher

2. **If missing, install .NET 4.8:**
   - Download from: https://dotnet.microsoft.com/download/dotnet-framework/net48
   - Install and restart computer

3. **Restart Revit**

### "Registry Entry Not Found"

**Problem:** Registry entries not created

**Solution:**
1. **Use Option B** (Revit Add-ins folder) instead
2. Or **manually create registry entries** (see Step 3 above)
3. Or **use the provided .reg file** (double-click to import)

### Plugin Loads But Doesn't Work

**Problem:** Plugin appears in list but buttons don't work

**Causes and solutions:**
1. **Check Revit compatibility:**
   - Verify Revit 2026 (not 2023 or 2025)
   - Type: `Help → About Autodesk Revit` to verify version

2. **Check plugin settings:**
   - Open: `Manage → Add-ins → Revit Add-ins`
   - Verify plugin is checked (enabled)
   - Click Load to reload

3. **Review Revit Journal:**
   - Check `C:\Users\[User]\AppData\Local\Autodesk\Revit\Autodesk Revit 2026\Logs\`
   - Look for plugin-specific error messages

4. **Reinstall plugin:**
   - Delete DLL and .addin file
   - Restart Revit
   - Recopy files
   - Restart Revit again

## Advanced Options

### Installing Multiple Versions (2023 and 2026)

You can have both versions installed:

```
C:\Program Files\
├── Case Plugins for Revit 2023\
│   ├── Binaries\ (2023 DLLs)
│   └── Manifests\ (2023 .addin files)
│
└── Case Plugins for Revit 2026\
    ├── Binaries\ (2026 DLLs)
    └── Manifests\ (2026 .addin files)
```

Each version:
- Uses separate DLLs (2023 vs 2026)
- Uses separate registry paths
- Loads independently in each Revit version

### Silent Installation via Script

**PowerShell script to automate installation:**

```powershell
# Variables
$zipPath = "C:\Downloads\Case.Plugins.2026.zip"
$extractPath = "C:\Case.Plugins.2026"
$installPath = "C:\Program Files\Case Plugins for Revit 2026"

# Extract
Expand-Archive -Path $zipPath -DestinationPath $extractPath

# Copy to Program Files
New-Item -ItemType Directory -Path $installPath -Force
Copy-Item -Path "$extractPath\Binaries" -Destination $installPath -Recurse -Force
Copy-Item -Path "$extractPath\Manifests" -Destination $installPath -Recurse -Force

# Create registry entries
$regPath = "HKCU:\Software\Autodesk\Revit\Addins\2026\Case.Plugins"
New-Item -Path $regPath -Force
New-ItemProperty -Path $regPath -Name "LoadPath" -Value "$installPath\Binaries\" -PropertyType String -Force
New-ItemProperty -Path $regPath -Name "ManifestPath" -Value "$installPath\Manifests\" -PropertyType String -Force

Write-Host "Installation complete!"
```

### Network Installation

For shared network drive:

1. **Place plugins on network share:**
   ```
   \\server\plugins\Case.Plugins.2026\Binaries\
   \\server\plugins\Case.Plugins.2026\Manifests\
   ```

2. **Create registry entries pointing to network:**
   ```registry
   LoadPath=\\server\plugins\Case.Plugins.2026\Binaries\
   ManifestPath=\\server\plugins\Case.Plugins.2026\Manifests\
   ```

3. **Deploy registry file to all users** via Group Policy or script

4. **Advantages:**
   - Single installation for all users
   - Easy updates (just copy new DLLs)
   - No local disk space required

## Summary

### Quick Reference

| Task | Option A | Option B |
|------|----------|----------|
| **Install location** | Program Files | User AppData |
| **Admin required** | Yes | No |
| **Affects all users** | Yes | No (per-user) |
| **Registry entries** | Required | Not required |
| **Setup time** | 10 minutes | 5 minutes |
| **Best for** | Shared computers | Single user |

### Typical Installation Time

- **Extract ZIP:** 1-2 minutes
- **Copy files:** 2-3 minutes
- **Create registry entries:** 2-3 minutes (if Option A)
- **Restart Revit:** 2-3 minutes
- **Total:** 5-10 minutes

### File Locations at a Glance

**DLL files (pick one):**
- `C:\Program Files\Case Plugins for Revit 2026\Binaries\` (Option A)
- `C:\Users\YourName\AppData\Roaming\Autodesk\Revit\Addins\2026\` (Option B)

**.addin manifest files (same location as DLLs):**
- `C:\Program Files\Case Plugins for Revit 2026\Manifests\` (Option A)
- `C:\Users\YourName\AppData\Roaming\Autodesk\Revit\Addins\2026\` (Option B)

## Support

If you encounter issues:

1. **Review troubleshooting section** above
2. **Check Revit Journal log** for error messages
3. **Verify file paths** exactly match your installation
4. **Try Option B** (Revit Add-ins folder) if Option A fails
5. **Contact support** with journal log and error messages

---

**Version:** 1.0
**For:** Case Plugins for Revit 2026
**Updated:** February 2026
**Compatibility:** Revit 2026 (x64) on Windows 7+
