//
//  ScheduledSlot.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import Foundation

/// Final output structure from the AI solver
/// Represents a time slot assignment for a specific task
struct ScheduledSlot: Codable, Identifiable {
    let id: UUID
    let taskId: UUID
    let scheduledStart: Date // ISO8601 formatted in JSON
    let scheduledEnd: Date
    
    init(
        id: UUID = UUID(),
        taskId: UUID,
        scheduledStart: Date,
        scheduledEnd: Date
    ) {
        self.id = id
        self.taskId = taskId
        self.scheduledStart = scheduledStart
        self.scheduledEnd = scheduledEnd
    }
    
    /// Duration of the scheduled slot in minutes
    var durationMinutes: Int {
        let interval = scheduledEnd.timeIntervalSince(scheduledStart)
        return Int(interval / 60)
    }
    
    /// Check if this slot conflicts with another slot
    func conflictsWith(_ other: ScheduledSlot) -> Bool {
        return scheduledStart < other.scheduledEnd && scheduledEnd > other.scheduledStart
    }
}

extension ScheduledSlot {
    /// Custom coding keys for JSON serialization
    enum CodingKeys: String, CodingKey {
        case id
        case taskId
        case scheduledStart
        case scheduledEnd
    }
    
    /// Custom decoder to handle ISO8601 date strings
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        taskId = try container.decode(UUID.self, forKey: .taskId)
        
        // Decode dates from ISO8601 strings
        let formatter = ISO8601DateFormatter()
        
        let startString = try container.decode(String.self, forKey: .scheduledStart)
        guard let start = formatter.date(from: startString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .scheduledStart,
                in: container,
                debugDescription: "Invalid date format"
            )
        }
        scheduledStart = start
        
        let endString = try container.decode(String.self, forKey: .scheduledEnd)
        guard let end = formatter.date(from: endString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .scheduledEnd,
                in: container,
                debugDescription: "Invalid date format"
            )
        }
        scheduledEnd = end
    }
    
    /// Custom encoder to output ISO8601 date strings
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(taskId, forKey: .taskId)
        
        // Encode dates as ISO8601 strings
        let formatter = ISO8601DateFormatter()
        try container.encode(formatter.string(from: scheduledStart), forKey: .scheduledStart)
        try container.encode(formatter.string(from: scheduledEnd), forKey: .scheduledEnd)
    }
}
