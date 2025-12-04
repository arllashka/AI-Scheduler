# API Layer Quick Reference

## 🚀 Quick Start

### 1. Add Your API Key
```swift
// In Info.plist
<key>GEMINI_API_KEY</key>
<string>your_api_key_here</string>
```

### 2. Basic Usage
```swift
@StateObject private var coordinator = SchedulerCoordinator()

func schedule() async {
    await coordinator.scheduleTasks(
        from: tasks,
        availableSlots: availableSlots,
        constraints: TimeConstraints()
    )
}
```

## 📦 Core Components

### Services
- `GeminiSchedulerService` - Real Gemini API
- `MockSchedulerService` - Testing/development
- `SchedulerCoordinator` - Main orchestrator

### Models
- `TaskItem` - SwiftData persistence
- `TaskDTO` - API communication
- `ScheduledSlot` - Output result
- `AvailableSlot` - Input time slots
- `TimeConstraints` - Scheduling rules

## 🎯 Common Patterns

### Create Available Slots
```swift
let slots = [
    AvailableSlot(
        start: Date().addingTimeInterval(3600),  // 1 hour from now
        end: Date().addingTimeInterval(28800)     // 8 hours from now
    )
]
```

### Set Time Constraints
```swift
let constraints = TimeConstraints(
    workHoursStart: "09:00",
    workHoursEnd: "17:00",
    breakDuration: 60,
    maxConsecutiveHours: 3
)
```

### Schedule Tasks
```swift
await coordinator.scheduleTasks(
    from: tasks,
    availableSlots: slots,
    constraints: constraints
)
```

### Apply Results
```swift
if let response = coordinator.lastResponse {
    coordinator.applySchedule(to: tasks, from: response)
}
```

### Handle Errors
```swift
if let error = coordinator.lastError {
    switch error {
    case .apiKeyMissing:
        // Show API key setup
    case .rateLimitExceeded:
        // Wait and retry
    case .networkError(let underlyingError):
        // Handle network issue
    default:
        // Generic error handling
    }
}
```

## 🧪 Testing

### Use Mock Service
```swift
let coordinator = SchedulerCoordinator.mock()
```

### Use Sample Data
```swift
let tasks = SampleData.sampleTasks
let slots = SampleData.sampleAvailableSlots
let constraints = SampleData.defaultConstraints
```

### Write Tests
```swift
@Test("Schedule tasks")
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

## 🔧 Configuration

### Development
```swift
#if DEBUG
let coordinator = SchedulerCoordinator.mock()
#else
let coordinator = SchedulerCoordinator()
#endif
```

### Custom Model
```swift
APIConfiguration.modelName = "gemini-1.5-pro"
```

### Custom Timeout
```swift
APIConfiguration.timeoutInterval = 60
```

## 📊 Response Handling

### Check Success
```swift
if let response = coordinator.lastResponse {
    print("Scheduled: \(response.scheduledSlots.count)")
    print("Unscheduled: \(response.unscheduledTasks.count)")
}
```

### Handle Unscheduled Tasks
```swift
for unscheduled in response.unscheduledTasks {
    print("Task \(unscheduled.taskId): \(unscheduled.reason)")
}
```

### Show Metadata
```swift
let metadata = response.metadata
print("Processing time: \(metadata.processingTime)s")
print("AI model: \(metadata.aiModel)")
```

## 🎨 SwiftUI Integration

### Basic View
```swift
struct SchedulerView: View {
    @StateObject private var coordinator = SchedulerCoordinator()
    @Query private var tasks: [TaskItem]
    
    var body: some View {
        VStack {
            if coordinator.isLoading {
                ProgressView()
            }
            
            Button("Schedule") {
                Task { await schedule() }
            }
            .disabled(coordinator.isLoading)
        }
    }
    
    func schedule() async {
        await coordinator.scheduleTasks(
            from: tasks,
            availableSlots: availableSlots,
            constraints: TimeConstraints()
        )
    }
}
```

### With Error Alert
```swift
.alert("Error", isPresented: .constant(coordinator.lastError != nil)) {
    Button("OK") { coordinator.lastError = nil }
} message: {
    Text(coordinator.lastError?.localizedDescription ?? "")
}
```

### With Success Message
```swift
.alert("Success", isPresented: .constant(showSuccess)) {
    Button("OK") { showSuccess = false }
} message: {
    if let response = coordinator.lastResponse {
        Text("Scheduled \(response.scheduledSlots.count) tasks")
    }
}
```

## 🔄 Task Conversion

### TaskItem → TaskDTO
```swift
let dto = taskItem.toDTO()
```

### TaskDTO → TaskItem
```swift
let item = dto.toTaskItem()
```

### Apply Schedule to TaskItem
```swift
taskItem.applyScheduledSlot(scheduledSlot)
```

## 📁 File Organization

```
Domain Models/
  - DomainModelsTaskItem.swift
  - DomainModelsTaskDTO.swift
  - DomainModelsScheduledSlot.swift

API Models/
  - APIModelsSchedulerRequest.swift
  - APIModelsSchedulerResponse.swift

Services/
  - APIConfiguration.swift
  - ServicesGeminiSchedulerService.swift
  - ServicesMockSchedulerService.swift
  - ServicesSchedulerCoordinator.swift

Testing/
  - TestingSampleData.swift
  - TestsSchedulerServiceTests.swift
```

## 🐛 Common Issues

| Issue | Solution |
|-------|----------|
| "API key missing" | Add GEMINI_API_KEY to Info.plist |
| "Rate limit exceeded" | Use mock service or wait |
| "Invalid response" | Check Gemini API status |
| "Network error" | Verify internet connection |
| Tests failing | Use mock service in tests |

## 📚 Documentation

- **ARCHITECTURE.md** - Complete architecture overview
- **API_README.md** - Detailed API documentation
- **API_CONFIGURATION.md** - Setup and configuration guide
- **This file** - Quick reference

## 🎓 Learning Path

1. ✅ Read this quick reference
2. ⏭️ Review ARCHITECTURE.md for big picture
3. ⏭️ Read API_README.md for detailed info
4. ⏭️ Follow API_CONFIGURATION.md for setup
5. ⏭️ Explore sample data and tests
6. ⏭️ Build your first scheduling view

## 💡 Pro Tips

- Always use mock service during development
- Test with sample data before real tasks
- Handle all error cases in production
- Cache responses when possible
- Monitor API usage to avoid rate limits
- Use debouncing for user-triggered scheduling
- Provide offline fallback when possible

---

**Quick Links:**
- Get API Key: https://makersuite.google.com/app/apikey
- Gemini Docs: https://ai.google.dev/docs
- SwiftData Guide: https://developer.apple.com/documentation/swiftdata
