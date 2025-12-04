//
//  AvailableSlotGenerator.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import Foundation

/// Utility to generate available time slots based on work hours and constraints
struct AvailableSlotGenerator {
    
    /// Generate available slots for the next N days
    /// - Parameters:
    ///   - days: Number of days to generate slots for
    ///   - workHoursStart: Start of work hours (e.g., "09:00")
    ///   - workHoursEnd: End of work hours (e.g., "17:00")
    ///   - existingTasks: Tasks that are already scheduled (to avoid conflicts)
    /// - Returns: Array of available time slots
    static func generateSlots(
        forNextDays days: Int = 7,
        workHoursStart: String = "09:00",
        workHoursEnd: String = "17:00",
        existingTasks: [TaskItem] = []
    ) -> [AvailableSlot] {
        var slots: [AvailableSlot] = []
        let calendar = Calendar.current
        let now = Date()
        
        for dayOffset in 0..<days {
            guard let targetDate = calendar.date(byAdding: .day, value: dayOffset, to: now) else {
                continue
            }
            
            // Parse work hours
            guard let (startHour, startMinute) = parseTime(workHoursStart),
                  let (endHour, endMinute) = parseTime(workHoursEnd) else {
                continue
            }
            
            // Create start and end dates for this day
            var components = calendar.dateComponents([.year, .month, .day], from: targetDate)
            components.hour = startHour
            components.minute = startMinute
            components.second = 0
            
            guard let dayStart = calendar.date(from: components) else {
                continue
            }
            
            components.hour = endHour
            components.minute = endMinute
            
            guard let dayEnd = calendar.date(from: components) else {
                continue
            }
            
            // If the start time is in the past for today, adjust to now
            let effectiveStart: Date
            if dayOffset == 0 && dayStart < now {
                effectiveStart = now
            } else {
                effectiveStart = dayStart
            }
            
            // Get scheduled tasks for this day
            let scheduledTasksForDay = existingTasks.filter { task in
                guard let scheduledStart = task.scheduledStart else { return false }
                return calendar.isDate(scheduledStart, inSameDayAs: targetDate)
            }.sorted { ($0.scheduledStart ?? Date.distantPast) < ($1.scheduledStart ?? Date.distantPast) }
            
            // Split the day into available slots around scheduled tasks
            var currentTime = effectiveStart
            
            for task in scheduledTasksForDay {
                guard let taskStart = task.scheduledStart,
                      let taskEnd = task.scheduledEnd else {
                    continue
                }
                
                // Add slot before this task if there's time
                if currentTime < taskStart {
                    let slot = AvailableSlot(start: currentTime, end: taskStart)
                    // Only add slots with at least 15 minutes
                    if slot.durationMinutes >= 15 {
                        slots.append(slot)
                    }
                }
                
                // Move current time to after this task
                currentTime = max(currentTime, taskEnd)
            }
            
            // Add remaining slot for the day
            if currentTime < dayEnd {
                let slot = AvailableSlot(start: currentTime, end: dayEnd)
                if slot.durationMinutes >= 15 {
                    slots.append(slot)
                }
            }
        }
        
        return slots
    }
    
    /// Parse time string "HH:mm" into hour and minute components
    private static func parseTime(_ timeString: String) -> (hour: Int, minute: Int)? {
        let components = timeString.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]),
              hour >= 0, hour < 24,
              minute >= 0, minute < 60 else {
            return nil
        }
        return (hour, minute)
    }
}
