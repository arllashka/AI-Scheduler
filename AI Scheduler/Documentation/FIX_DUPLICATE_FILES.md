# 🔧 Fixing Duplicate File Errors

## ❌ Current Problem

You have multiple copies of `AddTaskView.swift` and `RecurrenceType` enum:

```
❌ AI Scheduler/App/AddTaskView.swift
❌ AI Scheduler/App/AddTaskView 2.swift
❌ AI Scheduler/App/AddTaskView 3.swift
❌ AI Scheduler/Views/Tasks/AddTaskView.swift
❌ AddTaskView-App.swift (maybe)
```

This causes:
- "Invalid redeclaration of AddTaskView"
- "Invalid redeclaration of RecurrenceType"
- "Ambiguous use of 'init()'"

---

## ✅ Solution

### Method 1: Manual Cleanup in Xcode (Recommended)

#### Step 1: Find All Duplicates

1. **Open Xcode**
2. **Press Cmd+Shift+O** (Open Quickly)
3. **Type "AddTaskView"**
4. **You'll see multiple results**

#### Step 2: Identify the Correct File

The **correct file** should have:
- ✅ `import SwiftData`
- ✅ `@Environment(\.modelContext) private var modelContext`
- ✅ Full `saveTask()` function that creates TaskItem
- ✅ About 212 lines of code
- ✅ Working RecurrenceType enum at the bottom

Example of correct file:
```swift
import SwiftUI
import SwiftData

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    // ... rest of code ...
    
    private func saveTask() {
        let newTask = TaskItem(
            title: title,
            details: details.isEmpty ? nil : details,
            durationMinutes: durationMinutes,
            priority: priority
        )
        // ... more code ...
        modelContext.insert(newTask)
        try modelContext.save()
    }
}

enum RecurrenceType: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}
```

#### Step 3: Delete All Duplicates

For each duplicate file:

1. **Right-click the file** in Project Navigator
2. **Choose "Delete"**
3. **Select "Move to Trash"** (NOT "Remove Reference")
4. Click "Move to Trash"

Delete these files:
- ❌ `AddTaskView 2.swift`
- ❌ `AddTaskView 3.swift`
- ❌ `AddTaskView-App.swift`
- ❌ Any other duplicates

**Keep only ONE file**!

#### Step 4: Clean and Rebuild

1. **Close Xcode**
2. **Delete DerivedData**:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
3. **Reopen Xcode**
4. **Clean Build Folder**: Shift+Cmd+K
5. **Build**: Cmd+B

---

### Method 2: Using Terminal/Finder

#### Step 1: Find Duplicates

```bash
cd /path/to/your/project
find . -name "AddTaskView*"
```

#### Step 2: Remove Duplicates

```bash
# Run the cleanup script
chmod +x cleanup_duplicates.sh
./cleanup_duplicates.sh
```

Or manually:
```bash
# Remove numbered duplicates
rm "AddTaskView 2.swift"
rm "AddTaskView 3.swift"
rm "AddTaskView-App.swift"
```

#### Step 3: Clean Xcode

1. Close Xcode
2. Reopen project
3. Clean Build Folder (Shift+Cmd+K)
4. Build (Cmd+B)

---

## 🎯 Correct File Structure

After cleanup, you should have:

```
AI Scheduler/
├── Views/
│   └── Tasks/
│       ├── TaskListView.swift     ✅
│       └── AddTaskView.swift      ✅ (ONLY ONE!)
```

---

## 🐛 If Errors Persist

### Error: "Cannot find 'AddTaskView' in scope"

**Solution**: Make sure the file is:
1. In your Xcode project
2. Has correct target membership
3. Not marked as a test file

**Check Target Membership**:
1. Select the file
2. Open File Inspector (right panel)
3. Verify "AI Scheduler" is checked under Target Membership

### Error: Still seeing duplicates

**Solution**: 
1. Clean DerivedData:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
2. Quit Xcode completely
3. Reopen and rebuild

### Error: "Ambiguous use of 'RecurrenceType'"

**Solution**: Check that RecurrenceType is only defined once:
```bash
grep -r "enum RecurrenceType" .
```

Should only show ONE result in AddTaskView.swift

---

## 📋 Checklist

- [ ] Identified the correct AddTaskView.swift file
- [ ] Deleted all duplicate files (2, 3, -App versions)
- [ ] Closed Xcode
- [ ] Cleaned DerivedData
- [ ] Reopened Xcode
- [ ] Cleaned Build Folder (Shift+Cmd+K)
- [ ] Built successfully (Cmd+B)
- [ ] No more redeclaration errors

---

## 🚀 After Fixing

Once duplicates are removed:

1. **Build the project** (Cmd+B)
2. **Should compile successfully** ✅
3. **Run the app** (Cmd+R)
4. **Test adding a task**
5. **Verify it saves to database**

---

## 💡 Why This Happened

Likely causes:
1. **File duplication** when moving files
2. **Copy-paste** instead of move
3. **Git merge conflicts** created duplicates
4. **Xcode auto-generated** numbered copies

**Prevention**:
- Use "Move" not "Copy" when organizing
- Check for duplicates before building
- Use version control (git) to track changes

---

## 🆘 Still Having Issues?

If you still see errors after cleanup:

### Nuclear Option: Start Fresh

1. **Find the correct AddTaskView.swift**
2. **Copy its contents** to a text file
3. **Delete ALL AddTaskView files** from project
4. **Create new file**: File → New → File → Swift File
5. **Name it**: AddTaskView.swift
6. **Paste the correct content**
7. **Save**
8. **Build**

---

## ✅ Expected Result

After cleanup, you should be able to:
- ✅ Build without errors
- ✅ Run the app
- ✅ Add tasks successfully
- ✅ See tasks in both Task List and Calendar
- ✅ No "ambiguous" or "redeclaration" errors

---

**Run the cleanup now and let me know when it's done!** 🧹✨

Then we can continue with **Option A: AI Scheduling**! 🤖
