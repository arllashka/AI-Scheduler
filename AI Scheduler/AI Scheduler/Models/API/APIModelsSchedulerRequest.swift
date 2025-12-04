//
//  SchedulerRequest.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import Foundation

/// Request payload for the Gemini API scheduler endpoint
struct SchedulerRequest: Codable {
    let tasks: [TaskDTO]
    let availableSlots: [AvailableSlot]
    let timeConstraints: TimeConstraints
    
    init(
        tasks: [TaskDTO],
        availableSlots: [AvailableSlot],
        timeConstraints: TimeConstraints
    ) {
        self.tasks = tasks
        self.availableSlots = availableSlots
        self.timeConstraints = timeConstraints
    }
}

/// Represents an available time slot for scheduling
struct AvailableSlot: Codable {
    let start: Date
    let end: Date
    
    init(start: Date, end: Date) {
        self.start = start
        self.end = end
    }
    
    /// Duration in minutes
    var durationMinutes: Int {
        Int(end.timeIntervalSince(start) / 60)
    }
}

extension AvailableSlot {
    enum CodingKeys: String, CodingKey {
        case start
        case end
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let formatter = ISO8601DateFormatter()
        
        let startString = try container.decode(String.self, forKey: .start)
        guard let decodedStart = formatter.date(from: startString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .start,
                in: container,
                debugDescription: "Invalid date format"
            )
        }
        start = decodedStart
        
        let endString = try container.decode(String.self, forKey: .end)
        guard let decodedEnd = formatter.date(from: endString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .end,
                in: container,
                debugDescription: "Invalid date format"
            )
        }
        end = decodedEnd
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let formatter = ISO8601DateFormatter()
        
        try container.encode(formatter.string(from: start), forKey: .start)
        try container.encode(formatter.string(from: end), forKey: .end)
    }
}

/// Time constraints for scheduling
struct TimeConstraints: Codable {
    let workHoursStart: String // "09:00"
    let workHoursEnd: String   // "17:00"
    let breakDuration: Int     // minutes
    let maxConsecutiveHours: Int
    let timezone: String       // e.g., "America/New_York"
    
    init(
        workHoursStart: String = "09:00",
        workHoursEnd: String = "17:00",
        breakDuration: Int = 60,
        maxConsecutiveHours: Int = 3,
        timezone: String = TimeZone.current.identifier
    ) {
        self.workHoursStart = workHoursStart
        self.workHoursEnd = workHoursEnd
        self.breakDuration = breakDuration
        self.maxConsecutiveHours = maxConsecutiveHours
        self.timezone = timezone
    }
}
