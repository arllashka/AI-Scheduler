# AI Scheduler - Complete API Architecture

## 📁 Project Structure

```
AI Scheduler/
├── Domain Models/
│   ├── DomainModelsTaskItem.swift          # SwiftData model for persistence
│   ├── DomainModelsTaskDTO.swift           # Data transfer object for API
│   └── DomainModelsScheduledSlot.swift     # Scheduled slot output
│
├── API Models/
│   ├── APIModelsSchedulerRequest.swift     # Request payload
│   │   ├── SchedulerRequest
│   │   ├── AvailableSlot
│   │   └── TimeConstraints
│   └── APIModelsSchedulerResponse.swift    # Response payload
│       ├── SchedulerResponse
│       ├── UnscheduledTask
│       └── SchedulerMetadata
│
├── Services/
│   ├── APIConfiguration.swift              # API config & error types
│   ├── ServicesGeminiSchedulerService.swift # Gemini API service
│   ├── ServicesMockSchedulerService.swift   # Mock service for testing
│   └── ServicesSchedulerCoordinator.swift   # Coordinator pattern
│
├── Testing/
│   ├── TestingSampleData.swift             # Sample data for previews/tests
│   └── TestsSchedulerServiceTests.swift    # Unit tests
│
├── Documentation/
│   ├── API_README.md                       # Complete API documentation
│   └── API_CONFIGURATION.md                # Setup & configuration guide
│
└── App/
    ├── AI_SchedulerApp.swift               # Main app entry point
    └── ContentView.swift                   # Main view (to be updated)
```

## 🔄 Data Flow

```
User Input (Tasks + Available Slots)
         ↓
   SwiftData (TaskItem)
         ↓
   Convert to TaskDTO
         ↓
SchedulerCoordinator
         ↓
GeminiSchedulerService
         ↓
   Build JSON Request
         ↓
   Gemini API Call
         ↓
   Parse JSON Response
         ↓
  SchedulerResponse
         ↓
   Apply to TaskItems
         ↓
   Update UI
```

## 🎯 Key Components

### 1. Domain Models

**TaskItem** - Local persistence model
- Properties: id, title, details, durationMinutes, priority, scheduledStart, scheduledEnd, isFixed, isCompleted, recurrence
- Methods: toDTO(), applyScheduledSlot()
- Uses: SwiftData for persistence

**TaskDTO** - API communication
- Lightweight version of TaskItem
- Custom Codable for ISO8601 dates
- Converts to/from TaskItem

**ScheduledSlot** - AI output
- Represents final scheduled time slot
- Properties: id, taskId, scheduledStart, scheduledEnd
- Methods: conflictsWith(), durationMinutes

### 2. API Layer

**Request Models:**
- `SchedulerRequest`: Complete request to Gemini
- `AvailableSlot`: Time slots available for scheduling
- `TimeConstraints`: Work hours, breaks, limits

**Response Models:**
- `SchedulerResponse`: Complete response from Gemini
- `UnscheduledTask`: Tasks that couldn't fit
- `SchedulerMetadata`: Processing information

**Configuration:**
- API endpoint URLs
- API key management
- Error types and handling
- Timeout and retry settings

### 3. Services

**GeminiSchedulerService** (Real API)
- Builds prompts for Gemini
- Handles API communication
- Parses AI responses
- Error handling and validation

**MockSchedulerService** (Testing)
- Simulates API calls
- Deterministic scheduling
- Configurable delays and failures
- No API key required

**SchedulerCoordinator** (Orchestration)
- Manages service lifecycle
- Publishes state changes
- Coordinates task scheduling
- Applies results to models

## 🚀 Usage Examples

### Basic Scheduling

```swift
@StateObject private var coordinator = SchedulerCoordinator()

func scheduleToday() async {
    let slots = [
        AvailableSlot(
            start: Date().addingTimeInterval(3600),
            end: Date().addingTimeInterval(28800)
        )
    ]
    
    let constraints = TimeConstraints()
    
    await coordinator.scheduleTasks(
        from: tasks,
        availableSlots: slots,
        constraints: constraints
    )
    
    if let response = coordinator.lastResponse {
        coordinator.applySchedule(to: tasks, from: response)
    }
}
```

### With Error Handling

```swift
func scheduleWithErrorHandling() async {
    await coordinator.scheduleTasks(...)
    
    if let error = coordinator.lastError {
        switch error {
        case .apiKeyMissing:
            showAPIKeySetupSheet = true
        case .rateLimitExceeded:
            showRateLimitAlert = true
        case .networkError:
            showNetworkErrorAlert = true
        default:
            showGenericError = true
        }
    }
}
```

### Using Mock for Development

```swift
#if DEBUG
@StateObject private var coordinator = SchedulerCoordinator.mock()
#else
@StateObject private var coordinator = SchedulerCoordinator()
#endif
```

## 🧪 Testing

### Running Tests

```swift
import Testing

@Test("Schedule tasks successfully")
func testScheduling() async throws {
    let service = await MockSchedulerService()
    
    let response = try await service.scheduleTasks(
        tasks: SampleData.sampleTaskDTOs,
        availableSlots: SampleData.sampleAvailableSlots,
        constraints: SampleData.defaultConstraints
    )
    
    #expect(response.scheduledSlots.count > 0)
}
```

### Sample Data

The project includes comprehensive sample data:
- `SampleData.sampleTasks` - Example tasks
- `SampleData.sampleAvailableSlots` - Time slots
- `SampleData.weeklyTasks()` - Generate weekly tasks
- `SampleData.weekOfAvailableSlots()` - Generate week schedule

## 📊 API Communication

### Request Format

```json
{
  "tasks": [{
    "id": "uuid",
    "title": "Task name",
    "durationMinutes": 60,
    "priority": 5,
    "fixedTimeSlot": null,
    "recurrence": null
  }],
  "availableSlots": [{
    "start": "2025-12-04T09:00:00Z",
    "end": "2025-12-04T17:00:00Z"
  }],
  "timeConstraints": {
    "workHoursStart": "09:00",
    "workHoursEnd": "17:00",
    "breakDuration": 60,
    "maxConsecutiveHours": 3,
    "timezone": "America/New_York"
  }
}
```

### Response Format

```json
{
  "scheduledSlots": [{
    "id": "uuid",
    "taskId": "uuid",
    "scheduledStart": "2025-12-04T09:00:00Z",
    "scheduledEnd": "2025-12-04T10:00:00Z"
  }],
  "unscheduledTasks": [{
    "id": "uuid",
    "taskId": "uuid",
    "reason": "Not enough time"
  }],
  "metadata": {
    "totalTasks": 10,
    "scheduledCount": 8,
    "unscheduledCount": 2,
    "processingTime": 1.5,
    "aiModel": "gemini-2.0-flash-exp",
    "timestamp": "2025-12-04T12:00:00Z"
  }
}
```

## 🔐 Security Considerations

### API Key Storage
- ✅ Store in Info.plist (excluded from version control)
- ✅ Use environment variables for development
- ✅ Use Keychain for production
- ❌ Never hardcode in source files
- ❌ Never commit to version control

### Network Security
- All communication over HTTPS
- Timeout handling (30 seconds)
- Retry logic with exponential backoff
- Rate limit detection and handling

### Data Privacy
- Tasks never stored on external servers
- API calls made directly to Gemini
- No intermediate servers
- User data stays on device

## 🎨 Customization

### Custom Prompt

Edit `GeminiSchedulerService.buildSchedulingPrompt()`:

```swift
return """
You are an intelligent task scheduler...

Additional Instructions:
- Schedule high-priority tasks in the morning
- Leave 10 minute buffers between tasks
- Group similar tasks together
- \(your custom rules here)

\(requestJSON)
"""
```

### Custom Model

Edit `APIConfiguration.swift`:

```swift
static let modelName = "gemini-1.5-pro" // Different model
```

### Custom Constraints

```swift
let constraints = TimeConstraints(
    workHoursStart: "07:00",  // Early start
    workHoursEnd: "19:00",    // Late end
    breakDuration: 90,         // Longer breaks
    maxConsecutiveHours: 2,    // More frequent breaks
    timezone: TimeZone.current.identifier
)
```

## 📈 Performance Optimization

### Caching

```swift
class ScheduleCache {
    private var cache: [String: SchedulerResponse] = [:]
    
    func get(key: String) -> SchedulerResponse? {
        return cache[key]
    }
    
    func set(key: String, value: SchedulerResponse) {
        cache[key] = value
    }
}
```

### Batching

```swift
func scheduleBatch(_ batches: [[TaskItem]]) async {
    for batch in batches {
        await coordinator.scheduleTasks(from: batch, ...)
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 sec delay
    }
}
```

### Debouncing

```swift
private var scheduleTask: Task<Void, Never>?

func scheduleWithDebounce() {
    scheduleTask?.cancel()
    scheduleTask = Task {
        try? await Task.sleep(nanoseconds: 500_000_000)
        await coordinator.scheduleTasks(...)
    }
}
```

## 🐛 Debugging

### Enable Logging

```swift
extension GeminiSchedulerService {
    func enableDebugLogging() {
        // Add print statements in service methods
        print("Request: \(requestJSON)")
        print("Response: \(responseText)")
    }
}
```

### Inspect API Calls

```swift
// Add breakpoint in callGeminiAPI() to inspect:
// - Request URL
// - Request body
// - Response status
// - Response body
```

### Test Without API

Use mock service extensively during development to avoid API costs and rate limits.

## 🔄 Next Steps

### Immediate
1. ✅ API layer complete
2. ⏭️ Build UI views
3. ⏭️ Implement task management
4. ⏭️ Add calendar visualization

### Future Enhancements
- [ ] Offline scheduling fallback
- [ ] Schedule optimization suggestions
- [ ] Multi-day scheduling
- [ ] Calendar integration
- [ ] Recurring task patterns
- [ ] Smart rescheduling
- [ ] Conflict resolution UI
- [ ] Export/import schedules

## 📚 Resources

- [API_README.md](./API_README.md) - Detailed API documentation
- [API_CONFIGURATION.md](./API_CONFIGURATION.md) - Setup guide
- [Gemini API Docs](https://ai.google.dev/docs)
- [SwiftData Guide](https://developer.apple.com/documentation/swiftdata)
- [Swift Concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)

---

**Status**: ✅ API Layer Complete
**Last Updated**: December 4, 2025
**Version**: 1.0
