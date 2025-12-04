# **AI Day Scheduler**

## **📅 Project Overview**

The **AI Day Scheduler** is an intelligent, offline-first iOS application designed to generate optimized daily and weekly schedules from natural language input. It utilizes Google's Gemini API to interpret complex requests, apply scheduling constraints, and autonomously fit flexible tasks around fixed commitments.  
This project is built using modern Apple frameworks to ensure a private, high-performance, and native user experience.

### **Core Philosophy**

* **Local-First:** All user data (schedules, context) is stored securely on the device using SwiftData.  
* **Human-in-the-Loop:** The AI proposes a plan, and the user must review and confirm the parsed tasks before the final schedule is generated.  
* **Context Aware:** Scheduling is based on persistent user habits (sleep, work hours) defined during onboarding.

## **🛠️ Tech Stack & Architecture**

| Component | Technology | Role |
| :---- | :---- | :---- |
| **Language** | Swift 6 | Primary development language. |
| **UI Framework** | SwiftUI | Declarative, reactive user interface development. |
| **Database** | SwiftData | Local, native persistence for all models. |
| **AI Engine** | Google Generative AI SDK (Gemini 2.5 Flash) | Natural language parsing and schedule optimization (solving). |
| **Architecture** | MVVM | Separates View logic from Business/Data logic (ViewModel/Repository). |
| **Networking** | Custom APIService (Stateless) | Handles secured, direct calls to the Gemini API. |

## **🚀 AI Scheduling Workflow**

The scheduling process relies on a two-step API call to the Gemini model to ensure robust parsing and logical placement of tasks.

Shutterstock

### **1\. Parsing (AI Step 1\)**

**Goal:** Convert unstructured user text into structured data objects (TaskDTO).

| Input | Output | Model |
| :---- | :---- | :---- |
| Raw Text \+ Current Date | JSON array of TaskDTO structs | Gemini 2.5 Flash (JSON Mode) |

**Key Instruction:** The system instruction guides the model to strictly output valid JSON, distinguishing between tasks with fixed times (e.g., "meeting at 3 pm") and flexible durations (e.g., "study for 2 hours").

### **2\. Optimization (AI Step 2\)**

**Goal:** Take the confirmed list of tasks and the user's fixed constraints, and return a finalized time-slot assignment.

| Input | Output | Model |
| :---- | :---- | :---- |
| UserContext \+ \[TaskDTO\] list \+ Existing Schedule | JSON array of ScheduledSlot objects | Gemini 2.5 Flash (JSON Mode) |

**Key Constraints:** The prompt explicitly instructs the model to avoid scheduling during sleep/work blocks and to prioritize higher-priority tasks when allocating free time.

## **💾 Data Models (The Two-Model Strategy)**

To maintain the separation of concerns and avoid complex Codable implementations on SwiftData models, we use distinct structs for API communication and classes for local persistence.

### **1\. Data Transfer Objects (DTOs)**

*Used for JSON communication with the Gemini API.*  
// TaskDTO: Used to pass task information to and from the AI.  
struct TaskDTO: Codable, Identifiable {  
    let id: UUID  
    var title: String  
    var durationMinutes: Int  
    var priority: Int // 1 (Low) \- 5 (High)  
    var fixedTimeSlot: DateInterval? // Null if flexible  
    var recurrence: String? // "Mon,Wed,Fri"  
}

// ScheduledSlot: The final output structure from the AI solver.  
struct ScheduledSlot: Codable {  
    let taskId: UUID  
    let scheduledStart: Date // ISO8601 formatted in JSON  
    let scheduledEnd: Date  
}

### **2\. Persistent Models (SwiftData)**

*Saved locally on the device.*  
import SwiftData

@Model  
class TaskItem {  
    @Attribute(.unique) var id: UUID  
    var title: String  
    var details: String?  
    var durationMinutes: Int  
    var priority: Int  
      
    // Final Schedule Data  
    var scheduledStart: Date?  
    var scheduledEnd: Date?  
    var isFixed: Bool // Task originated from a fixed time slot  
    var isCompleted: Bool  
      
    // Relationships  
    var category: Category? // Not defined here, but referenced in TDD  
}

@Model  
class UserContext {  
    var wakeTime: Date  
    var bedTime: Date  
    var workBlocks: \[WorkBlock\] // Defines immutable fixed blocks  
}

## **⚙️ Development Setup**

### **Dependencies**

Ensure the following are included in your Xcode project via Swift Package Manager:

1. **GoogleGenerativeAI** SDK.  
2. (Standard) **SwiftData** (Included in Swift 6).

### **API Key Management**

The project uses a secure method to access the Gemini API key:

1. **Create Secrets.plist:** Create a new Property List file in your project root named Secrets.plist.  
2. **Add Key:** Add a key named GEMINI\_API\_KEY and set its value to your actual Gemini API key.  
3. **Git Ignore:** Ensure Secrets.plist is added to your .gitignore file to prevent accidental commitment of credentials.

The APIService will retrieve this key securely at runtime.

### **Local Development Environment**

1. **SwiftData Container:** The main application structure must initialize the modelContainer with all necessary models (TaskItem, UserContext, etc.) at startup.  
2. **Onboarding:** Run the OnboardingView on first launch to ensure a UserContext object exists before any scheduling logic is executed.