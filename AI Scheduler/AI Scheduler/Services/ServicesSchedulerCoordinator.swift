//
//  SchedulerServiceProtocol.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import Foundation
import Combine

/// Protocol for scheduler services (real and mock)
protocol SchedulerServiceProtocol: AnyObject, ObservableObject {
    var isLoading: Bool { get }
    var lastError: APIError? { get }
    
    func scheduleTasks(
        tasks: [TaskDTO],
        availableSlots: [AvailableSlot],
        constraints: TimeConstraints
    ) async throws -> SchedulerResponse
    
    func scheduleTasks(
        from taskItems: [TaskItem],
        availableSlots: [AvailableSlot],
        constraints: TimeConstraints
    ) async throws -> SchedulerResponse
}

/// Service coordinator that manages scheduling operations
@MainActor
final class SchedulerCoordinator: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isLoading = false
    @Published var lastError: APIError?
    @Published var lastResponse: SchedulerResponse?
    
    // MARK: - Private Properties
    
    private let service: any SchedulerServiceProtocol
    
    // MARK: - Initialization
    
    /// Initialize with a specific service
    init(service: any SchedulerServiceProtocol) {
        self.service = service
    }
    
    /// Initialize with default OpenAI service
    convenience init() {
        self.init(service: OpenAISchedulerService())
    }
    
    /// Initialize with mock service for testing
    static func mock() -> SchedulerCoordinator {
        SchedulerCoordinator(service: MockSchedulerService())
    }
    
    // MARK: - Public Methods
    
    /// Schedule tasks and update state
    func scheduleTasks(
        tasks: [TaskDTO],
        availableSlots: [AvailableSlot],
        constraints: TimeConstraints
    ) async {
        isLoading = true
        lastError = nil
        
        defer {
            isLoading = false
        }
        
        do {
            let response = try await service.scheduleTasks(
                tasks: tasks,
                availableSlots: availableSlots,
                constraints: constraints
            )
            lastResponse = response
        } catch let error as APIError {
            lastError = error
        } catch {
            lastError = .networkError(error)
        }
    }
    
    /// Schedule tasks from TaskItem models
    func scheduleTasks(
        from taskItems: [TaskItem],
        availableSlots: [AvailableSlot],
        constraints: TimeConstraints
    ) async {
        isLoading = true
        lastError = nil
        
        defer {
            isLoading = false
        }
        
        do {
            let response = try await service.scheduleTasks(
                from: taskItems,
                availableSlots: availableSlots,
                constraints: constraints
            )
            lastResponse = response
        } catch let error as APIError {
            lastError = error
        } catch {
            lastError = .networkError(error)
        }
    }
    
    /// Apply scheduled slots to task items
    func applySchedule(to tasks: [TaskItem], from response: SchedulerResponse) {
        let slotsByTaskId = Dictionary(
            grouping: response.scheduledSlots,
            by: { $0.taskId }
        ).mapValues { $0.first! }
        
        for task in tasks {
            if let slot = slotsByTaskId[task.id] {
                task.applyScheduledSlot(slot)
            }
        }
    }
}
