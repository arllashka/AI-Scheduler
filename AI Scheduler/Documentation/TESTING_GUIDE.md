# 🎯 Quick Test Guide - Task List with SwiftData

## ✅ What Just Got Connected

Your Task List now works with **real data** that **persists**!

---

## 🧪 Quick Tests (Do These Now!)

### Test 1: Add Your First Task (30 seconds)

1. **Open the app**
2. **Tap the "+" button** (top right)
3. Fill in:
   - Title: "Buy groceries"
   - Duration: 30 minutes (tap "30 min")
   - Priority: 5 (tap the 5 circle)
4. **Tap "Save"**

**Expected Result**: ✅ 
- Sheet closes
- New task appears in "To Schedule" section
- Stats show: Active = 1

---

### Test 2: Complete a Task (10 seconds)

1. **Tap the circle checkbox** next to your task
2. Watch it turn green with a checkmark

**Expected Result**: ✅
- Task moves to "Completed" section
- Green checkmark appears
- Stats update: Active = 0, Completed = 1

---

### Test 3: Delete a Task (10 seconds)

1. **Swipe left** on the completed task
2. **Tap the red "Delete" button**

**Expected Result**: ✅
- Task disappears
- Stats update: Completed = 0
- Empty state appears

---

### Test 4: Persistence Check (1 minute)

1. **Add 3-4 tasks** with different details
2. **Complete one or two** of them
3. **Close the app completely** (swipe up from bottom)
4. **Reopen the app**

**Expected Result**: ✅
- **All tasks still there!**
- Completion states preserved
- Everything exactly as you left it

---

### Test 5: Search (15 seconds)

1. Add tasks: "Buy milk", "Buy bread", "Call dentist"
2. **Pull down** to reveal search bar
3. **Type "buy"**

**Expected Result**: ✅
- Only "Buy milk" and "Buy bread" show
- Other tasks filtered out

---

### Test 6: Filters (20 seconds)

1. **Tap filter icon** (top left)
2. **Select "Unscheduled"**
3. **Tap "Done"**

**Expected Result**: ✅
- Only shows tasks without scheduled times
- Filter chip highlights "Unscheduled"

---

### Test 7: Fixed Time Task (30 seconds)

1. **Tap "+" to add task**
2. Title: "Team meeting"
3. **Toggle "Fixed Time Slot"** ON
4. **Select tomorrow at 2:00 PM**
5. **Tap "Save"**

**Expected Result**: ✅
- Task appears in "Scheduled" section
- Shows "2:00 PM" next to task
- Scheduled count increases

---

## 🎨 What You Should See

### Empty State (No Tasks)
```
┌─────────────────────────┐
│   📅  (large icon)      │
│                         │
│    No Tasks Yet         │
│                         │
│  Add your first task... │
│                         │
│   [  Add Task  ]        │
└─────────────────────────┘
```

### With Tasks
```
┌─────────────────────────┐
│  Stats: 3 Active, 1 Completed, 2 Scheduled
│                         │
│  [  AI Schedule  ]      │
│                         │
│  Filters: [All] [Scheduled] ...
│                         │
│  SCHEDULED              │
│  ○ Team meeting  2:00 PM│
│  ○ Buy groceries 9:00 AM│
│                         │
│  TO SCHEDULE            │
│  ○ Call dentist         │
│  ○ Write report         │
│                         │
│  COMPLETED              │
│  ✓ Email clients        │
└─────────────────────────┘
```

---

## 🐛 Troubleshooting

### "No tasks showing up"
- Check you tapped "Save" (not "Cancel")
- Check you entered a title (Save button disabled if empty)
- Check your filter isn't hiding tasks

### "Task disappeared when I closed app"
- Make sure you're testing on device/simulator (not Canvas preview)
- Check the app didn't crash (look at Xcode console)
- Try: Clean Build Folder (Shift+Cmd+K) and rebuild

### "Completion toggle not working"
- Make sure you're tapping the circle (not the whole card)
- Check Xcode console for errors
- Task should animate to completed section

### "Search not working"
- Pull down to reveal search bar
- Type at least 2 characters
- Search is case-insensitive

---

## 📊 What's Stored in Database

When you create a task, SwiftData saves:

```swift
TaskItem {
    id: UUID (unique)
    title: "Your task name"
    details: "Optional details"
    durationMinutes: 60
    priority: 5
    scheduledStart: Date? (if fixed time)
    scheduledEnd: Date? (if fixed time)
    isFixed: false
    isCompleted: false
    recurrence: nil
    createdAt: Date (now)
    updatedAt: Date (now)
}
```

---

## ✅ Success Criteria

You'll know it's working when:
- ✅ Can add tasks
- ✅ Tasks appear immediately
- ✅ Can mark tasks complete
- ✅ Can delete tasks
- ✅ Tasks persist after closing app
- ✅ Search filters tasks
- ✅ Stats update correctly
- ✅ Animations are smooth

---

## 🚀 What's Now Possible

With data persistence working, you can:

1. **Build your task list** - Add all your real tasks
2. **Organize by priority** - Use 1-10 scale
3. **Set fixed times** - For meetings/appointments
4. **Mark completed** - Track what's done
5. **Search everything** - Find tasks quickly

---

## 🎯 What's Next?

Now that tasks work, we can:

**Option A**: Connect Calendar to show scheduled tasks visually
**Option B**: Wire up AI Scheduling to auto-schedule your tasks
**Option C**: Add task editing (tap to edit details)
**Option D**: Add more features you want!

---

## 💡 Pro Tips

### Quickly Test Multiple Tasks
```
1. Add "Morning workout" - 30m - Priority 8
2. Add "Check email" - 15m - Priority 4
3. Add "Team meeting" - 60m - Priority 7 - Fixed at 2pm
4. Add "Lunch break" - 60m - Priority 1
5. Complete #2
6. See how list organizes automatically!
```

### Test Empty States
1. Delete all tasks
2. See friendly empty state
3. Tap "Add Task" button in empty state
4. Works same as "+" button

### Test Filters
1. Create mix of scheduled/unscheduled tasks
2. Toggle between filters
3. Watch sections appear/disappear

---

## 🎉 You're Done!

The task list is fully connected to SwiftData. Everything you do now **saves and persists**!

**Try it now**: Add 5 tasks, close the app, reopen. They're all still there! 🎊

Ready for the next step? Let me know!
