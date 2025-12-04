# 🚀 How to Run the Organization Script

## Quick Instructions

### Option 1: Safe Script (Recommended)

This script creates a backup before moving files:

```bash
# Make executable
chmod +x organize_files_safe.sh

# Run it
./organize_files_safe.sh
```

### Option 2: Simple Script

Basic organization without backup:

```bash
# Make executable
chmod +x organize_files.sh

# Run it
./organize_files.sh
```

## What the Scripts Do

### ✅ Safe Script (`organize_files_safe.sh`)
- Creates timestamped backup folder
- Colored output for easy reading
- Safety checks before moving files
- Warns if files already organized
- Creates README.md and .gitignore
- Detailed next steps instructions

### ✅ Simple Script (`organize_files.sh`)
- Moves files to organized folders
- Creates folder structure
- Basic status output
- Creates README.md
- Quick and straightforward

## Step-by-Step Guide

### 1. Open Terminal

```bash
# Navigate to your project
cd /path/to/AI\ Scheduler
```

### 2. Make Script Executable

```bash
chmod +x organize_files_safe.sh
```

### 3. Run the Script

```bash
./organize_files_safe.sh
```

### 4. Follow the Output

The script will:
- ✅ Create backup
- ✅ Create folder structure
- ✅ Move all files
- ✅ Show you what happened

### 5. Update Xcode

**Important:** After running the script:

1. **Close Xcode** if it's open
2. **Open your project** in Xcode
3. **If files show as red** (missing):
   - Right-click the red file
   - Choose "Delete" → "Remove Reference"
   - Drag the folder from Finder into Xcode
   - Choose "Create groups"
4. **Build and run** (⌘R)

## Folder Structure Created

```
AI Scheduler/
├── App/                    # AI_SchedulerApp.swift, ContentView.swift
├── Design/                 # DesignSystem.swift, UIComponents.swift
├── Views/
│   ├── Onboarding/        # OnboardingView.swift
│   ├── Tasks/             # TaskListView.swift, AddTaskView.swift
│   ├── Calendar/          # CalendarView.swift
│   └── Settings/          # SettingsView.swift
├── Models/
│   ├── Domain/            # TaskItem, TaskDTO, ScheduledSlot
│   └── API/               # SchedulerRequest, SchedulerResponse
├── Services/              # API services and coordinators
└── Testing/               # Sample data and tests

Documentation/             # All .md files
```

## Troubleshooting

### "Permission denied"
```bash
chmod +x organize_files_safe.sh
```

### "Command not found"
Make sure you're in the correct directory:
```bash
cd /path/to/your/project
ls -la organize_files_safe.sh
```

### Files Already Moved
If you've already run the script:
- The script will detect this
- It will ask if you want to reorganize
- Press 'N' to cancel

### Need to Undo
If using the safe script:
```bash
# Restore from backup
cp backup_20251204_*/* .
```

Or if using git:
```bash
git reset --hard HEAD
```

## After Organization

### Xcode Groups vs Physical Folders

These scripts create **physical folders** on disk. Xcode will need to be updated:

1. Open Xcode
2. Project Navigator will show misplaced files
3. Delete old references
4. Drag new folders into Xcode
5. Everything will work again!

### No Code Changes Needed

✅ Import statements stay the same  
✅ Build settings stay the same  
✅ Code works identically  
✅ Just better organized!

## Benefits

After organization:
- ✅ Easier to find files
- ✅ Better project navigation
- ✅ Clear logical structure
- ✅ Ready for team collaboration
- ✅ Scalable for future features

## Git

If using Git, commit after organizing:

```bash
git add .
git commit -m "Organize project files into logical structure"
git push
```

## Questions?

See `FILE_ORGANIZATION_GUIDE.md` for more details.

---

**Note**: Both scripts do the same thing. The "safe" version just has:
- Backup creation
- Colored output
- More safety checks
- Better instructions

Choose the one you're comfortable with!
