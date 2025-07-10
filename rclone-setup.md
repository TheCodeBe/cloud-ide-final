# ☁️ Cloud Storage Setup Guide

## 🎯 Goal: Auto-Save ALL Your Work to Google Drive

This guide ensures **everything you create gets saved to your cloud storage automatically**.

---

## 📂 How File Sync Works

### Directory Structure
```
/workspace/
├── cloud-files/          ← 🌟 WORK HERE for auto-sync
│   ├── my-projects/      ← Your coding projects
│   ├── documents/        ← Text files, notes
│   ├── scripts/          ← Utility scripts
│   └── downloads/        ← Downloaded files
├── local-projects/       ← Local only (won't sync)
└── temp/                 ← Temporary files
```

### 🔑 Key Rule: 
**Work in `/workspace/cloud-files/` = Auto-synced to Google Drive**  
**Work elsewhere = Lost when container restarts**

---

## 🚀 One-Time Setup (5 minutes)

### Step 1: Configure rclone
```bash
# In VS Code terminal
rclone config
```

**Follow these choices:**
1. **Name**: `gdrive` (or whatever you prefer)
2. **Storage**: Choose `15` (Google Drive)
3. **Client ID**: Press Enter (use default)
4. **Client Secret**: Press Enter (use default)
5. **Scope**: Choose `1` (full access)
6. **Root folder**: Press Enter (entire drive)
7. **Service account**: Press Enter (no)
8. **Auto config**: Choose `N` (we'll do manual)

**Copy the URL**, paste in browser, authorize, copy token back.

### Step 2: Test Connection
```bash
# List your Google Drive files
rclone ls gdrive:

# Should show your Drive contents!
```

### Step 3: Mount Your Drive
```bash
# Mount Google Drive to cloud-files folder
rclone mount gdrive: /workspace/cloud-files --daemon --allow-other --vfs-cache-mode full

# Verify it worked
ls /workspace/cloud-files
# Should show your Google Drive files!
```

---

## 💾 Daily Workflow

### ✅ DO THIS (Auto-synced):
```bash
# Create new project in cloud-files
cd /workspace/cloud-files
mkdir my-awesome-app
cd my-awesome-app

# Start coding - everything saves to Google Drive!
code app.js
```

### ❌ DON'T DO THIS (Won't sync):
```bash
# This won't sync to Google Drive
cd /workspace/local-projects
mkdir my-app  # This will be lost!
```

---

**🎉 Success!** Your work now auto-saves to Google Drive forever!