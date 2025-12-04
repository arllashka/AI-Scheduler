//
//  UserContext.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import Foundation
import SwiftData

/// SwiftData model representing persistent user habits and constraints
/// Collected during onboarding and used for scheduling logic
@Model
final class UserContext {
    var wakeTime: Date
    var bedTime: Date
    var workBlocks: [WorkBlock] // Defines immutable fixed blocks
    var createdAt: Date
    var updatedAt: Date
    
    init(
        wakeTime: Date,
        bedTime: Date,
        workBlocks: [WorkBlock] = []
    ) {
        self.wakeTime = wakeTime
        self.bedTime = bedTime
        self.workBlocks = workBlocks
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

/// Represents a fixed work/commitment block in the user's schedule
struct WorkBlock: Codable {
    var id: UUID
    var title: String
    var startTime: Date // Time of day (hour/minute)
    var endTime: Date // Time of day (hour/minute)
    var daysOfWeek: [Int] // 1 = Sunday, 2 = Monday, etc.
    
    init(
        id: UUID = UUID(),
        title: String,
        startTime: Date,
        endTime: Date,
        daysOfWeek: [Int]
    ) {
        self.id = id
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        self.daysOfWeek = daysOfWeek
    }
    
    /// Check if this work block applies to a specific date
    func appliesTo(date: Date) -> Bool {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        return daysOfWeek.contains(weekday)
    }
    
    /// Get the actual date interval for this work block on a specific date
    func dateInterval(for date: Date) -> DateInterval? {
        guard appliesTo(date: date) else { return nil }
        
        let calendar = Calendar.current
        
        // Extract time components from startTime and endTime
        let startComponents = calendar.dateComponents([.hour, .minute], from: startTime)
        let endComponents = calendar.dateComponents([.hour, .minute], from: endTime)
        
        // Combine date with time components
        guard let start = calendar.date(bySettingHour: startComponents.hour ?? 0,
                                       minute: startComponents.minute ?? 0,
                                       second: 0,
                                       of: date),
              let end = calendar.date(bySettingHour: endComponents.hour ?? 0,
                                     minute: endComponents.minute ?? 0,
                                     second: 0,
                                     of: date) else {
            return nil
        }
        
        return DateInterval(start: start, end: end)
    }
}

// MARK: - Convenience Extensions
extension UserContext {
    /// Get all unavailable time blocks for a specific date
    func unavailableTimeBlocks(for date: Date) -> [DateInterval] {
        var blocks: [DateInterval] = []
        
        let calendar = Calendar.current
        let dayStart = calendar.startOfDay(for: date)
        // Add sleep time before wake time
        if let wakeDateTime = calendar.date(bySettingHour: calendar.component(.hour, from: wakeTime),
                                           minute: calendar.component(.minute, from: wakeTime),
                                           second: 0,
                                           of: date) {
            blocks.append(DateInterval(start: dayStart, end: wakeDateTime))
        }
        
        // Add sleep time after bed time
        if let bedDateTime = calendar.date(bySettingHour: calendar.component(.hour, from: bedTime),
                                          minute: calendar.component(.minute, from: bedTime),
                                          second: 0,
                                          of: date),
           let dayEnd = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: date)) {
            blocks.append(DateInterval(start: bedDateTime, end: dayEnd))
        }
        
        // Add work blocks that apply to this date
        for workBlock in workBlocks {
            if let interval = workBlock.dateInterval(for: date) {
                blocks.append(interval)
            }
        }
        
        return blocks
    }
    
    /// Get available time for scheduling on a specific date
    func availableMinutes(for date: Date) -> Int {
        let calendar = Calendar.current
        
        guard let wakeDateTime = calendar.date(bySettingHour: calendar.component(.hour, from: wakeTime),
                                              minute: calendar.component(.minute, from: wakeTime),
                                              second: 0,
                                              of: date),
              let bedDateTime = calendar.date(bySettingHour: calendar.component(.hour, from: bedTime),
                                             minute: calendar.component(.minute, from: bedTime),
                                             second: 0,
                                             of: date) else {
            return 0
        }
        
        let totalMinutes = Int(bedDateTime.timeIntervalSince(wakeDateTime) / 60)
        
        // Subtract work block minutes
        let workMinutes = workBlocks
            .compactMap { $0.dateInterval(for: date) }
            .reduce(0) { $0 + Int($1.duration / 60) }
        
        return max(0, totalMinutes - workMinutes)
    }
}
