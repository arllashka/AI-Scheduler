//
//  TaskDTO.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import Foundation

/// Data Transfer Object for task information passed to/from the Gemini API
/// Used for JSON communication with the AI model
struct TaskDTO: Codable, Identifiable {
    let id: UUID
    var title: String
    var durationMinutes: Int
    var priority: Int // 1 (Low) - 5 (High)
    var fixedTimeSlot: DateInterval? // Null if flexible
    var recurrence: String? // e.g., "Mon,Wed,Fri"
    
    init(
        id: UUID = UUID(),
        title: String,
        durationMinutes: Int,
        priority: Int = 3,
        fixedTimeSlot: DateInterval? = nil,
        recurrence: String? = nil
    ) {
        self.id = id
        self.title = title
        self.durationMinutes = durationMinutes
        self.priority = priority
        self.fixedTimeSlot = fixedTimeSlot
        self.recurrence = recurrence
    }
}

extension TaskDTO {
    /// Custom coding keys for JSON serialization
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case durationMinutes
        case priority
        case fixedTimeSlot
        case recurrence
    }
    
    /// Custom decoder to handle date interval encoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        durationMinutes = try container.decode(Int.self, forKey: .durationMinutes)
        priority = try container.decode(Int.self, forKey: .priority)
        recurrence = try container.decodeIfPresent(String.self, forKey: .recurrence)
        
        // Handle DateInterval as start/end ISO8601 strings
        if let startString = try? container.decode(String.self, forKey: .fixedTimeSlot),
           let endString = try? container.decode(String.self, forKey: .fixedTimeSlot) {
            let formatter = ISO8601DateFormatter()
            if let start = formatter.date(from: startString),
               let end = formatter.date(from: endString) {
                fixedTimeSlot = DateInterval(start: start, end: end)
            } else {
                fixedTimeSlot = nil
            }
        } else {
            fixedTimeSlot = nil
        }
    }
    
    /// Custom encoder for date interval serialization
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(durationMinutes, forKey: .durationMinutes)
        try container.encode(priority, forKey: .priority)
        try container.encodeIfPresent(recurrence, forKey: .recurrence)
        
        // Encode DateInterval as ISO8601 strings if present
        if let interval = fixedTimeSlot {
            let formatter = ISO8601DateFormatter()
            try container.encode(formatter.string(from: interval.start), forKey: .fixedTimeSlot)
        }
    }
}
