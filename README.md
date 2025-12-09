# AI Scheduler

iOS task scheduling application powered by OpenAI GPT-4o. Converts natural language into optimally scheduled tasks with temporal constraint handling.

## Overview

Natural language task scheduler for iOS. Input tasks like "gym three times next week at noon" or "grocery shopping next weekend" and the system parses intent, extracts temporal constraints, and creates scheduled tasks.

**Core capabilities:**
- Natural language parsing with GPT-4o
- Temporal constraint recognition (weekends, specific days, time ranges)
- Automatic task instance creation for recurring patterns
- AI-optimized scheduling with conflict resolution
- Duration and priority inference from context

## Screenshots

<div align="center">
  <img src="resources/example1.png" width="250" />
  <img src="resources/example1parsed.png" width="250" />
  <img src="resources/example1calendar.png" width="250" />
</div>

<div align="center">
  <img src="resources/mainview.png" width="250" />
  <img src="resources/SingleTaskView.png" width="250" />
  <img src="resources/completedTask.png" width="250" />
</div>

## Architecture

**NLP Pipeline:**
1. User input → NLP Parser (GPT-4o)
2. Extract: title, duration, priority, temporal constraints
3. Temporal Date Calculator: Convert relative dates to absolute
4. Task creation: Generate instances for recurring patterns
5. AI Scheduler (GPT-4o): Optimize placement with conflict resolution

**Core Components:**
- `NLPParserService`: OpenAI integration for parsing
- `TemporalDateCalculator`: Date calculation fallback system
- `OpenAISchedulerService`: Task scheduling optimization
- `TaskItem`: SwiftData persistence model

## Technology

- Platform: iOS 17.0+
- Framework: SwiftUI
- Storage: SwiftData
- AI: OpenAI GPT-4o API
- Language: Swift 5.9+

## Use Cases

**Fitness:**
```
"Workout at the gym 3 times next week in the morning"
→ 3 gym sessions Mon/Wed/Fri at 7 AM
```

**Errands:**
```
"Grocery shopping next weekend"
→ Schedules Saturday or Sunday only
```

**Work:**
```
"Team standup every weekday at 9am for 15 minutes"
→ Mon-Fri recurring meetings at 9 AM
```

**Personal:**
```
"Call mom tomorrow afternoon"
→ Scheduled 12 PM - 5 PM tomorrow
```

## What's Next

**Voice Recognition**
- Siri Shortcuts integration for hands-free task creation
- Real-time speech-to-text with NLP parsing

**Cloud Sync & Multi-Device**
- iCloud integration across iPhone, iPad, Mac
- Real-time sync with conflict resolution

**Calendar & Email Integration**
- Google Calendar two-way sync
- Gmail task extraction from emails
- Requires: Backend service for OAuth

**Smart Notifications**
- Location-based triggers
- Adaptive rescheduling suggestions
- Time-based reminders

---

Copyright © 2025 Arlan Kalin. All rights reserved.
