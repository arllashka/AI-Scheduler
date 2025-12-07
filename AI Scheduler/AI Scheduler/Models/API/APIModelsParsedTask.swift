//
//  ParsedTask.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 07.12.2025.
//

import Foundation

/// Represents task attributes extracted from natural language input
struct ParsedTaskAttributes: Codable {
    /// The main task title/name extracted from the prompt
    let title: String

    /// Optional detailed description extracted from the prompt
    let description: String?

    /// Estimated duration in minutes (inferred from context or default)
    let durationMinutes: Int

    /// Task priority (1-10 scale, inferred from urgency words or default to 5)
    let priority: Int

    /// Recurrence pattern information
    let recurrence: RecurrencePattern?

    /// Temporal constraints (when the task should be scheduled)
    let temporalConstraints: TemporalConstraints?

    /// Preferred time of day if mentioned (e.g., "morning", "noon", "evening")
    let preferredTimeOfDay: String?
}

/// Detailed recurrence pattern information
struct RecurrencePattern: Codable {
    /// Type of recurrence (e.g., "daily", "weekly", "custom")
    let type: String

    /// How many times to repeat (e.g., "3 times a week" = 3)
    let frequency: Int?

    /// Specific days if mentioned (e.g., ["Monday", "Wednesday", "Friday"])
    let specificDays: [String]?

    /// Total number of occurrences (e.g., "3 times next week" = 3 total instances)
    let totalOccurrences: Int?

    /// Human-readable explanation of the pattern
    let explanation: String
}

/// Temporal constraints for when a task should be scheduled
struct TemporalConstraints: Codable {
    /// Start date for the task window (e.g., "next week" starts on Monday)
    let startDate: String? // ISO8601 date

    /// End date for the task window (e.g., "next week" ends on Sunday)
    let endDate: String? // ISO8601 date

    /// Days of week constraints (e.g., "weekend" = ["Saturday", "Sunday"])
    let allowedDaysOfWeek: [String]?

    /// Preferred time range if specified (e.g., "at noon" = "12:00")
    let preferredTime: String? // HH:mm format

    /// Time range constraints (e.g., "morning" = "06:00-12:00")
    let timeRange: TimeRange?

    /// Human-readable explanation
    let explanation: String?
}

/// Time range within a day
struct TimeRange: Codable {
    let startTime: String // HH:mm format
    let endTime: String   // HH:mm format
}

/// Response from the NLP parser
struct NLPParserResponse: Codable {
    /// Array of parsed tasks (could be multiple from one prompt)
    let tasks: [ParsedTaskAttributes]

    /// Metadata about the parsing
    let metadata: NLPMetadata
}

/// Metadata about the NLP parsing operation
struct NLPMetadata: Codable {
    /// Total number of tasks identified in the prompt
    let tasksIdentified: Int

    /// Confidence level (0.0 - 1.0)
    let confidence: Double

    /// Any ambiguities or clarifications needed
    let clarifications: [String]?

    /// The AI model used for parsing
    let aiModel: String

    /// Timestamp of parsing
    let timestamp: Date
}
