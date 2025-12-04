////
////  SchedulerServiceTests.swift
////  AI Scheduler Tests
////
////  Created by Arlan Kalin on 04.12.2025.
////
//
//import Testing
//import Foundation
//@testable import AI_Scheduler
//
//@Suite("Scheduler Service Tests")
//struct SchedulerServiceTests {
//    
//    // MARK: - Mock Service Tests
//    
//    @Test("Mock service schedules tasks successfully")
//    func mockServiceSchedulesTasks() async throws {
//        let service = await MockSchedulerService()
//        
//        let response = try await service.scheduleTasks(
//            tasks: SampleData.sampleTaskDTOs,
//            availableSlots: SampleData.sampleAvailableSlots,
//            constraints: SampleData.defaultConstraints
//        )
//        
//        #expect(response.scheduledSlots.count > 0)
//        #expect(response.metadata.totalTasks == SampleData.sampleTaskDTOs.count)
//        #expect(response.metadata.aiModel == "mock-scheduler-v1")
//    }
//    
//    @Test("Mock service handles failures")
//    func mockServiceHandlesFailures() async throws {
//        let service = await MockSchedulerService()
//        await service.configure(shouldFail: true)
//        
//        do {
//            _ = try await service.scheduleTasks(
//                tasks: SampleData.sampleTaskDTOs,
//                availableSlots: SampleData.sampleAvailableSlots,
//                constraints: SampleData.defaultConstraints
//            )
//            Issue.record("Expected service to throw error")
//        } catch {
//            // Expected to fail
//            #expect(error is APIError)
//        }
//    }
//    
//    @Test("Mock service respects priorities")
//    func mockServiceRespectsPriorities() async throws {
//        let service = await MockSchedulerService()
//        
//        let lowPriorityTask = TaskDTO(
//            title: "Low Priority",
//            durationMinutes: 60,
//            priority: 1
//        )
//        
//        let highPriorityTask = TaskDTO(
//            title: "High Priority",
//            durationMinutes: 60,
//            priority: 5
//        )
//        
//        let response = try await service.scheduleTasks(
//            tasks: [lowPriorityTask, highPriorityTask],
//            availableSlots: SampleData.sampleAvailableSlots,
//            constraints: SampleData.defaultConstraints
//        )
//        
//        // High priority should be scheduled first
//        let firstSlot = try #require(response.scheduledSlots.first)
//        #expect(firstSlot.taskId == highPriorityTask.id)
//    }
//    
//    // MARK: - Coordinator Tests
//    
//    @Test("Coordinator schedules tasks")
//    func coordinatorSchedulesTasks() async throws {
//        let coordinator = await SchedulerCoordinator.mock()
//        
//        await coordinator.scheduleTasks(
//            tasks: SampleData.sampleTaskDTOs,
//            availableSlots: SampleData.sampleAvailableSlots,
//            constraints: SampleData.defaultConstraints
//        )
//        
//        #expect(coordinator.lastError == nil)
//        #expect(coordinator.lastResponse != nil)
//    }
//    
//    @Test("Coordinator applies schedule to tasks")
//    func coordinatorAppliesSchedule() async throws {
//        let coordinator = await SchedulerCoordinator.mock()
//        
//        let tasks = SampleData.sampleTasks
//        let response = SampleData.sampleResponse
//        
//        await coordinator.applySchedule(to: tasks, from: response)
//        
//        // Check that at least some tasks have scheduled times
//        let scheduledTaskCount = tasks.filter { $0.scheduledStart != nil }.count
//        #expect(scheduledTaskCount > 0)
//    }
//    
//    // MARK: - Data Model Tests
//    
//    @Test("ScheduledSlot detects conflicts correctly")
//    func scheduledSlotDetectsConflicts() throws {
//        let calendar = Calendar.current
//        let today = Date()
//        
//        let slot1 = ScheduledSlot(
//            taskId: UUID(),
//            scheduledStart: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: today)!,
//            scheduledEnd: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: today)!
//        )
//        
//        let slot2 = ScheduledSlot(
//            taskId: UUID(),
//            scheduledStart: calendar.date(bySettingHour: 9, minute: 30, second: 0, of: today)!,
//            scheduledEnd: calendar.date(bySettingHour: 10, minute: 30, second: 0, of: today)!
//        )
//        
//        let slot3 = ScheduledSlot(
//            taskId: UUID(),
//            scheduledStart: calendar.date(bySettingHour: 10, minute: 30, second: 0, of: today)!,
//            scheduledEnd: calendar.date(bySettingHour: 11, minute: 30, second: 0, of: today)!
//        )
//        
//        // Slot1 and Slot2 should conflict
//        #expect(slot1.conflictsWith(slot2))
//        #expect(slot2.conflictsWith(slot1))
//        
//        // Slot1 and Slot3 should not conflict
//        #expect(!slot1.conflictsWith(slot3))
//        #expect(!slot3.conflictsWith(slot1))
//    }
//    
//    @Test("ScheduledSlot calculates duration correctly")
//    func scheduledSlotCalculatesDuration() throws {
//        let calendar = Calendar.current
//        let today = Date()
//        
//        let slot = ScheduledSlot(
//            taskId: UUID(),
//            scheduledStart: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: today)!,
//            scheduledEnd: calendar.date(bySettingHour: 10, minute: 30, second: 0, of: today)!
//        )
//        
//        #expect(slot.durationMinutes == 90)
//    }
//    
//    @Test("TaskItem converts to TaskDTO correctly")
//    func taskItemConvertsToDTO() throws {
//        let task = TaskItem(
//            title: "Test Task",
//            details: "Test details",
//            durationMinutes: 60,
//            priority: 4
//        )
//        
//        let dto = task.toDTO()
//        
//        #expect(dto.id == task.id)
//        #expect(dto.title == task.title)
//        #expect(dto.durationMinutes == task.durationMinutes)
//        #expect(dto.priority == task.priority)
//    }
//    
//    @Test("TaskDTO converts to TaskItem correctly")
//    func taskDTOConvertsToItem() throws {
//        let dto = TaskDTO(
//            title: "Test Task",
//            durationMinutes: 60,
//            priority: 4
//        )
//        
//        let item = dto.toTaskItem()
//        
//        #expect(item.id == dto.id)
//        #expect(item.title == dto.title)
//        #expect(item.durationMinutes == dto.durationMinutes)
//        #expect(item.priority == dto.priority)
//    }
//    
//    // MARK: - JSON Serialization Tests
//    
//    @Test("ScheduledSlot encodes and decodes correctly")
//    func scheduledSlotEncodesAndDecodes() throws {
//        let calendar = Calendar.current
//        let today = Date()
//        
//        let original = ScheduledSlot(
//            taskId: UUID(),
//            scheduledStart: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: today)!,
//            scheduledEnd: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: today)!
//        )
//        
//        let encoder = JSONEncoder()
//        encoder.dateEncodingStrategy = .iso8601
//        
//        let data = try encoder.encode(original)
//        
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//        
//        let decoded = try decoder.decode(ScheduledSlot.self, from: data)
//        
//        #expect(decoded.id == original.id)
//        #expect(decoded.taskId == original.taskId)
//        #expect(decoded.durationMinutes == original.durationMinutes)
//    }
//    
//    @Test("AvailableSlot encodes and decodes correctly")
//    func availableSlotEncodesAndDecodes() throws {
//        let calendar = Calendar.current
//        let today = Date()
//        
//        let original = AvailableSlot(
//            start: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: today)!,
//            end: calendar.date(bySettingHour: 17, minute: 0, second: 0, of: today)!
//        )
//        
//        let encoder = JSONEncoder()
//        let data = try encoder.encode(original)
//        
//        let decoder = JSONDecoder()
//        let decoded = try decoder.decode(AvailableSlot.self, from: data)
//        
//        #expect(decoded.durationMinutes == original.durationMinutes)
//    }
//    
//    // MARK: - Sample Data Tests
//    
//    @Test("Sample data is valid")
//    func sampleDataIsValid() throws {
//        #expect(SampleData.sampleTasks.count > 0)
//        #expect(SampleData.sampleTaskDTOs.count > 0)
//        #expect(SampleData.sampleAvailableSlots.count > 0)
//        #expect(SampleData.sampleScheduledSlots.count > 0)
//    }
//    
//    @Test("Weekly tasks generation works")
//    func weeklyTasksGeneration() throws {
//        let tasks = SampleData.weeklyTasks()
//        #expect(tasks.count > 0)
//        
//        for task in tasks {
//            #expect(!task.title.isEmpty)
//            #expect(task.durationMinutes > 0)
//            #expect(task.priority >= 1 && task.priority <= 5)
//        }
//    }
//    
//    @Test("Week of available slots generation works")
//    func weekOfAvailableSlotsGeneration() throws {
//        let slots = SampleData.weekOfAvailableSlots()
//        #expect(slots.count > 0)
//        
//        // Should have 2 slots per weekday (morning and afternoon)
//        // 5 weekdays × 2 slots = 10 slots
//        #expect(slots.count == 10)
//        
//        for slot in slots {
//            #expect(slot.start < slot.end)
//            #expect(slot.durationMinutes > 0)
//        }
//    }
//}
//
//// MARK: - Helper Extensions for Testing
//
//extension MockSchedulerService {
//    func configure(shouldFail: Bool) {
//        self.shouldFail = shouldFail
//    }
//}
