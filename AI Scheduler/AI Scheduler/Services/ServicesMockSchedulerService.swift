//
//  MockSchedulerService.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import Foundation
import SwiftUI
import Combine

/// Mock scheduler service for testing and development without API calls
@MainActor
final class MockSchedulerService: ObservableObject, SchedulerServiceProtocol {
    
    @Published var isLoading = false
    @Published var lastError: APIError?
    
    /// Simulated network delay
    var simulatedDelay: TimeInterval = 1.5
    
    /// Should the mock simulate a failure?
    var shouldFail = false
    var failureError: APIError = .networkError(URLError(.notConnectedToInternet))
    
    init() {}
    
    /// Mock schedule tasks
    func scheduleTasks(
        tasks: [TaskDTO],
        availableSlots: [AvailableSlot],
        constraints: TimeConstraints
    ) async throws -> SchedulerResponse {
        isLoading = true
        lastError = nil
        
        defer {
            isLoading = false
        }
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: UInt64(simulatedDelay * 1_000_000_000))
        
        // Simulate failure if configured
        if shouldFail {
            lastError = failureError
            throw failureError
        }
        
        // Generate mock scheduled slots
        var scheduledSlots: [ScheduledSlot] = []
        var unscheduledTasks: [UnscheduledTask] = []
        
        // Sort tasks by priority (high to low)
        let sortedTasks = tasks.sorted { $0.priority > $1.priority }
        
        var currentSlotIndex = 0
        var currentTime = availableSlots.first?.start ?? Date()
        
        for task in sortedTasks {
            // Check if task has fixed time slot
            if let fixedSlot = task.fixedTimeSlot {
                let slot = ScheduledSlot(
                    taskId: task.id,
                    scheduledStart: fixedSlot.start,
                    scheduledEnd: fixedSlot.end
                )
                scheduledSlots.append(slot)
                continue
            }
            
            // Try to fit task in available slots
            var scheduled = false
            
            while currentSlotIndex < availableSlots.count {
                let availableSlot = availableSlots[currentSlotIndex]
                let taskDuration = TimeInterval(task.durationMinutes * 60)
                
                // Check if task fits in current time
                if currentTime < availableSlot.start {
                    currentTime = availableSlot.start
                }
                
                let proposedEnd = currentTime.addingTimeInterval(taskDuration)
                
                if proposedEnd <= availableSlot.end {
                    // Task fits!
                    let slot = ScheduledSlot(
                        taskId: task.id,
                        scheduledStart: currentTime,
                        scheduledEnd: proposedEnd
                    )
                    scheduledSlots.append(slot)
                    
                    // Add small buffer (5 minutes)
                    currentTime = proposedEnd.addingTimeInterval(5 * 60)
                    scheduled = true
                    break
                } else {
                    // Move to next available slot
                    currentSlotIndex += 1
                    if currentSlotIndex < availableSlots.count {
                        currentTime = availableSlots[currentSlotIndex].start
                    }
                }
            }
            
            // If couldn't schedule, add to unscheduled
            if !scheduled {
                let unscheduled = UnscheduledTask(
                    taskId: task.id,
                    reason: "Not enough available time slots for task duration"
                )
                unscheduledTasks.append(unscheduled)
            }
        }
        
        // Create metadata
        let metadata = SchedulerMetadata(
            totalTasks: tasks.count,
            scheduledCount: scheduledSlots.count,
            unscheduledCount: unscheduledTasks.count,
            processingTime: simulatedDelay,
            aiModel: "mock-scheduler-v1"
        )
        
        return SchedulerResponse(
            scheduledSlots: scheduledSlots,
            unscheduledTasks: unscheduledTasks,
            metadata: metadata
        )
    }
    
    /// Convenience method for TaskItem models
    func scheduleTasks(
        from taskItems: [TaskItem],
        availableSlots: [AvailableSlot],
        constraints: TimeConstraints
    ) async throws -> SchedulerResponse {
        let taskDTOs = taskItems.map { $0.toDTO() }
        return try await scheduleTasks(
            tasks: taskDTOs,
            availableSlots: availableSlots,
            constraints: constraints
        )
    }
}
