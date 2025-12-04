//
//  SampleTaskGenerator.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import Foundation
import SwiftData
import SwiftUI

/// Helper to generate sample tasks with real dates for testing
struct SampleTaskGenerator {
    
    /// Generates a variety of sample tasks across different dates
    static func generateSampleTasks(context: ModelContext) {
        let calendar = Calendar.current
        let today = Date()
        
        // Clear existing tasks (optional - comment out if you want to keep existing)
        // clearAllTasks(context: context)
        
        // Generate tasks for different dates
        
        // TODAY - 4 tasks
        createTask(
            title: "Morning Standup",
            durationMinutes: 15,
            priority: 6,
            date: today,
            hour: 9,
            minute: 0,
            context: context
        )
        
        createTask(
            title: "Review Pull Requests",
            durationMinutes: 45,
            priority: 7,
            date: today,
            hour: 10,
            minute: 0,
            context: context
        )
        
        createTask(
            title: "Lunch Break",
            durationMinutes: 60,
            priority: 3,
            date: today,
            hour: 12,
            minute: 0,
            context: context
        )
        
        createTask(
            title: "Client Call",
            durationMinutes: 30,
            priority: 8,
            date: today,
            hour: 14,
            minute: 30,
            context: context
        )
        
        // TOMORROW - 5 tasks
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        createTask(
            title: "Gym Session",
            durationMinutes: 60,
            priority: 5,
            date: tomorrow,
            hour: 7,
            minute: 0,
            context: context
        )
        
        createTask(
            title: "Team Planning Meeting",
            durationMinutes: 90,
            priority: 8,
            date: tomorrow,
            hour: 10,
            minute: 0,
            context: context
        )
        
        createTask(
            title: "Code Review Session",
            durationMinutes: 60,
            priority: 7,
            date: tomorrow,
            hour: 13,
            minute: 0,
            context: context
        )
        
        createTask(
            title: "Write Documentation",
            durationMinutes: 90,
            priority: 6,
            date: tomorrow,
            hour: 15,
            minute: 0,
            context: context
        )
        
        createTask(
            title: "Grocery Shopping",
            durationMinutes: 45,
            priority: 4,
            date: tomorrow,
            hour: 18,
            minute: 0,
            context: context
        )
        
        // DAY AFTER TOMORROW - 3 tasks
        let dayAfterTomorrow = calendar.date(byAdding: .day, value: 2, to: today)!
        
        createTask(
            title: "Doctor Appointment",
            durationMinutes: 60,
            priority: 9,
            date: dayAfterTomorrow,
            hour: 9,
            minute: 30,
            context: context
        )
        
        createTask(
            title: "Project Demo",
            durationMinutes: 45,
            priority: 10,
            date: dayAfterTomorrow,
            hour: 14,
            minute: 0,
            context: context
        )
        
        createTask(
            title: "Evening Walk",
            durationMinutes: 30,
            priority: 2,
            date: dayAfterTomorrow,
            hour: 18,
            minute: 30,
            context: context
        )
        
        // NEXT WEEK MONDAY - 4 tasks
        let nextMonday = calendar.date(byAdding: .weekOfYear, value: 1, to: today)!
        let mondayStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: nextMonday))!
        
        createTask(
            title: "Weekly Team Meeting",
            durationMinutes: 60,
            priority: 7,
            date: mondayStart,
            hour: 9,
            minute: 0,
            context: context
        )
        
        createTask(
            title: "Sprint Planning",
            durationMinutes: 120,
            priority: 8,
            date: mondayStart,
            hour: 10,
            minute: 30,
            context: context
        )
        
        createTask(
            title: "1-on-1 with Manager",
            durationMinutes: 30,
            priority: 7,
            date: mondayStart,
            hour: 15,
            minute: 0,
            context: context
        )
        
        createTask(
            title: "Update Roadmap",
            durationMinutes: 45,
            priority: 6,
            date: mondayStart,
            hour: 16,
            minute: 0,
            context: context
        )
        
        // NEXT WEEK WEDNESDAY - 3 tasks
        let nextWednesday = calendar.date(byAdding: .day, value: 2, to: mondayStart)!
        
        createTask(
            title: "Design Review",
            durationMinutes: 90,
            priority: 8,
            date: nextWednesday,
            hour: 10,
            minute: 0,
            context: context
        )
        
        createTask(
            title: "Dentist Appointment",
            durationMinutes: 45,
            priority: 9,
            date: nextWednesday,
            hour: 14,
            minute: 0,
            context: context
        )
        
        createTask(
            title: "Coffee with Friend",
            durationMinutes: 60,
            priority: 4,
            date: nextWednesday,
            hour: 17,
            minute: 0,
            context: context
        )
        
        // NEXT WEEK FRIDAY - 2 tasks
        let nextFriday = calendar.date(byAdding: .day, value: 4, to: mondayStart)!
        
        createTask(
            title: "End of Week Review",
            durationMinutes: 30,
            priority: 6,
            date: nextFriday,
            hour: 16,
            minute: 0,
            context: context
        )
        
        createTask(
            title: "Team Happy Hour",
            durationMinutes: 120,
            priority: 5,
            date: nextFriday,
            hour: 17,
            minute: 30,
            context: context
        )
        
        // RANDOM FUTURE DATE - 2 tasks
        let futureDate = calendar.date(byAdding: .day, value: 15, to: today)!
        
        createTask(
            title: "Conference Day 1",
            durationMinutes: 480,
            priority: 8,
            date: futureDate,
            hour: 9,
            minute: 0,
            context: context
        )
        
        // ANOTHER FUTURE DATE
        let anotherFutureDate = calendar.date(byAdding: .day, value: 20, to: today)!
        
        createTask(
            title: "Quarterly Review",
            durationMinutes: 90,
            priority: 10,
            date: anotherFutureDate,
            hour: 14,
            minute: 0,
            context: context
        )
        
        // UNSCHEDULED TASKS (no date) - 5 tasks
        createUnscheduledTask(
            title: "Research new frameworks",
            durationMinutes: 120,
            priority: 6,
            context: context
        )
        
        createUnscheduledTask(
            title: "Update resume",
            durationMinutes: 60,
            priority: 5,
            context: context
        )
        
        createUnscheduledTask(
            title: "Clean email inbox",
            durationMinutes: 30,
            priority: 4,
            context: context
        )
        
        createUnscheduledTask(
            title: "Learn SwiftUI animations",
            durationMinutes: 90,
            priority: 7,
            context: context
        )
        
        createUnscheduledTask(
            title: "Organize files",
            durationMinutes: 45,
            priority: 3,
            context: context
        )
        
        // Save all changes
        do {
            try context.save()
            print("✅ Successfully generated \(30) sample tasks across multiple dates!")
        } catch {
            print("❌ Error saving sample tasks: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helper Functions
    
    /// Creates a scheduled task with specific date and time
    private static func createTask(
        title: String,
        durationMinutes: Int,
        priority: Int,
        date: Date,
        hour: Int,
        minute: Int,
        isCompleted: Bool = false,
        context: ModelContext
    ) {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = hour
        components.minute = minute
        
        guard let scheduledStart = calendar.date(from: components) else { return }
        let scheduledEnd = scheduledStart.addingTimeInterval(TimeInterval(durationMinutes * 60))
        
        let task = TaskItem(
            title: title,
            details: nil,
            durationMinutes: durationMinutes,
            priority: priority,
            scheduledStart: scheduledStart,
            scheduledEnd: scheduledEnd,
            isFixed: true,
            isCompleted: isCompleted
        )
        
        context.insert(task)
    }
    
    /// Creates an unscheduled task (for AI scheduling)
    private static func createUnscheduledTask(
        title: String,
        durationMinutes: Int,
        priority: Int,
        context: ModelContext
    ) {
        let task = TaskItem(
            title: title,
            details: nil,
            durationMinutes: durationMinutes,
            priority: priority
        )
        
        context.insert(task)
    }
    
    /// Clears all existing tasks (use with caution!)
    static func clearAllTasks(context: ModelContext) {
        do {
            try context.delete(model: TaskItem.self)
            try context.save()
            print("✅ Cleared all existing tasks")
        } catch {
            print("❌ Error clearing tasks: \(error.localizedDescription)")
        }
    }
    
    /// Quick function to generate sample data for previews
    static func previewTasks(context: ModelContext) {
        let calendar = Calendar.current
        let today = Date()
        
        // Just a few tasks for preview
        createTask(
            title: "Morning Meeting",
            durationMinutes: 30,
            priority: 7,
            date: today,
            hour: 9,
            minute: 0,
            context: context
        )
        
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        createTask(
            title: "Lunch with Client",
            durationMinutes: 60,
            priority: 8,
            date: tomorrow,
            hour: 12,
            minute: 0,
            context: context
        )
        
        try? context.save()
    }
}

// MARK: - View Extension for Easy Access
extension View {
    /// Adds a toolbar button to generate sample tasks (debug only)
    func withSampleDataButton(modelContext: ModelContext) -> some View {
        #if DEBUG
        self.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Generate Samples") {
                    SampleTaskGenerator.generateSampleTasks(context: modelContext)
                }
            }
        }
        #else
        self
        #endif
    }
}
