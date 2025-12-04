//
//  SchedulerResponse.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import Foundation

/// Response from the Gemini API scheduler endpoint
struct SchedulerResponse: Codable {
    let scheduledSlots: [ScheduledSlot]
    let unscheduledTasks: [UnscheduledTask]
    let metadata: SchedulerMetadata
    
    init(
        scheduledSlots: [ScheduledSlot],
        unscheduledTasks: [UnscheduledTask] = [],
        metadata: SchedulerMetadata
    ) {
        self.scheduledSlots = scheduledSlots
        self.unscheduledTasks = unscheduledTasks
        self.metadata = metadata
    }
}

/// Tasks that couldn't be scheduled
struct UnscheduledTask: Codable, Identifiable {
    let id: UUID
    let taskId: UUID
    let reason: String
    
    init(id: UUID = UUID(), taskId: UUID, reason: String) {
        self.id = id
        self.taskId = taskId
        self.reason = reason
    }
}

/// Metadata about the scheduling operation
struct SchedulerMetadata: Codable {
    let totalTasks: Int
    let scheduledCount: Int
    let unscheduledCount: Int
    let processingTime: Double // seconds
    let aiModel: String
    let timestamp: Date
    
    init(
        totalTasks: Int,
        scheduledCount: Int,
        unscheduledCount: Int,
        processingTime: Double,
        aiModel: String = "gemini-2.0-flash-exp",
        timestamp: Date = Date()
    ) {
        self.totalTasks = totalTasks
        self.scheduledCount = scheduledCount
        self.unscheduledCount = unscheduledCount
        self.processingTime = processingTime
        self.aiModel = aiModel
        self.timestamp = timestamp
    }
}

extension SchedulerMetadata {
    enum CodingKeys: String, CodingKey {
        case totalTasks
        case scheduledCount
        case unscheduledCount
        case processingTime
        case aiModel
        case timestamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        totalTasks = try container.decode(Int.self, forKey: .totalTasks)
        scheduledCount = try container.decode(Int.self, forKey: .scheduledCount)
        unscheduledCount = try container.decode(Int.self, forKey: .unscheduledCount)
        processingTime = try container.decode(Double.self, forKey: .processingTime)
        aiModel = try container.decode(String.self, forKey: .aiModel)
        
        let timestampString = try container.decode(String.self, forKey: .timestamp)
        let formatter = ISO8601DateFormatter()
        guard let decodedTimestamp = formatter.date(from: timestampString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .timestamp,
                in: container,
                debugDescription: "Invalid date format"
            )
        }
        timestamp = decodedTimestamp
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(totalTasks, forKey: .totalTasks)
        try container.encode(scheduledCount, forKey: .scheduledCount)
        try container.encode(unscheduledCount, forKey: .unscheduledCount)
        try container.encode(processingTime, forKey: .processingTime)
        try container.encode(aiModel, forKey: .aiModel)
        
        let formatter = ISO8601DateFormatter()
        try container.encode(formatter.string(from: timestamp), forKey: .timestamp)
    }
}
