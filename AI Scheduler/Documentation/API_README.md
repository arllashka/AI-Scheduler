# AI Scheduler - API Layer Documentation

## Overview

The AI Scheduler app uses Google's Gemini API (specifically `gemini-2.0-flash-exp` model) to intelligently schedule tasks based on priorities, time constraints, and available time slots.

## Architecture

The API layer consists of several components organized by responsibility:

### Domain Models
- **`TaskItem.swift`** - SwiftData model for local task persistence
- **`TaskDTO.swift`** - Data Transfer Object for API communication
- **`ScheduledSlot.swift`** - Final output structure representing scheduled time slots

### API Models
- **`SchedulerRequest.swift`** - Request payload sent to Gemini
  - `SchedulerRequest` - Main request structure
  - `AvailableSlot` - Available time slots for scheduling
  - `TimeConstraints` - Working hours, breaks, and other constraints

- **`SchedulerResponse.swift`** - Response from Gemini API
  - `SchedulerResponse` - Main response structure
  - `UnscheduledTask` - Tasks that couldn't be scheduled
  - `SchedulerMetadata` - Information about the scheduling operation

### Services
- **`GeminiSchedulerService.swift`** - Main service for Gemini API communication
- **`MockSchedulerService.swift`** - Mock service for testing without API calls
- **`SchedulerCoordinator.swift`** - Coordinator managing scheduling operations
- **`APIConfiguration.swift`** - API configuration and error types

## Setup

### 1. Get Gemini API Key

1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create a new API key
3. Copy the API key

### 2. Configure API Key

**Option A: Using Info.plist (Recommended)**

Add to your `Info.plist`:
```xml
<key>GEMINI_API_KEY</key>
<string>YOUR_API_KEY_HERE</string>
```

**Option B: Using Environment Variable**

Set the environment variable in your Xcode scheme:
1. Product → Scheme → Edit Scheme
2. Run → Arguments → Environment Variables
3. Add: `GEMINI_API_KEY` = `your_api_key_here`

**Option C: Hardcode (Development Only)**

Edit `APIConfiguration.swift`:
```swift
static var apiKey: String {
    return "your_api_key_here" // NOT recommended for production
}
```

## Usage

### Basic Usage

```swift
import SwiftUI

struct SchedulerView: View {
    @StateObject private var coordinator = SchedulerCoordinator()
    @Query private var tasks: [TaskItem]
    
    var body: some View {
        VStack {
            if coordinator.isLoading {
                ProgressView("Scheduling tasks...")
            }
            
            Button("Schedule Tasks") {
                Task {
                    await scheduleAllTasks()
                }
            }
            .disabled(coordinator.isLoading)
        }
        .alert("Error", isPresented: .constant(coordinator.lastError != nil)) {
            Button("OK") {
                coordinator.lastError = nil
            }
        } message: {
            Text(coordinator.lastError?.localizedDescription ?? "")
        }
    }
    
    func scheduleAllTasks() async {
        // Define available time slots
        let availableSlots = [
            AvailableSlot(
                start: Date().addingTimeInterval(3600), // 1 hour from now
                end: Date().addingTimeInterval(21600)   // 6 hours from now
            )
        ]
        
        // Define time constraints
        let constraints = TimeConstraints(
            workHoursStart: "09:00",
            workHoursEnd: "17:00",
            breakDuration: 60,
            maxConsecutiveHours: 3
        )
        
        // Schedule tasks
        await coordinator.scheduleTasks(
            from: tasks,
            availableSlots: availableSlots,
            constraints: constraints
        )
        
        // Apply results if successful
        if let response = coordinator.lastResponse {
            coordinator.applySchedule(to: tasks, from: response)
        }
    }
}
```

### Using Mock Service for Testing

```swift
// Create coordinator with mock service
let coordinator = SchedulerCoordinator.mock()

// Configure mock behavior
if let mockService = coordinator.service as? MockSchedulerService {
    mockService.simulatedDelay = 0.5 // Fast response
    mockService.shouldFail = false   // Success scenario
}
```

### Direct Service Usage

```swift
// Using Gemini service directly
let service = GeminiSchedulerService()

do {
    let response = try await service.scheduleTasks(
        tasks: taskDTOs,
        availableSlots: availableSlots,
        constraints: constraints
    )
    
    print("Scheduled \(response.scheduledSlots.count) tasks")
    print("Unscheduled \(response.unscheduledTasks.count) tasks")
    
    for unscheduled in response.unscheduledTasks {
        print("Couldn't schedule task: \(unscheduled.reason)")
    }
} catch {
    print("Error: \(error.localizedDescription)")
}
```

## API Request Format

The scheduler sends the following JSON structure to Gemini:

```json
{
  "tasks": [
    {
      "id": "uuid",
      "title": "Task name",
      "durationMinutes": 60,
      "priority": 5,
      "fixedTimeSlot": null,
      "recurrence": null
    }
  ],
  "availableSlots": [
    {
      "start": "2025-12-04T09:00:00Z",
      "end": "2025-12-04T17:00:00Z"
    }
  ],
  "timeConstraints": {
    "workHoursStart": "09:00",
    "workHoursEnd": "17:00",
    "breakDuration": 60,
    "maxConsecutiveHours": 3,
    "timezone": "America/New_York"
  }
}
```

## API Response Format

Gemini returns:

```json
{
  "scheduledSlots": [
    {
      "id": "uuid",
      "taskId": "uuid",
      "scheduledStart": "2025-12-04T09:00:00Z",
      "scheduledEnd": "2025-12-04T10:00:00Z"
    }
  ],
  "unscheduledTasks": [
    {
      "id": "uuid",
      "taskId": "uuid",
      "reason": "Not enough available time"
    }
  ],
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

## Error Handling

The API layer defines several error types:

- **`apiKeyMissing`** - Gemini API key not configured
- **`invalidURL`** - Malformed API endpoint
- **`networkError`** - Network connectivity issues
- **`rateLimitExceeded`** - API rate limit hit (429 status)
- **`serverError`** - Server-side error with status code
- **`decodingError`** - Failed to parse response
- **`invalidRequest`** - Invalid request parameters
- **`invalidResponse`** - Unexpected response format

Example error handling:

```swift
do {
    let response = try await service.scheduleTasks(...)
} catch APIError.apiKeyMissing {
    // Prompt user to configure API key
} catch APIError.rateLimitExceeded {
    // Show rate limit message, suggest retry later
} catch APIError.networkError(let error) {
    // Handle network issues
} catch {
    // Handle other errors
}
```

## Best Practices

### 1. Rate Limiting
Gemini API has rate limits. Avoid making too many requests in quick succession.

```swift
// Debounce scheduling requests
private var schedulingTask: Task<Void, Never>?

func scheduleWithDebounce() {
    schedulingTask?.cancel()
    schedulingTask = Task {
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 second
        await coordinator.scheduleTasks(...)
    }
}
```

### 2. Offline Handling
Always provide a fallback when API is unavailable:

```swift
do {
    let response = try await service.scheduleTasks(...)
} catch {
    // Fall back to local scheduling algorithm
    let localSchedule = simpleLocalScheduler.schedule(tasks)
}
```

### 3. Caching
Cache scheduling results to avoid redundant API calls:

```swift
private var scheduleCache: [String: SchedulerResponse] = [:]

func scheduleTasks(...) async {
    let cacheKey = generateCacheKey(tasks, availableSlots)
    
    if let cached = scheduleCache[cacheKey] {
        coordinator.lastResponse = cached
        return
    }
    
    await coordinator.scheduleTasks(...)
    
    if let response = coordinator.lastResponse {
        scheduleCache[cacheKey] = response
    }
}
```

### 4. Testing
Always use mock service in tests:

```swift
@Test("Schedule tasks successfully")
func testScheduling() async throws {
    let coordinator = SchedulerCoordinator.mock()
    
    await coordinator.scheduleTasks(
        tasks: sampleTasks,
        availableSlots: sampleSlots,
        constraints: defaultConstraints
    )
    
    #expect(coordinator.lastError == nil)
    #expect(coordinator.lastResponse?.scheduledSlots.count ?? 0 > 0)
}
```

## Customization

### Custom Scheduling Prompt
Modify the prompt in `GeminiSchedulerService.buildSchedulingPrompt()` to customize AI behavior:

```swift
private func buildSchedulingPrompt(from request: SchedulerRequest) throws -> String {
    // Add custom instructions
    return """
    You are an intelligent task scheduler...
    
    Additional rule: Always schedule high-priority tasks in the morning.
    Additional rule: Leave 10 minutes between each task.
    
    \(requestJSON)
    """
}
```

### Custom Model
Use a different Gemini model by changing `APIConfiguration.modelName`:

```swift
static let modelName = "gemini-1.5-pro" // or other available models
```

## Troubleshooting

### "API key is missing"
- Verify API key is set in Info.plist or environment variable
- Check for typos in the key name

### "Rate limit exceeded"
- Wait a few minutes before retrying
- Implement request batching
- Consider caching results

### "Invalid response"
- Gemini may include extra text - extraction logic handles this
- Check Gemini API status at [Google Cloud Status](https://status.cloud.google.com/)

### "Server error"
- Check API endpoint URL
- Verify API key is valid
- Check request payload format

## Future Enhancements

- [ ] Add support for batch scheduling
- [ ] Implement intelligent retry with exponential backoff
- [ ] Add response validation and sanitization
- [ ] Support for multiple AI models (fallback chain)
- [ ] Streaming responses for real-time updates
- [ ] Analytics and usage tracking
- [ ] Response caching with TTL
- [ ] Support for custom scheduling algorithms as fallback

## Resources

- [Gemini API Documentation](https://ai.google.dev/docs)
- [Google AI Studio](https://makersuite.google.com/)
- [SwiftData Documentation](https://developer.apple.com/documentation/swiftdata)
- [Swift Concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)
