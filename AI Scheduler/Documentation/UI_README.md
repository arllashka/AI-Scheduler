# AI Scheduler - UI Documentation

## 📱 User Interface Overview

The AI Scheduler app features a modern, responsive design built with SwiftUI. The interface is designed to be intuitive, visually appealing, and optimized for iOS devices of all sizes.

---

## 🎨 Design System

### Color Palette
The app uses a carefully selected color palette that is consistent across all screens:

#### Primary Colors
- **Primary Blue** (`#3B82F6`) - Main brand color, buttons, active states
- **Primary Blue Light** (`#60A5FA`) - Hover states, lighter variants
- **Primary Blue Dark** (`#2563EB`) - Pressed states, darker variants

#### Accent Colors
- **Accent Purple** (`#8B5CF6`) - AI features, smart scheduling
- **Success Green** (`#10B981`) - Completed tasks, success states
- **Warning Orange** (`#F59E0B`) - Medium priority, warnings
- **Error Red** (`#EF4444`) - High priority, errors

#### Background Colors
- **Light Mode**: White, Light Gray variants
- **Dark Mode**: Dark Gray shades (automatic adaptation)

#### Priority Colors
- **Low Priority** - Green (`#10B981`)
- **Medium Priority** - Orange (`#F59E0B`)
- **High Priority** - Red (`#EF4444`)
- **Critical Priority** - Dark Red (`#DC2626`)

### Typography
Uses SF Rounded for headings and SF Pro for body text:
- **Large Title**: 34pt, Bold
- **Title 1**: 28pt, Bold
- **Title 2**: 22pt, Bold
- **Title 3**: 20pt, Semibold
- **Body**: 17pt, Regular
- **Caption**: 12pt, Regular

### Spacing System
Consistent spacing throughout the app:
- **XXSmall**: 4pt
- **XSmall**: 8pt
- **Small**: 12pt
- **Medium**: 16pt
- **Large**: 20pt
- **XLarge**: 24pt
- **XXLarge**: 32pt

### Corner Radius
- **Small**: 8pt
- **Medium**: 12pt
- **Large**: 16pt
- **Round**: Full circle

---

## 📂 UI Structure

### Main Navigation (Tab Bar)
The app uses a tab-based navigation with three main sections:

1. **Tasks Tab** - Task list and management
2. **Calendar Tab** - Schedule visualization
3. **Settings Tab** - Configuration and preferences

---

## 🖼️ Views & Screens

### 1. Onboarding Flow (`OnboardingView.swift`)
**Purpose**: First-time user experience

**Features**:
- 4-page walkthrough
- Introduces AI scheduling concept
- Gradient icon backgrounds
- Custom page indicators
- Skip/Next navigation

**Pages**:
1. Welcome - Introduction to AI Scheduler
2. Intelligent Scheduling - Explains AI features
3. Optimize Your Time - Benefits of smart scheduling
4. Ready to Start - Call to action

### 2. Task List View (`TaskListView.swift`)
**Purpose**: Main task management interface

**Components**:
- **Stats Cards**: Show active, completed, and scheduled task counts
- **AI Schedule Button**: Prominent gradient button for AI scheduling
- **Filter Chips**: Quick filters (All, Scheduled, Unscheduled, etc.)
- **Task Sections**:
  - Scheduled Tasks
  - Tasks to Schedule
  - Completed Tasks
- **Search Bar**: Filter tasks by title
- **Add Button**: Create new tasks

**Interactions**:
- Tap task to view details
- Tap checkbox to mark complete
- Swipe actions (future implementation)

### 3. Add Task View (`AddTaskView.swift`)
**Purpose**: Create and edit tasks

**Fields**:
- **Title**: Text input (required)
- **Details**: Multi-line text (optional)
- **Duration**: Quick select buttons (15m - 4h)
- **Priority**: 1-10 scale with visual indicators
- **Fixed Time**: Toggle + date picker
- **Recurrence**: Daily/Weekly/Monthly options

**Features**:
- AI tip card with scheduling advice
- Validation (title required)
- Cancel/Save buttons

### 4. Calendar View (`CalendarView.swift`)
**Purpose**: Visual schedule representation

**Components**:
- **Month Grid**: Full calendar view
  - Day cells with event indicators
  - Today highlighting
  - Selected date highlighting
- **Today's Schedule**: Timeline view
  - Time slots
  - Task cards with duration
  - Color-coded priority bars
  - Completion status

**Navigation**:
- Previous/Next month arrows
- "Today" button to jump to current date
- Day View link (future implementation)

### 5. Settings View (`SettingsView.swift`)
**Purpose**: App configuration

**Sections**:
- **AI Configuration**
  - Gemini API key setup
  - Modal sheet with instructions
- **Work Hours**
  - Start/end time pickers
  - Break duration
  - Max consecutive hours
- **Notifications**
  - Task reminder toggle
- **Display**
  - Appearance settings (Light/Dark/System)
  - Color palette preview
- **Data Management**
  - Export/Import data
  - Clear all data
- **About**
  - Version information
  - Credits
  - Links

---

## 🧩 Reusable Components (`UIComponents.swift`)

### Buttons

#### Primary Button
```swift
PrimaryButton("Schedule Tasks", icon: AppIcons.aiSchedule) {
    // Action
}
```
- Blue background
- White text
- Optional icon
- Loading state support

#### Secondary Button
```swift
SecondaryButton("Cancel", icon: AppIcons.close) {
    // Action
}
```
- Blue text
- Light blue background
- Optional icon

#### Icon Button
```swift
IconButton(icon: AppIcons.add) {
    // Action
}
```
- Circular
- Icon only
- Customizable size and color

### Task Card
```swift
TaskCard(
    title: "Task name",
    duration: "2 hours",
    priority: 8,
    isCompleted: false,
    scheduledTime: "9:00 AM"
) {
    // On tap
} onComplete: {
    // On complete toggle
}
```
- Shows task information
- Checkbox for completion
- Priority indicator (colored dot)
- Duration and scheduled time
- Interactive

### Empty State View
```swift
EmptyStateView(
    icon: "calendar.badge.plus",
    title: "No Tasks Yet",
    message: "Add your first task...",
    actionTitle: "Add Task"
) {
    // Action
}
```
- Large icon
- Title and message
- Optional action button

### Stats Card
```swift
StatsCard(
    icon: AppIcons.tasks,
    value: "12",
    label: "Active",
    color: .primaryBlue
)
```
- Icon
- Large value number
- Descriptive label
- Colored theme

### Other Components
- **Section Header**: Title with optional action button
- **Custom Text Field**: Icon + placeholder + binding
- **Priority Picker**: 1-10 circular buttons
- **Duration Picker**: Horizontal scroll with preset durations
- **Loading Overlay**: Full-screen loading indicator
- **AI Badge**: Gradient badge with sparkles icon
- **Filter Chip**: Selectable filter button

---

## 🎯 Responsive Design

### Device Support
- iPhone SE (small screens)
- iPhone 14/15 (standard)
- iPhone 14/15 Pro Max (large)
- iPad (responsive layout)

### Adaptations
- **Typography**: Scales with Dynamic Type
- **Layout**: Flexible spacing and sizing
- **Colors**: Automatic dark mode support
- **Touch Targets**: Minimum 44x44pt

---

## 🌈 Visual Hierarchy

### Priority Indicators
Tasks are visually prioritized through:
1. **Color**: Priority dots (green → orange → red)
2. **Position**: High-priority tasks appear first
3. **Typography**: Important items use bold text

### Status Indicators
- **Completed**: Green checkmark
- **Scheduled**: Blue time label
- **Unscheduled**: No time label
- **AI-Scheduled**: Purple AI badge

---

## 🔄 Interactions & Animations

### Transitions
- Tab switching: Fade
- View presentations: Sheet/modal
- Date changes: Smooth sliding
- Filter selection: Instant with color change

### Feedback
- Button press: Scale effect
- Completion: Checkmark animation (future)
- Success: Haptic feedback (future)
- Error: Alert presentation

---

## 📐 Layout Patterns

### List Views
- Vertical scroll
- Section headers
- Card-based items
- Pull-to-refresh (future)

### Form Views
- Grouped sections
- Clear labels above fields
- Validation feedback
- Save/Cancel actions

### Calendar Views
- Grid layout (7 columns)
- Scrollable month navigation
- Selected state highlighting
- Event indicators

---

## 🎨 Custom Modifiers

### Card Style
```swift
.cardStyle()
```
Applies rounded corners, background, and shadow

### Button Styles
```swift
.primaryButtonStyle()
.secondaryButtonStyle()
```
Pre-configured button appearances

### Text Field Style
```swift
.textFieldStyle()
```
Consistent input field styling

---

## 🖼️ Image Assets

See `IMAGE_ASSETS_NEEDED.md` for complete list of required images.

### Current Status
- ✅ Using SF Symbols (no custom images required yet)
- ⏳ Custom illustrations optional
- ⏳ App icon needed

### SF Symbols Used
- Navigation icons (house, calendar, gear)
- Action icons (plus, pencil, trash)
- Status icons (checkmark, circle)
- AI icons (sparkles, wand.and.stars)
- Time icons (clock, timer, alarm)

---

## 🚀 Performance Considerations

### Optimization
- Lazy loading of lists
- Efficient date calculations
- Minimal view redraws
- Mock data for preview/testing

### Memory
- No large image assets yet
- Lightweight views
- Proper state management
- SwiftData for persistence

---

## 🔮 Future Enhancements

### Planned UI Features
- [ ] Pull-to-refresh on task list
- [ ] Swipe actions (edit/delete/complete)
- [ ] Task detail view with full information
- [ ] Day view with hour-by-hour timeline
- [ ] Week view for multi-day scheduling
- [ ] Drag-and-drop task reordering
- [ ] Task categories with color coding
- [ ] Search with filters
- [ ] Quick add floating button
- [ ] Haptic feedback
- [ ] Animation polish
- [ ] Widget support
- [ ] iPad split-view layout
- [ ] Mac Catalyst support

### Accessibility
- [ ] VoiceOver optimization
- [ ] Dynamic Type support
- [ ] High contrast mode
- [ ] Reduce motion support
- [ ] Color blind friendly modes

---

## 📝 Code Organization

```
AI Scheduler/
├── App/
│   ├── AI_SchedulerApp.swift       # App entry point
│   └── ContentView.swift           # Tab navigation
│
├── Views/
│   ├── OnboardingView.swift        # First-time experience
│   ├── TaskListView.swift          # Main task list
│   ├── AddTaskView.swift           # Create/edit tasks
│   ├── CalendarView.swift          # Schedule visualization
│   └── SettingsView.swift          # Configuration
│
├── Components/
│   └── UIComponents.swift          # Reusable UI elements
│
├── Design/
│   └── DesignSystem.swift          # Colors, typography, spacing
│
└── Documentation/
    ├── IMAGE_ASSETS_NEEDED.md      # Image requirements
    └── UI_README.md                # This file
```

---

## 🎨 Design Principles

1. **Clarity**: Clear hierarchy and labeling
2. **Consistency**: Unified design language
3. **Efficiency**: Quick access to common actions
4. **Feedback**: Visual confirmation of actions
5. **Beauty**: Modern, polished aesthetic
6. **Accessibility**: Usable by everyone

---

## 🔗 Related Documentation

- [Architecture](./ARCHITECTURE.md) - Technical architecture
- [API Documentation](./API_README.md) - Gemini API integration
- [Image Assets](./IMAGE_ASSETS_NEEDED.md) - Required images

---

**Status**: ✅ UI Complete (No Data Connections)
**Last Updated**: December 4, 2025
**Version**: 1.0
