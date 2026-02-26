# ZIP Installation - Quick Reference (One Page)

## Two Installation Options

### **Option A: Program Files** (for all users)
```
Extract ZIP → Copy to C:\Program Files\Case Plugins for Revit 2026\ → Add registry entry → Restart Revit
```

### **Option B: Revit Add-ins Folder** (per-user, no admin)
```
Extract ZIP → Copy to AppData folder → Restart Revit
Done! (Automatic detection)
```

---

## Option A: Program Files Installation

### 1. Extract ZIP
- Right-click `Case.Plugins.2026.zip` → Extract All
- Extract to any folder (temporary)

### 2. Create Installation Folder
```
mkdir "C:\Program Files\Case Plugins for Revit 2026"
```

### 3. Copy Files
- Copy `Binaries\` folder to: `C:\Program Files\Case Plugins for Revit 2026\`
- Copy `Manifests\` folder to: `C:\Program Files\Case Plugins for Revit 2026\`

### 4. Create Registry Entries
**Open Command Prompt as Administrator** and paste:
```cmd
reg add "HKEY_CURRENT_USER\Software\Autodesk\Revit\Addins\2026\Case.Plugins" /v LoadPath /t REG_SZ /d "C:\Program Files\Case Plugins for Revit 2026\Binaries\"
reg add "HKEY_CURRENT_USER\Software\Autodesk\Revit\Addins\2026\Case.Plugins" /v ManifestPath /t REG_SZ /d "C:\Program Files\Case Plugins for Revit 2026\Manifests\"
```

### 5. Restart Revit
- Close Revit completely
- Reopen Revit 2026
- Check Add-ins tab for plugins

---

## Option B: Revit Add-ins Folder (Recommended for Most Users)

### 1. Extract ZIP
- Right-click `Case.Plugins.2026.zip` → Extract All
- Extract to any folder

### 2. Navigate to Revit Add-ins Folder
**Open File Explorer and go to:**
```
C:\Users\[YourUsername]\AppData\Roaming\Autodesk\Revit\Addins\2026\
```

**Can't find it?** Type in address bar:
```
%APPDATA%\Autodesk\Revit\Addins\2026\
```

### 3. Copy Plugin Files
- Create new folder: `Case.Plugins`
- Copy extracted `Binaries\` folder into `Case.Plugins\`
- Copy extracted `Manifests\` folder into `Case.Plugins\`

**Result:**
```
C:\Users\[User]\AppData\Roaming\Autodesk\Revit\Addins\2026\Case.Plugins\
├── Binaries\
│   ├── Case.AppsRibbon.dll
│   ├── Case.BasicReporting.dll
│   └── ... (42 more DLLs)
└── Manifests\
    ├── Case.AppsRibbon.addin
    ├── Case.BasicReporting.addin
    └── ... (42 more .addin files)
```

### 4. Restart Revit
- Close Revit completely
- Reopen Revit 2026
- Plugins automatically load

**That's it!** No registry editing needed.

---

## Verify Installation

After restarting Revit:

1. **Look for Case plugins in the Add-ins tab**
   - Should see new plugin buttons/menus

2. **Or check via Manage Add-ins:**
   - Click: **Manage → Add-ins → Revit Add-ins**
   - Look for "Case" plugins in the list
   - Should see green checkmarks (loaded)

3. **If plugins don't appear:**
   - See troubleshooting section below

---

## Common Issues

### Plugins Don't Show in Revit

**Try these steps in order:**

1. **Verify files are in correct location:**
   ```
   Option A: C:\Program Files\Case Plugins for Revit 2026\Binaries\
   Option B: C:\Users\[User]\AppData\Roaming\Autodesk\Revit\Addins\2026\Case.Plugins\Binaries\
   ```

2. **Check .addin files exist in same location as DLLs**

3. **Fully close Revit** (check Task Manager)

4. **Restart Revit** (cold start)

5. **Check Revit Journal for errors:**
   - Open: `C:\Users\[User]\AppData\Local\Autodesk\Revit\Autodesk Revit 2026\Logs\`
   - Open `journal.txt`
   - Search for "Case" or "error"

### "Access Denied" When Copying

**Use Option B instead** (AppData folder doesn't need admin)

Or open Command Prompt **as Administrator** to copy files

### Registry Command Doesn't Work

**Use this instead** (save as `install.reg`, double-click):
```registry
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Autodesk\Revit\Addins\2026\Case.Plugins]
"LoadPath"="C:\\Program Files\\Case Plugins for Revit 2026\\Binaries\\"
"ManifestPath"="C:\\Program Files\\Case Plugins for Revit 2026\\Manifests\\"
```

---

## Quick Comparison

| Factor | Option A | Option B |
|--------|----------|----------|
| Needs admin | ✓ Yes | ✗ No |
| Hard to uninstall | ✗ Easy | ✓ Very easy |
| Setup time | 5 min | 2 min |
| For all users | ✓ Yes | ✗ Per-user only |
| **Recommended** | **Shared PC** | **Single user** |

---

## File Manifest

**44 Plugins included:**

Case.ApplySysOrient, Case.AppsRibbon, Case.BasicReporting, Case.ChangeReplaceFamTypeNames, Case.DeleteViewsAndPurge, Case.DimensionOverrides, Case.Directionality, Case.DoorMarkRenumber, Case.Export.Families, Case.ExportSharedParameters, Case.ExtrudeRoomsToMass, Case.FamilySubcategories, Case.FreeBenchmarking, Case.HiddenParameterToParameter, Case.ImageToDraftingView, Case.LightingLayout, Case.LineChanger, Case.ModeledRoomTags, Case.MultiViewDuplicate, Case.ObjectStyles, Case.ParallelWalls, Case.ReportGroupsByView, Case.RoomSync, Case.SharedParameters, Case.Subs.DeleteViewsAndPurge, Case.Subs.Exceler8, Case.Subs.KeyMatcher, Case.Subs.Linestyles, Case.Subs.MultiViewDuplicate, Case.Subs.OpenNURBS, Case.Subs.Renamer, Case.Subs.RoomsToMass, Case.Subs.SharedParameters, Case.Subs.SuperTag, Case.Subs.ViewSync, Case.Subs.ViewTemplates, Case.Subs.Worksets, Case.Subs.Xyz, Case.UngroupAll, Case.ViewCreator, Case.ViewTemplates, Case.ViewportReporting

---

## Need Help?

See the full guide: **ZIP_INSTALLATION_GUIDE.md**

---

**Version:** 1.0 | **For:** Case Plugins for Revit 2026 | **Date:** February 2026
