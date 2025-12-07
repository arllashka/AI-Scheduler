//
//  TemporalDateCalculator.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 07.12.2025.
//

import Foundation

/// Calculates actual dates from temporal constraints
struct TemporalDateCalculator {

    private let calendar = Calendar.current

    /// Calculate start and end dates from temporal constraints
    /// Returns (startDate, endDate) tuple
    func calculateDates(from constraints: TemporalConstraints) -> (start: Date?, end: Date?) {
        // First try to parse ISO8601 dates if provided
        if let startDateString = constraints.startDate,
           let endDateString = constraints.endDate {
            let formatter = ISO8601DateFormatter()
            if let start = formatter.date(from: startDateString),
               let end = formatter.date(from: endDateString) {
                return (start, end)
            }
        }

        // Fallback: Calculate from explanation text
        if let explanation = constraints.explanation?.lowercased() {
            return calculateFromExplanation(explanation, constraints: constraints)
        }

        return (nil, nil)
    }

    /// Calculate dates from natural language explanation
    private func calculateFromExplanation(_ explanation: String, constraints: TemporalConstraints) -> (start: Date?, end: Date?) {
        let now = Date()

        // "next weekend"
        if explanation.contains("next weekend") {
            return calculateNextWeekend()
        }

        // "this weekend"
        if explanation.contains("this weekend") || explanation.contains("weekend") {
            return calculateThisWeekend()
        }

        // "next week"
        if explanation.contains("next week") {
            return calculateNextWeek()
        }

        // "this week"
        if explanation.contains("this week") {
            return calculateThisWeek()
        }

        // "tomorrow"
        if explanation.contains("tomorrow") {
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: now)!
            return (startOfDay(tomorrow), endOfDay(tomorrow))
        }

        // "today"
        if explanation.contains("today") {
            return (startOfDay(now), endOfDay(now))
        }

        // If we have allowed days of week, calculate next occurrence
        if let allowedDays = constraints.allowedDaysOfWeek, !allowedDays.isEmpty {
            if let nextDate = findNextAllowedDay(from: now, allowedDays: allowedDays) {
                // If it's a weekend constraint, give the whole weekend
                if allowedDays.contains("Saturday") && allowedDays.contains("Sunday") {
                    return (startOfDay(nextDate), endOfDay(calendar.date(byAdding: .day, value: 1, to: nextDate)!))
                }
                return (startOfDay(nextDate), endOfDay(nextDate))
            }
        }

        return (nil, nil)
    }

    /// Calculate next weekend (Saturday-Sunday)
    private func calculateNextWeekend() -> (start: Date, end: Date) {
        let now = Date()
        let currentWeekday = calendar.component(.weekday, from: now)

        // If today is Sunday (1) or Monday (2) through Friday (6), get next Saturday
        let daysUntilSaturday = currentWeekday == 1 ? 6 : (7 - currentWeekday + 7) % 7
        let nextSaturday = calendar.date(byAdding: .day, value: daysUntilSaturday == 0 ? 7 : daysUntilSaturday, to: now)!
        let nextSunday = calendar.date(byAdding: .day, value: 1, to: nextSaturday)!

        return (startOfDay(nextSaturday), endOfDay(nextSunday))
    }

    /// Calculate this weekend (Saturday-Sunday)
    private func calculateThisWeekend() -> (start: Date, end: Date) {
        let now = Date()
        let currentWeekday = calendar.component(.weekday, from: now)

        if currentWeekday == 7 { // Saturday
            let sunday = calendar.date(byAdding: .day, value: 1, to: now)!
            return (startOfDay(now), endOfDay(sunday))
        } else if currentWeekday == 1 { // Sunday
            return (startOfDay(now), endOfDay(now))
        } else {
            // Before weekend, get upcoming Saturday-Sunday
            let daysUntilSaturday = 7 - currentWeekday
            let saturday = calendar.date(byAdding: .day, value: daysUntilSaturday, to: now)!
            let sunday = calendar.date(byAdding: .day, value: 1, to: saturday)!
            return (startOfDay(saturday), endOfDay(sunday))
        }
    }

    /// Calculate next week (Monday-Sunday)
    private func calculateNextWeek() -> (start: Date, end: Date) {
        let now = Date()
        let currentWeekday = calendar.component(.weekday, from: now)

        // Days until next Monday (weekday 2)
        let daysUntilMonday = currentWeekday == 1 ? 1 : (9 - currentWeekday)
        let nextMonday = calendar.date(byAdding: .day, value: daysUntilMonday, to: now)!
        let nextSunday = calendar.date(byAdding: .day, value: 6, to: nextMonday)!

        return (startOfDay(nextMonday), endOfDay(nextSunday))
    }

    /// Calculate this week (remaining days)
    private func calculateThisWeek() -> (start: Date, end: Date) {
        let now = Date()
        let currentWeekday = calendar.component(.weekday, from: now)

        // End of week is Sunday
        let daysUntilSunday = currentWeekday == 1 ? 0 : (8 - currentWeekday)
        let sunday = calendar.date(byAdding: .day, value: daysUntilSunday, to: now)!

        return (startOfDay(now), endOfDay(sunday))
    }

    /// Find next occurrence of allowed day
    private func findNextAllowedDay(from date: Date, allowedDays: [String]) -> Date? {
        let dayNameToWeekday: [String: Int] = [
            "Sunday": 1, "Monday": 2, "Tuesday": 3, "Wednesday": 4,
            "Thursday": 5, "Friday": 6, "Saturday": 7
        ]

        let allowedWeekdays = allowedDays.compactMap { dayNameToWeekday[$0] }
        guard !allowedWeekdays.isEmpty else { return nil }

        // Check next 7 days to find an allowed day
        for offset in 0...6 {
            if let nextDate = calendar.date(byAdding: .day, value: offset, to: date) {
                let weekday = calendar.component(.weekday, from: nextDate)
                if allowedWeekdays.contains(weekday) {
                    return nextDate
                }
            }
        }

        return nil
    }

    /// Get start of day (00:00:00)
    private func startOfDay(_ date: Date) -> Date {
        return calendar.startOfDay(for: date)
    }

    /// Get end of day (23:59:59)
    private func endOfDay(_ date: Date) -> Date {
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = 23
        components.minute = 59
        components.second = 59
        return calendar.date(from: components) ?? date
    }
}
