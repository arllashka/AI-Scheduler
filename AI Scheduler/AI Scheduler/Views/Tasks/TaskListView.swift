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
    @State private var selectedTask: TaskItem?

    // AI Scheduling
    @StateObject private var schedulerCoordinator = SchedulerCoordinator()
    @StateObject private var userPreferences = UserPreferences.shared
    @State private var showSchedulingResult = false
    @State private var schedulingResultMessage = ""

    // Animation namespace for smooth transitions
    @Namespace private var taskAnimation
    
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
            .sheet(item: $selectedTask) { task in
                SingleTaskView(task: task)
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
                            selectedTask = task
                        } onComplete: {
                            toggleTaskCompletion(task)
                        }
                        .matchedGeometryEffect(id: task.id, in: taskAnimation)
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
                            selectedTask = task
                        } onComplete: {
                            toggleTaskCompletion(task)
                        }
                        .matchedGeometryEffect(id: task.id, in: taskAnimation)
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
                            selectedTask = task
                        } onComplete: {
                            toggleTaskCompletion(task)
                        }
                        .matchedGeometryEffect(id: task.id, in: taskAnimation)
                        .transition(.asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal: .move(edge: .bottom).combined(with: .opacity)
                        ))
                    }
                }
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: completedTasks.map { $0.id })
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: scheduledTasks.map { $0.id })
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: unscheduledTasks.map { $0.id })
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
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            task.isCompleted.toggle()
            task.updatedAt = Date()
        }

        // Save after a small delay to let animation start
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            try? modelContext.save()
        }
    }
    
    private func scheduleTasksWithAI() {
        // Get unscheduled tasks (excluding completed)
        let tasksToSchedule = unscheduledActiveTasks

        guard !tasksToSchedule.isEmpty else {
            schedulingResultMessage = "No tasks to schedule!"
            showSchedulingResult = true
            return
        }

        Task {
            // Get existing scheduled tasks (excluding completed) to avoid conflicts
            let existingScheduledTasks = tasks.filter { $0.scheduledStart != nil && !$0.isCompleted }

            // Generate available slots considering existing schedule
            let availableSlots = AvailableSlotGenerator.generateSlots(
                forNextDays: 7,
                workHoursStart: userPreferences.workHoursStart,
                workHoursEnd: userPreferences.workHoursEnd,
                existingTasks: existingScheduledTasks
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

                // Generate detailed summary
                schedulingResultMessage = generateSchedulingSummary(
                    totalTasks: tasksToSchedule.count,
                    scheduledSlots: response.scheduledSlots,
                    unscheduledTasks: response.unscheduledTasks,
                    existingScheduledCount: existingScheduledTasks.count
                )

                showSchedulingResult = true
            }
        }
    }

    // MARK: - Scheduling Summary

    private func generateSchedulingSummary(
        totalTasks: Int,
        scheduledSlots: [ScheduledSlot],
        unscheduledTasks: [UnscheduledTask],
        existingScheduledCount: Int
    ) -> String {
        let scheduledCount = scheduledSlots.count
        let unscheduledCount = unscheduledTasks.count

        var summary = ""

        // Header
        if unscheduledCount == 0 {
            summary += "✅ AI Scheduling Complete!\n\n"
        } else {
            summary += "⚠️ AI Scheduling Partial\n\n"
        }

        // Stats
        summary += "📊 Summary:\n"
        summary += "• \(scheduledCount) task\(scheduledCount == 1 ? "" : "s") scheduled\n"

        if unscheduledCount > 0 {
            summary += "• \(unscheduledCount) task\(unscheduledCount == 1 ? "" : "s") couldn't fit\n"
        }

        if existingScheduledCount > 0 {
            summary += "• \(existingScheduledCount) existing task\(existingScheduledCount == 1 ? "" : "s") preserved\n"
        }

        // Time range if any tasks were scheduled
        if scheduledCount > 0, let firstSlot = scheduledSlots.min(by: { $0.scheduledStart < $1.scheduledStart }),
           let lastSlot = scheduledSlots.max(by: { $0.scheduledStart < $1.scheduledStart }) {

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d"

            let startDate = dateFormatter.string(from: firstSlot.scheduledStart)
            let endDate = dateFormatter.string(from: lastSlot.scheduledStart)

            summary += "\n📅 Scheduled from \(startDate)"
            if startDate != endDate {
                summary += " to \(endDate)"
            }
        }

        // Show reasons for unscheduled tasks
        if unscheduledCount > 0 && !unscheduledTasks.isEmpty {
            summary += "\n\n❌ Couldn't schedule:\n"
            for unscheduledTask in unscheduledTasks.prefix(3) {
                // Find the task title
                if let task = tasks.first(where: { $0.id == unscheduledTask.taskId }) {
                    summary += "• \(task.title): \(unscheduledTask.reason)\n"
                }
            }
            if unscheduledTasks.count > 3 {
                summary += "• ...and \(unscheduledTasks.count - 3) more\n"
            }
        }

        // Tip if some tasks couldn't be scheduled
        if unscheduledCount > 0 {
            summary += "\n💡 Tip: Try adjusting work hours or reducing task durations to fit all tasks."
        }

        return summary
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
        let calendar = Calendar.current

        // Check if the date is today
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "h:mm a"
            return "Today at \(formatter.string(from: date))"
        }
        // Check if the date is tomorrow
        else if calendar.isDateInTomorrow(date) {
            formatter.dateFormat = "h:mm a"
            return "Tomorrow at \(formatter.string(from: date))"
        }
        // Check if the date is within the next 7 days
        else if let daysFromNow = calendar.dateComponents([.day], from: Date(), to: date).day,
                daysFromNow >= 0 && daysFromNow < 7 {
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEEE" // Day name
            formatter.dateFormat = "h:mm a"
            return "\(dayFormatter.string(from: date)) at \(formatter.string(from: date))"
        }
        // For dates further out, show full date
        else {
            formatter.dateFormat = "MMM d, h:mm a"
            return formatter.string(from: date)
        }
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
