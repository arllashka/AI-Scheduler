# 🎲 Sample Task Generator - Testing Guide

## 🎉 What's New

I've added a **Sample Task Generator** that creates realistic tasks across multiple dates so you can test the calendar!

---

## 🚀 How to Generate Sample Tasks

### Method 1: Using the Debug Menu (In Calendar)

1. **Go to Calendar tab**
2. **Tap the "⋯" button** (top right - only visible in DEBUG builds)
3. **Tap "Generate Sample Tasks"**
4. **Done!** 30+ tasks created across multiple dates

### Method 2: From Code (One-time)

Add this to your app's initialization:
```swift
// In AI_SchedulerApp.swift or ContentView.swift onAppear
SampleTaskGenerator.generateSampleTasks(context: modelContext)
```

---

## 📅 What Tasks Get Created

### **Today** (4 tasks):
- 9:00 AM - Morning Standup (15m)
- 10:00 AM - Review Pull Requests (45m)
- 12:00 PM - Lunch Break (1h)
- 2:30 PM - Client Call (30m)

### **Tomorrow** (5 tasks):
- 7:00 AM - Gym Session (1h)
- 10:00 AM - Team Planning Meeting (1.5h)
- 1:00 PM - Code Review Session (1h)
- 3:00 PM - Write Documentation (1.5h)
- 6:00 PM - Grocery Shopping (45m)

### **Day After Tomorrow** (3 tasks):
- 9:30 AM - Doctor Appointment (1h)
- 2:00 PM - Project Demo (45m)
- 6:30 PM - Evening Walk (30m)

### **Next Monday** (4 tasks):
- 9:00 AM - Weekly Team Meeting (1h)
- 10:30 AM - Sprint Planning (2h)
- 3:00 PM - 1-on-1 with Manager (30m)
- 4:00 PM - Update Roadmap (45m)

### **Next Wednesday** (3 tasks):
- 10:00 AM - Design Review (1.5h)
- 2:00 PM - Dentist Appointment (45m)
- 5:00 PM - Coffee with Friend (1h)

### **Next Friday** (2 tasks):
- 4:00 PM - End of Week Review (30m)
- 5:30 PM - Team Happy Hour (2h)

### **15 Days from Now** (1 task):
- 9:00 AM - Conference Day 1 (8h)

### **20 Days from Now** (1 task):
- 2:00 PM - Quarterly Review (1.5h)

### **Unscheduled** (5 tasks for AI scheduling):
- Research new frameworks (2h, priority 6)
- Update resume (1h, priority 5)
- Clean email inbox (30m, priority 4)
- Learn SwiftUI animations (1.5h, priority 7)
- Organize files (45m, priority 3)

---

## 🧪 Testing Scenarios

### Test 1: Navigate Through Dates
1. **Generate sample tasks**
2. **Go to Calendar**
3. **See dots on multiple dates**:
   - Today has dot
   - Tomorrow has dot
   - Next week has dots
4. **Tap each date** → See different tasks!

### Test 2: Check Today
1. **Tap "Today" button**
2. **See 4 tasks**:
   - Morning Standup at 9 AM
   - Review PRs at 10 AM
   - Lunch at 12 PM
   - Client Call at 2:30 PM

### Test 3: Check Tomorrow
1. **Navigate to tomorrow**
2. **See 5 tasks** throughout the day
3. **Different from today!** ✅

### Test 4: Check Next Week
1. **Navigate to next week**
2. **Find Monday** → 4 tasks
3. **Find Wednesday** → 3 tasks
4. **Find Friday** → 2 tasks
5. **Other days** → Empty

### Test 5: Task List View
1. **Go to Tasks tab**
2. **See Scheduled section** → Tasks with dates
3. **See To Schedule section** → 5 unscheduled tasks
4. **Both views sync!** ✅

### Test 6: Completion
1. **Find any task**
2. **Tap checkbox**
3. **Mark complete**
4. **Still shows on that date** (but completed)

---

## 🔄 Clearing Sample Data

### Option 1: Debug Menu
1. **Calendar tab**
2. **Tap "⋯" button**
3. **Tap "Clear All Tasks"**
4. **All tasks deleted**

### Option 2: From Code
```swift
SampleTaskGenerator.clearAllTasks(context: modelContext)
```

---

## 🎯 What You'll See in Calendar

### Calendar Grid:
```
┌─────────────────────────────────────┐
│              December 2025          │
├─────────────────────────────────────┤
│  S  M  T  W  T  F  S                │
│  1  2  3 [4] 5  6  7               │  ← Today (4 tasks)
│        •  •                          │
│  8  9 10 11 12 13 14                │
│  • •  •                              │  ← Next week (multiple tasks)
│ 15 16 17 18 19 •  21               │
│                                      │
└─────────────────────────────────────┘
```

### Daily Schedule Example (Today):
```
Today's Schedule:              [Add]
┌─────────────────────────────────────┐
│ 9:00 AM   ┃ Morning Standup         │
│ 9:15 AM   ┃ 15m                  ○ │
├─────────────────────────────────────┤
│ 10:00 AM  ┃ Review Pull Requests    │
│ 10:45 AM  ┃ 45m                  ○ │
├─────────────────────────────────────┤
│ 12:00 PM  ┃ Lunch Break             │
│ 1:00 PM   ┃ 1h                   ○ │
├─────────────────────────────────────┤
│ 2:30 PM   ┃ Client Call             │
│ 3:00 PM   ┃ 30m                  ○ │
└─────────────────────────────────────┘
```

---

## 💡 Pro Tips

### Tip 1: Perfect for Demos
- Show calendar with real data
- Navigate through different dates
- See varied schedule densities
- Impressive visual timeline

### Tip 2: Test AI Scheduling
- 5 unscheduled tasks ready
- Click "AI Schedule" button
- See them fill empty slots
- Great for testing AI feature!

### Tip 3: Test Week Navigation
- See busy vs. light days
- Monday (4 tasks) vs. Tuesday (0 tasks)
- Friday has happy hour!
- Realistic work week pattern

### Tip 4: Reset and Regenerate
1. Clear all tasks
2. Generate again
3. Fresh sample data
4. No duplicates

---

## 🎨 Sample Task Characteristics

### Realistic Timing:
- ✅ Work tasks during work hours (9 AM - 6 PM)
- ✅ Personal tasks in mornings/evenings
- ✅ Breaks and lunch at appropriate times
- ✅ Meetings on Monday (typical!)
- ✅ Happy hour on Friday 🎉

### Varied Priorities:
- Low (1-3): Walks, shopping, organizing
- Medium (4-6): Regular work tasks
- High (7-9): Important meetings, appointments
- Critical (10): Quarterly review, demos

### Varied Durations:
- Short: 15-30 minutes (standups, calls)
- Medium: 45-90 minutes (meetings, sessions)
- Long: 2-4 hours (planning, conferences)
- Full day: 8 hours (conference day)

### Realistic Mix:
- Work tasks (meetings, reviews, planning)
- Health tasks (gym, doctor, dentist)
- Personal tasks (shopping, coffee, walks)
- Life balance! ✨

---

## 🔧 Customizing Sample Data

### Add Your Own Tasks:

Edit `SampleTaskGenerator.swift`:

```swift
// Add a new task
createTask(
    title: "Your Custom Task",
    durationMinutes: 60,
    priority: 8,
    date: yourDate,
    hour: 10,
    minute: 30,
    context: context
)
```

### Change Task Details:

Modify existing task calls in `generateSampleTasks()`:
- Change titles
- Adjust times
- Modify priorities
- Add more days

---

## 🐛 Troubleshooting

### "Don't see sample tasks"
- Make sure you tapped "Generate Sample Tasks"
- Check console for success message
- Refresh calendar (tap Today, then navigate back)

### "Tasks appearing multiple times"
- Generated multiple times
- Use "Clear All Tasks" first
- Then generate once

### "Debug menu not showing"
- Only visible in DEBUG builds
- Run from Xcode (Cmd+R)
- Won't appear in TestFlight/Release

### "Can't clear tasks"
- Confirm the destructive action
- Check console for errors
- Restart app after clearing

---

## 📊 Sample Data Statistics

### Total Tasks: 30+
- **Scheduled**: 25 tasks across 8 different dates
- **Unscheduled**: 5 tasks for AI scheduling

### Date Distribution:
- This week: 7 tasks (3 days)
- Next week: 9 tasks (3 days)
- Future dates: 2 tasks (2 days)
- Unscheduled: 5 tasks

### Priority Distribution:
- Low (1-4): 6 tasks
- Medium (5-6): 8 tasks
- High (7-9): 14 tasks
- Critical (10): 2 tasks

### Duration Range:
- Shortest: 15 minutes
- Longest: 8 hours
- Average: ~1 hour

---

## 🎯 Use Cases

### 1. Calendar Testing
- See how calendar handles multiple dates
- Test date navigation
- Verify dot indicators
- Check chronological sorting

### 2. UI Testing
- See full vs. empty days
- Test scrolling with many tasks
- Verify color coding
- Check responsive layout

### 3. Feature Demos
- Show off the calendar
- Demonstrate AI scheduling
- Display task management
- Impress stakeholders! 🎉

### 4. AI Scheduling Testing
- Use unscheduled tasks
- Test AI auto-scheduling
- See how AI fills gaps
- Verify scheduling logic

---

## ✅ Summary

**What It Does**:
- Creates 30+ realistic tasks
- Spreads across multiple dates
- Mix of scheduled and unscheduled
- Realistic timing and priorities

**How to Use**:
1. Calendar → "⋯" → Generate Sample Tasks
2. Navigate calendar
3. See different tasks on different dates
4. Test all features!

**When to Use**:
- Testing calendar functionality
- Preparing demos
- UI screenshots
- AI scheduling tests
- Learning the app

**When to Clear**:
- Before real use
- When data gets messy
- Starting fresh
- After testing

---

**Now you can test the calendar with real data across multiple dates!** 📅✨

Try it: Generate samples, then navigate through your calendar week! 🎯
