//
//  TaskItem.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import Foundation
import SwiftData

/// SwiftData model for local persistence of tasks
@Model
final class TaskItem {
    @Attribute(.unique) var id: UUID
    var title: String
    var details: String?
    var durationMinutes: Int
    var priority: Int // 1 (Low) - 5 (High)
    
    // Final Schedule Data
    var scheduledStart: Date?
    var scheduledEnd: Date?
    var isFixed: Bool // Task originated from a fixed time slot
    var isCompleted: Bool
    var recurrence: String? // e.g., "Mon,Wed,Fri"
    
    // Timestamps
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        details: String? = nil,
        durationMinutes: Int,
        priority: Int = 3,
        scheduledStart: Date? = nil,
        scheduledEnd: Date? = nil,
        isFixed: Bool = false,
        isCompleted: Bool = false,
        recurrence: String? = nil
    ) {
        self.id = id
        self.title = title
        self.details = details
        self.durationMinutes = durationMinutes
        self.priority = priority
        self.scheduledStart = scheduledStart
        self.scheduledEnd = scheduledEnd
        self.isFixed = isFixed
        self.isCompleted = isCompleted
        self.recurrence = recurrence
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Conversion Extensions
extension TaskItem {
    /// Convert to TaskDTO for API communication
    func toDTO() -> TaskDTO {
        let fixedInterval: DateInterval? = {
            guard let start = scheduledStart, let end = scheduledEnd, isFixed else {
                return nil
            }
            return DateInterval(start: start, end: end)
        }()

        return TaskDTO(
            id: id,
            title: title,
            details: details,
            durationMinutes: durationMinutes,
            priority: priority,
            fixedTimeSlot: fixedInterval,
            recurrence: recurrence
        )
    }
    
    /// Apply scheduled slot information
    func applyScheduledSlot(_ slot: ScheduledSlot) {
        self.scheduledStart = slot.scheduledStart
        self.scheduledEnd = slot.scheduledEnd
        self.updatedAt = Date()
    }
}

extension TaskDTO {
    /// Convert to TaskItem for local persistence
    func toTaskItem(isFixed: Bool = false) -> TaskItem {
        return TaskItem(
            id: id,
            title: title,
            durationMinutes: durationMinutes,
            priority: priority,
            scheduledStart: fixedTimeSlot?.start,
            scheduledEnd: fixedTimeSlot?.end,
            isFixed: isFixed,
            recurrence: recurrence
        )
    }
}
