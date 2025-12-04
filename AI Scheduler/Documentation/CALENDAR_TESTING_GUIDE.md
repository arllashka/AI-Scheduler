# 🗓️ Calendar Quick Test Guide

## ✅ What Just Got Connected

Your Calendar now displays **real scheduled tasks** from SwiftData!

---

## 🧪 Quick Tests (Do These Now!)

### Test 1: Create a Scheduled Task (1 minute)

1. **Go to Tasks tab** (first tab)
2. **Tap "+"** button
3. Fill in:
   - Title: "Doctor Appointment"
   - Duration: 60 minutes
   - Priority: 7
   - **Toggle "Fixed Time Slot" ON**
   - **Select tomorrow at 2:00 PM**
4. **Tap "Save"**
5. **Switch to Calendar tab** (second tab)
6. **Find tomorrow's date**

**Expected Result**: ✅
- Tomorrow has a small dot under the number
- Tap tomorrow → Task appears with "2:00 PM - 3:00 PM"
- Shows title and duration

---

### Test 2: View Today's Schedule (30 seconds)

1. **Go to Calendar tab**
2. **Look at today's date** (should have blue border)
3. **Check schedule below calendar**

**Expected Result**: ✅
- If you have tasks today → They appear in timeline
- If no tasks today → "No tasks scheduled" message
- Empty state shows friendly message

---

### Test 3: Navigate Months (20 seconds)

1. **In Calendar tab**
2. **Tap left arrow** (previous month)
3. **Tap right arrow** (next month)
4. **Tap "Today" button** (top right)

**Expected Result**: ✅
- Calendar changes months smoothly
- Shows different days
- "Today" button returns to current month
- Today's date has blue border

---

### Test 4: Complete Task from Calendar (15 seconds)

1. **Find a scheduled task** in calendar
2. **Tap the checkbox** (circle icon)
3. **Watch it change**

**Expected Result**: ✅
- Checkbox fills with green checkmark
- Task becomes semi-transparent (60% opacity)
- Change saves automatically
- Go to Tasks tab → Task shows as completed there too!

---

### Test 5: Check Multiple Days (30 seconds)

1. **Create 3-4 tasks** with different fixed times
   - One today
   - One tomorrow
   - One next week
2. **Go to Calendar**
3. **Look at the calendar grid**

**Expected Result**: ✅
- Dots appear under dates with tasks
- Only days with scheduled tasks have dots
- Tap any day with dot → See tasks for that day

---

### Test 6: Time Sorting (20 seconds)

1. **Create 3 tasks for same day**:
   - "Morning workout" - 7:00 AM
   - "Lunch" - 12:00 PM
   - "Team meeting" - 3:00 PM
2. **Go to Calendar**
3. **Select that day**

**Expected Result**: ✅
- Tasks appear in chronological order:
  1. Morning workout (7:00 AM)
  2. Lunch (12:00 PM)
  3. Team meeting (3:00 PM)
- Each shows start/end times
- Each shows duration

---

## 🎨 What You Should See

### Calendar with Tasks:
```
┌─────────────────────────────────┐
│     December 2025               │
│  S  M  T  W  T  F  S           │
│  1  2  3  4  5  6  7           │
│              •                  │  ← Dots on busy days
│  8  9 10 11 12 13 14           │
│     •     •                     │
│ 15 16 17 18 19 20 21           │
│                 •               │
└─────────────────────────────────┘

Today's Schedule:
┌─────────────────────────────────┐
│ 9:00 AM  │ Morning Meeting      │
│ 10:00 AM │ 1h              ○   │
├─────────────────────────────────┤
│ 2:00 PM  │ Doctor Appointment   │
│ 3:00 PM  │ 1h              ○   │
└─────────────────────────────────┘
```

### Task Card Detail:
```
┌────────────────────────────────────┐
│ 9:00 AM  ┃ Task Title             │
│ 10:00 AM ┃ 1h                  ○ │
└────────────────────────────────────┘
    ↑       ↑    ↑                ↑
  Times   Priority Duration   Checkbox
         Color Bar
```

---

## 🐛 Troubleshooting

### "No dots appearing on calendar"
- Make sure tasks have "Fixed Time Slot" enabled
- Check that `scheduledStart` is not nil
- Try restarting the app

### "Task shows on wrong day"
- Check timezone settings
- Verify the date you selected when creating task
- Times are in local timezone

### "Can't complete task from calendar"
- Make sure you're tapping the checkbox (circle icon)
- Check Xcode console for errors
- Try from Tasks tab instead

### "Tasks not sorted by time"
- This should happen automatically
- Check that scheduledStart times are different
- Try recreating tasks with clear time differences

---

## 💡 Pro Tips

### Create a Sample Schedule
Quick way to test everything:

```
Monday:
- 7:00 AM - Morning workout (30m)
- 9:00 AM - Work start (8h)
- 12:00 PM - Lunch (1h)
- 5:00 PM - Evening run (30m)

Tuesday:
- 9:00 AM - Team meeting (1h)
- 2:00 PM - Client call (30m)

Wednesday:
- 10:00 AM - Doctor appointment (1h)
```

### Visual Calendar Testing
1. Set tasks across different weeks
2. Navigate through months
3. See how dots appear/disappear
4. Test "Today" button from different months

### Priority Color Testing
Create tasks with different priorities:
- Priority 1-3: Green bar
- Priority 4-6: Orange bar
- Priority 7-9: Red bar
- Priority 10: Dark red bar

---

## 🎯 Integration Test

### Test Task List ↔️ Calendar Sync

1. **In Tasks tab**: Create task "Test Task"
2. **Toggle "Fixed Time Slot"**
3. **Set to today at 4:00 PM**
4. **Tap "Save"**
5. **Go to Calendar tab**
6. **Tap today**
7. **See "Test Task" at 4:00 PM** ✅
8. **Tap checkbox to complete**
9. **Go back to Tasks tab**
10. **See task in "Completed" section** ✅

**Result**: Both views show same data! Perfect sync! 🎊

---

## 🚀 What Works Now

### Calendar View:
- ✅ Month grid with navigation
- ✅ Day cells with dot indicators
- ✅ Today highlighting
- ✅ Selected date highlighting
- ✅ "Today" quick jump button

### Daily Schedule:
- ✅ Shows tasks for selected date
- ✅ Time-sorted chronologically
- ✅ Start and end times displayed
- ✅ Duration shown
- ✅ Priority color bars
- ✅ Completion checkboxes
- ✅ Empty state message

### Interactions:
- ✅ Navigate months
- ✅ Select any day
- ✅ Toggle task completion
- ✅ Smooth animations
- ✅ Auto-save to database
- ✅ Sync with Tasks tab

---

## 🎉 Success Checklist

Calendar is working when:
- ✅ Can see current month
- ✅ Dots appear on scheduled days
- ✅ Can navigate months
- ✅ Can select different days
- ✅ Tasks appear for selected day
- ✅ Tasks sorted by time
- ✅ Can complete tasks
- ✅ Changes persist
- ✅ Syncs with Tasks tab
- ✅ Empty states show correctly

---

## 🎯 What's Next?

Now that both Task List and Calendar work:

**Option A**: 🤖 **Implement AI Scheduling**
- Click "AI Schedule" button
- Watch tasks auto-organize
- See calendar fill up magically!

**Option B**: ✏️ **Add Task Editing**
- Tap task to edit
- Change scheduled times
- Modify details

**Option C**: 📊 **Add Week View**
- See 7 days at once
- Better overview
- Drag tasks between days

---

## 💬 Test Scenarios

### Scenario 1: Morning Routine
```
6:00 AM - Wake up & exercise (1h)
7:00 AM - Breakfast (30m)
7:30 AM - Get ready (30m)
8:00 AM - Commute (30m)
8:30 AM - Work starts (8h)
```

### Scenario 2: Busy Day
```
9:00 AM - Standup meeting (15m)
10:00 AM - Client presentation (1h)
12:00 PM - Lunch with team (1h)
2:00 PM - Code review (1h)
4:00 PM - Planning session (2h)
```

### Scenario 3: Weekend
```
Saturday:
10:00 AM - Grocery shopping (2h)
3:00 PM - Gym (1h)

Sunday:
11:00 AM - Brunch (2h)
2:00 PM - Hobby time (3h)
```

Create these and watch your calendar come alive! 🗓️✨

---

**You're all set!** Go test the calendar now! 🚀
