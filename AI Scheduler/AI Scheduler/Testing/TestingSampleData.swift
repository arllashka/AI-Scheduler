//
//  SampleData.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import Foundation

/// Sample data for testing and previews
enum SampleData {
    
    // MARK: - Sample Tasks
    
    static let sampleTasks: [TaskItem] = [
        TaskItem(
            title: "Team Meeting",
            details: "Weekly sync with the development team",
            durationMinutes: 60,
            priority: 5,
            scheduledStart: Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date()), scheduledEnd: Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: Date()), isFixed: true
        ),
        TaskItem(
            title: "Code Review",
            details: "Review pull requests from team members",
            durationMinutes: 45,
            priority: 4
        ),
        TaskItem(
            title: "Write Documentation",
            details: "Update API documentation",
            durationMinutes: 90,
            priority: 3
        ),
        TaskItem(
            title: "Lunch Break",
            details: "Time to eat and relax",
            durationMinutes: 60,
            priority: 5,
            scheduledStart: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date()), scheduledEnd: Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Date()), isFixed: true
        ),
        TaskItem(
            title: "Bug Fixes",
            details: "Fix reported bugs in the issue tracker",
            durationMinutes: 120,
            priority: 4
        ),
        TaskItem(
            title: "Email Responses",
            details: "Catch up on email",
            durationMinutes: 30,
            priority: 2
        ),
        TaskItem(
            title: "Learning Session",
            details: "Study new SwiftUI features",
            durationMinutes: 60,
            priority: 3
        ),
        TaskItem(
            title: "Project Planning",
            details: "Plan next sprint tasks",
            durationMinutes: 45,
            priority: 4
        ),
    ]
    
    static let sampleTaskDTOs: [TaskDTO] = sampleTasks.map { $0.toDTO() }
    
    // MARK: - Sample Available Slots
    
    static let sampleAvailableSlots: [AvailableSlot] = {
        let calendar = Calendar.current
        let today = Date()
        
        return [
            // Morning slot: 9 AM - 12 PM
            AvailableSlot(
                start: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: today)!,
                end: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: today)!
            ),
            // Afternoon slot: 1 PM - 5 PM
            AvailableSlot(
                start: calendar.date(bySettingHour: 13, minute: 0, second: 0, of: today)!,
                end: calendar.date(bySettingHour: 17, minute: 0, second: 0, of: today)!
            ),
        ]
    }()
    
    static func availableSlots(for date: Date) -> [AvailableSlot] {
        let calendar = Calendar.current
        
        return [
            // Morning slot: 9 AM - 12 PM
            AvailableSlot(
                start: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: date)!,
                end: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: date)!
            ),
            // Afternoon slot: 1 PM - 5 PM
            AvailableSlot(
                start: calendar.date(bySettingHour: 13, minute: 0, second: 0, of: date)!,
                end: calendar.date(bySettingHour: 17, minute: 0, second: 0, of: date)!
            ),
        ]
    }
    
    // MARK: - Sample Time Constraints
    
    static let defaultConstraints = TimeConstraints(
        workHoursStart: "09:00",
        workHoursEnd: "17:00",
        breakDuration: 60,
        maxConsecutiveHours: 3,
        timezone: TimeZone.current.identifier
    )
    
    static let relaxedConstraints = TimeConstraints(
        workHoursStart: "08:00",
        workHoursEnd: "20:00",
        breakDuration: 30,
        maxConsecutiveHours: 4,
        timezone: TimeZone.current.identifier
    )
    
    static let strictConstraints = TimeConstraints(
        workHoursStart: "09:00",
        workHoursEnd: "17:00",
        breakDuration: 90,
        maxConsecutiveHours: 2,
        timezone: TimeZone.current.identifier
    )
    
    // MARK: - Sample Scheduled Slots
    
    static let sampleScheduledSlots: [ScheduledSlot] = {
        let calendar = Calendar.current
        let today = Date()
        
        guard let task1 = sampleTasks.first?.id,
              let task2 = sampleTasks.dropFirst().first?.id else {
            return []
        }
        
        return [
            ScheduledSlot(
                taskId: task1,
                scheduledStart: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: today)!,
                scheduledEnd: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: today)!
            ),
            ScheduledSlot(
                taskId: task2,
                scheduledStart: calendar.date(bySettingHour: 10, minute: 15, second: 0, of: today)!,
                scheduledEnd: calendar.date(bySettingHour: 11, minute: 0, second: 0, of: today)!
            ),
        ]
    }()
    
    // MARK: - Sample Response
    
    static let sampleResponse = SchedulerResponse(
        scheduledSlots: sampleScheduledSlots,
        unscheduledTasks: [
            UnscheduledTask(
                taskId: UUID(),
                reason: "Not enough available time in the schedule"
            )
        ],
        metadata: SchedulerMetadata(
            totalTasks: sampleTasks.count,
            scheduledCount: sampleScheduledSlots.count,
            unscheduledCount: 1,
            processingTime: 1.2,
            aiModel: "gemini-2.0-flash-exp"
        )
    )
    
    // MARK: - Helper Functions
    
    /// Create a task with specific date and time
    static func task(
        title: String,
        durationMinutes: Int,
        priority: Int = 3,
        fixedAt date: Date? = nil
    ) -> TaskItem {
        let task = TaskItem(
            title: title,
            durationMinutes: durationMinutes,
            priority: priority
        )
        
        if let date = date {
            task.scheduledStart = date
            task.scheduledEnd = date.addingTimeInterval(TimeInterval(durationMinutes * 60))
            task.isFixed = true
        }
        
        return task
    }
    
    /// Create an available slot for a specific date and time range
    static func availableSlot(
        on date: Date,
        startHour: Int,
        startMinute: Int = 0,
        endHour: Int,
        endMinute: Int = 0
    ) -> AvailableSlot {
        let calendar = Calendar.current
        let start = calendar.date(bySettingHour: startHour, minute: startMinute, second: 0, of: date)!
        let end = calendar.date(bySettingHour: endHour, minute: endMinute, second: 0, of: date)!
        
        return AvailableSlot(start: start, end: end)
    }
    
    /// Generate a week's worth of available slots
    static func weekOfAvailableSlots(startingFrom date: Date = Date()) -> [AvailableSlot] {
        let calendar = Calendar.current
        var slots: [AvailableSlot] = []
        
        for dayOffset in 0..<7 {
            guard let currentDay = calendar.date(byAdding: .day, value: dayOffset, to: date) else {
                continue
            }
            
            // Skip weekends
            let weekday = calendar.component(.weekday, from: currentDay)
            if weekday == 1 || weekday == 7 { // Sunday or Saturday
                continue
            }
            
            slots.append(contentsOf: availableSlots(for: currentDay))
        }
        
        return slots
    }
    
    /// Generate tasks for a typical work week
    static func weeklyTasks() -> [TaskItem] {
        return [
            task(title: "Monday Morning Standup", durationMinutes: 15, priority: 5),
            task(title: "Feature Development", durationMinutes: 180, priority: 4),
            task(title: "Code Review", durationMinutes: 60, priority: 4),
            task(title: "Bug Triage", durationMinutes: 45, priority: 3),
            task(title: "Documentation", durationMinutes: 90, priority: 3),
            task(title: "Team Meeting", durationMinutes: 60, priority: 5),
            task(title: "1-on-1 with Manager", durationMinutes: 30, priority: 4),
            task(title: "Design Review", durationMinutes: 45, priority: 4),
            task(title: "Testing", durationMinutes: 120, priority: 4),
            task(title: "Learning/Research", durationMinutes: 60, priority: 2),
            task(title: "Email and Admin", durationMinutes: 30, priority: 2),
            task(title: "Sprint Planning", durationMinutes: 90, priority: 5),
        ]
    }
}

// MARK: - Preview Helpers

#if DEBUG
extension SampleData {
    /// Create a mock coordinator with sample data
    static func mockCoordinator() -> SchedulerCoordinator {
        let coordinator = SchedulerCoordinator.mock()
        coordinator.lastResponse = sampleResponse
        return coordinator
    }
    
    /// Create a mock coordinator in loading state
    static func loadingCoordinator() -> SchedulerCoordinator {
        let coordinator = SchedulerCoordinator.mock()
        coordinator.isLoading = true
        return coordinator
    }
    
    /// Create a mock coordinator with an error
    static func errorCoordinator() -> SchedulerCoordinator {
        let coordinator = SchedulerCoordinator.mock()
        coordinator.lastError = .apiKeyMissing
        return coordinator
    }
}
#endif
