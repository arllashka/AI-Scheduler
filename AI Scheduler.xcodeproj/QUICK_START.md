# 🚀 Quick Start Guide: AI Scheduling

## Step 1: Get Your Gemini API Key

1. Visit: https://makersuite.google.com/app/apikey
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy the generated key

## Step 2: Configure the App

1. Open the app
2. Go to **Settings** tab (gear icon)
3. Tap **"Gemini API Key"**
4. Paste your API key
5. Tap **"Save API Key"**

## Step 3: Set Your Work Hours (Optional)

In Settings, configure:
- **Start Time**: When your workday begins (default: 9:00 AM)
- **End Time**: When your workday ends (default: 5:00 PM)
- **Break Duration**: Length of breaks in minutes (default: 60)
- **Max Consecutive Hours**: Maximum hours before a break (default: 3)

## Step 4: Add Your Tasks

1. Go to **Tasks** tab
2. Tap the **"+"** button
3. Enter:
   - Task title (e.g., "Write project proposal")
   - Duration (e.g., 120 minutes)
   - Priority (1-10, where 10 is highest)
   - Optional: Details, recurrence
4. Tap **"Add Task"**
5. Repeat for all tasks

## Step 5: Let AI Schedule Your Day

1. In the **Tasks** tab
2. Tap the big **"AI Schedule"** button
3. Wait a few seconds while AI processes
4. ✅ See your tasks scheduled!

## Step 6: View Your Schedule

### Calendar View:
- Tap **Calendar** tab
- See all tasks with scheduled times
- Visual timeline for the day
- Tap tasks to complete them

### Task List View:
- See tasks organized by:
  - **Scheduled** (with times)
  - **To Schedule** (not yet scheduled)
  - **Completed** (done!)

## 🎯 Tips for Best Results

### Priority Matters:
- Set higher priorities for urgent tasks
- AI schedules high-priority tasks first
- Use 8-10 for urgent, 5-7 for normal, 1-4 for low

### Be Realistic with Durations:
- Include time for breaks between tasks
- Add buffer time for meetings
- AI respects your total available hours

### Work Hours:
- Set realistic work hours
- AI won't schedule outside these times
- Adjust as needed for different days

### Fixed Time Slots:
- Mark tasks with fixed times (meetings, appointments)
- These become immovable in the schedule
- AI works around them

## 🔄 Re-Scheduling

If you need to reschedule:
1. **Option A**: Delete scheduled times manually and tap "AI Schedule" again
2. **Option B**: Complete finished tasks and add new ones, then reschedule
3. AI always respects already-scheduled tasks when adding new ones

## ❌ Troubleshooting

### "API Key Required" Error:
- Make sure you configured your API key in Settings
- The key should start with "AIza..."
- Try re-entering the key

### "No available time slots" Error:
- Check your work hours in Settings
- Make sure you have enough hours for all tasks
- Some tasks might be too long to fit

### Tasks Not Scheduling:
- Check if tasks have realistic durations
- Verify work hours cover enough time
- Reduce total duration of tasks if needed

### AI Schedule Button Disabled:
- You need at least one unscheduled task
- Make sure tasks aren't already scheduled
- Wait if scheduling is already in progress

## 🧪 Testing Without API Key

For development/testing, you can use the mock scheduler:

In `TaskListView.swift`, change:
```swift
@StateObject private var schedulerCoordinator = SchedulerCoordinator()
```
To:
```swift
@StateObject private var schedulerCoordinator = SchedulerCoordinator.mock()
```

This simulates AI scheduling without calling the real API.

## 📱 App Features

### ✅ Current Features:
- AI-powered task scheduling
- Task management (add, edit, complete, delete)
- Calendar visualization
- Work hours configuration
- Priority-based scheduling
- Duration tracking
- Search and filters
- Persistent storage (SwiftData)

### 🎨 UI Highlights:
- Modern design with Liquid Glass effects
- Beautiful gradient buttons
- Loading animations
- Empty states
- Success/error feedback
- Stats cards

## 🎉 Enjoy Your Productivity!

With AI Scheduler, you can:
- 📋 Never forget a task
- ⏰ Always know what to do next
- 🎯 Focus on priorities
- 📅 See your day at a glance
- ✅ Track completion
- 🚀 Get more done!

Happy scheduling! 🎊
