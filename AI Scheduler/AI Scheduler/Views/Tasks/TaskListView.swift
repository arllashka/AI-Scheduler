//
//  TaskListView.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import SwiftUI
import SwiftData

struct TaskListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TaskItem.priority, order: .reverse) private var tasks: [TaskItem]
    
    @State private var searchText = ""
    @State private var showAddTask = false
    @State private var showFilters = false
    @State private var selectedFilter: TaskFilter = .all
    
    // AI Scheduling
    @StateObject private var schedulerCoordinator = SchedulerCoordinator()
    @StateObject private var userPreferences = UserPreferences.shared
    @State private var showSchedulingResult = false
    @State private var schedulingResultMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                if filteredTasks.isEmpty {
                    EmptyStateView(
                        icon: "calendar.badge.plus",
                        title: "No Tasks Yet",
                        message: "Add your first task and let AI schedule it for you",
                        actionTitle: "Add Task"
                    ) {
                        showAddTask = true
                    }
                } else {
                    ScrollView {
                        VStack(spacing: AppSpacing.medium) {
                            // Stats Section
                            statsSection
                            
                            // AI Schedule Button
                            aiScheduleButton
                            
                            // Filter Chips
                            filterChips
                            
                            // Tasks by Status
                            taskSections
                        }
                        .padding(.horizontal, AppSpacing.medium)
                        .padding(.bottom, AppSpacing.xlarge)
                    }
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddTask = true
                    } label: {
                        Image(systemName: AppIcons.add)
                            .foregroundColor(.primaryBlue)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showFilters = true
                    } label: {
                        Image(systemName: AppIcons.filter)
                            .foregroundColor(.primaryBlue)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search tasks...")
            .sheet(isPresented: $showAddTask) {
                AddTaskView()
            }
            .sheet(isPresented: $showFilters) {
                FilterView(selectedFilter: $selectedFilter)
            }
            .alert(schedulingResultMessage, isPresented: $showSchedulingResult) {
                Button("OK", role: .cancel) { }
            }
            .overlay {
                if schedulerCoordinator.isLoading {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        
                        VStack(spacing: AppSpacing.medium) {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(.white)
                            
                            Text("AI is scheduling your tasks...")
                                .font(AppTypography.body)
                                .foregroundColor(.white)
                        }
                        .padding(AppSpacing.xlarge)
                        .background(.ultraThinMaterial)
                        .cornerRadius(AppCornerRadius.medium)
                    }
                }
            }
        }
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        HStack(spacing: AppSpacing.small) {
            StatsCard(
                icon: AppIcons.tasks,
                value: "\(activeTasks.count)",
                label: "Active",
                color: .primaryBlue
            )
            
            StatsCard(
                icon: AppIcons.complete,
                value: "\(completedTasksCount)",
                label: "Completed",
                color: .accentGreen
            )
            
            StatsCard(
                icon: AppIcons.schedule,
                value: "\(scheduledTasksCount)",
                label: "Scheduled",
                color: .accentPurple
            )
        }
        .padding(.top, AppSpacing.small)
    }
    
    // MARK: - AI Schedule Button
    private var aiScheduleButton: some View {
        Button {
            scheduleTasksWithAI()
        } label: {
            HStack {
                Image(systemName: AppIcons.aiSchedule)
                    .font(.system(size: 20, weight: .semibold))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("AI Schedule")
                        .font(AppTypography.buttonLabel)
                    Text("Let AI organize your tasks")
                        .font(AppTypography.caption)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(AppSpacing.medium)
            .background(
                LinearGradient(
                    colors: [.primaryBlue, .accentPurple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(AppCornerRadius.medium)
            .shadow(
                color: Color.primaryBlue.opacity(0.3),
                radius: 8,
                x: 0,
                y: 4
            )
        }
        .disabled(schedulerCoordinator.isLoading || unscheduledActiveTasks.isEmpty)
        .opacity((schedulerCoordinator.isLoading || unscheduledActiveTasks.isEmpty) ? 0.6 : 1.0)
    }
    
    // MARK: - Filter Chips
    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.xsmall) {
                ForEach(TaskFilter.allCases, id: \.self) { filter in
                    FilterChip(
                        title: filter.rawValue,
                        isSelected: selectedFilter == filter
                    ) {
                        selectedFilter = filter
                    }
                }
            }
        }
    }
    
    // MARK: - Task Sections
    private var taskSections: some View {
        VStack(spacing: AppSpacing.large) {
            // Scheduled Tasks
            if !scheduledTasks.isEmpty {
                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    SectionHeader("Scheduled")
                    
                    ForEach(scheduledTasks) { task in
                        TaskCard(
                            title: task.title,
                            duration: formatDuration(task.durationMinutes),
                            priority: task.priority,
                            isCompleted: task.isCompleted,
                            scheduledTime: formatScheduledTime(task.scheduledStart)
                        ) {
                            // Task tapped - could navigate to detail
                        } onComplete: {
                            toggleTaskCompletion(task)
                        }
                    }
                }
            }
            
            // Unscheduled Tasks
            if !unscheduledTasks.isEmpty {
                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    SectionHeader("To Schedule")
                    
                    ForEach(unscheduledTasks) { task in
                        TaskCard(
                            title: task.title,
                            duration: formatDuration(task.durationMinutes),
                            priority: task.priority,
                            isCompleted: task.isCompleted,
                            scheduledTime: nil
                        ) {
                            // Task tapped
                        } onComplete: {
                            toggleTaskCompletion(task)
                        }
                    }
                }
            }
            
            // Completed Tasks
            if !completedTasks.isEmpty {
                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    SectionHeader("Completed")
                    
                    ForEach(completedTasks) { task in
                        TaskCard(
                            title: task.title,
                            duration: formatDuration(task.durationMinutes),
                            priority: task.priority,
                            isCompleted: task.isCompleted,
                            scheduledTime: formatScheduledTime(task.scheduledStart)
                        ) {
                            // Task tapped
                        } onComplete: {
                            toggleTaskCompletion(task)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var activeTasks: [TaskItem] {
        tasks.filter { !$0.isCompleted }
    }
    
    private var completedTasksCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    private var scheduledTasksCount: Int {
        tasks.filter { $0.scheduledStart != nil && !$0.isCompleted }.count
    }
    
    private var unscheduledActiveTasks: [TaskItem] {
        tasks.filter { $0.scheduledStart == nil && !$0.isCompleted }
    }
    
    private var filteredTasks: [TaskItem] {
        var result = tasks
        
        // Apply filter
        switch selectedFilter {
        case .all:
            break
        case .scheduled:
            result = result.filter { $0.scheduledStart != nil }
        case .unscheduled:
            result = result.filter { $0.scheduledStart == nil && !$0.isCompleted }
        case .completed:
            result = result.filter { $0.isCompleted }
        case .highPriority:
            result = result.filter { $0.priority >= 7 }
        }
        
        // Apply search
        if !searchText.isEmpty {
            result = result.filter { 
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                ($0.details?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        return result
    }
    
    private var scheduledTasks: [TaskItem] {
        filteredTasks.filter { $0.scheduledStart != nil && !$0.isCompleted }
            .sorted { ($0.scheduledStart ?? Date.distantPast) < ($1.scheduledStart ?? Date.distantPast) }
    }
    
    private var unscheduledTasks: [TaskItem] {
        filteredTasks.filter { $0.scheduledStart == nil && !$0.isCompleted }
            .sorted { $0.priority > $1.priority }
    }
    
    private var completedTasks: [TaskItem] {
        filteredTasks.filter { $0.isCompleted }
            .sorted { $0.updatedAt > $1.updatedAt }
    }
    
    // MARK: - Actions
    
    private func toggleTaskCompletion(_ task: TaskItem) {
        task.isCompleted.toggle()
        task.updatedAt = Date()
        try? modelContext.save()
    }
    
    private func scheduleTasksWithAI() {
        // Get unscheduled tasks
        let tasksToSchedule = unscheduledActiveTasks
        
        guard !tasksToSchedule.isEmpty else {
            schedulingResultMessage = "No tasks to schedule!"
            showSchedulingResult = true
            return
        }
        
        Task {
            // Generate available slots
            let availableSlots = AvailableSlotGenerator.generateSlots(
                forNextDays: 7,
                workHoursStart: userPreferences.workHoursStart,
                workHoursEnd: userPreferences.workHoursEnd,
                existingTasks: tasks.filter { $0.scheduledStart != nil && !$0.isCompleted }
            )
            
            guard !availableSlots.isEmpty else {
                schedulingResultMessage = "No available time slots found. Please check your work hours settings."
                showSchedulingResult = true
                return
            }
            
            // Call AI scheduler
            await schedulerCoordinator.scheduleTasks(
                from: tasksToSchedule,
                availableSlots: availableSlots,
                constraints: userPreferences.timeConstraints
            )
            
            // Handle result
            if let error = schedulerCoordinator.lastError {
                schedulingResultMessage = "Scheduling failed: \(error.localizedDescription)"
                showSchedulingResult = true
            } else if let response = schedulerCoordinator.lastResponse {
                // Apply scheduled slots to tasks
                schedulerCoordinator.applySchedule(to: tasksToSchedule, from: response)
                
                // Save changes
                try? modelContext.save()
                
                // Show success message
                let scheduledCount = response.scheduledSlots.count
                let unscheduledCount = response.unscheduledTasks.count
                
                if unscheduledCount == 0 {
                    schedulingResultMessage = "✅ Successfully scheduled \(scheduledCount) task\(scheduledCount == 1 ? "" : "s")!"
                } else {
                    schedulingResultMessage = "⚠️ Scheduled \(scheduledCount) task\(scheduledCount == 1 ? "" : "s"), but \(unscheduledCount) couldn't be scheduled due to time constraints."
                }
                
                showSchedulingResult = true
            }
        }
    }
    
    // MARK: - Formatting Helpers
    
    private func formatDuration(_ minutes: Int) -> String {
        if minutes >= 60 {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            if remainingMinutes == 0 {
                return "\(hours)h"
            }
            return "\(hours)h \(remainingMinutes)m"
        }
        return "\(minutes)m"
    }
    
    private func formatScheduledTime(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTypography.footnote)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : .textPrimary)
                .padding(.horizontal, AppSpacing.small)
                .padding(.vertical, AppSpacing.xxsmall)
                .background(isSelected ? Color.primaryBlue : Color.backgroundTertiary)
                .cornerRadius(AppCornerRadius.small)
        }
    }
}

// MARK: - Filter View
struct FilterView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedFilter: TaskFilter
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(TaskFilter.allCases, id: \.self) { filter in
                    Button {
                        selectedFilter = filter
                        dismiss()
                    } label: {
                        HStack {
                            Text(filter.rawValue)
                                .foregroundColor(.textPrimary)
                            Spacer()
                            if selectedFilter == filter {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.primaryBlue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filter Tasks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Task Filter
enum TaskFilter: String, CaseIterable {
    case all = "All"
    case scheduled = "Scheduled"
    case unscheduled = "Unscheduled"
    case completed = "Completed"
    case highPriority = "High Priority"
}

#Preview {
    TaskListView()
        .modelContainer(for: TaskItem.self, inMemory: true)
}
