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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Try to decode as UUID, or if it's not a valid UUID, generate a new one
        if let idString = try? container.decode(String.self, forKey: .id),
           let uuid = UUID(uuidString: idString) {
            id = uuid
        } else {
            // If it's not a UUID string, fallback: generate a new UUID
            id = UUID()
        }
        
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
}
