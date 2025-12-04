//
//  TaskListView.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import SwiftUI

struct TaskListView: View {
    @State private var searchText = ""
    @State private var showAddTask = false
    @State private var showFilters = false
    @State private var selectedFilter: TaskFilter = .all
    
    // Mock data for UI preview
    @State private var tasks: [MockTask] = MockTask.sampleTasks
    
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
        }
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        HStack(spacing: AppSpacing.small) {
            StatsCard(
                icon: AppIcons.tasks,
                value: "\(tasks.filter { !$0.isCompleted }.count)",
                label: "Active",
                color: .primaryBlue
            )
            
            StatsCard(
                icon: AppIcons.complete,
                value: "\(tasks.filter { $0.isCompleted }.count)",
                label: "Completed",
                color: .accentGreen
            )
            
            StatsCard(
                icon: AppIcons.schedule,
                value: "\(tasks.filter { $0.scheduledTime != nil }.count)",
                label: "Scheduled",
                color: .accentPurple
            )
        }
        .padding(.top, AppSpacing.small)
    }
    
    // MARK: - AI Schedule Button
    private var aiScheduleButton: some View {
        Button {
            // Schedule action
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
                            duration: task.durationText,
                            priority: task.priority,
                            isCompleted: task.isCompleted,
                            scheduledTime: task.scheduledTime
                        ) {
                            // Task tapped
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
                            duration: task.durationText,
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
                            duration: task.durationText,
                            priority: task.priority,
                            isCompleted: task.isCompleted,
                            scheduledTime: task.scheduledTime
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
    private var filteredTasks: [MockTask] {
        var result = tasks
        
        // Apply filter
        switch selectedFilter {
        case .all:
            break
        case .scheduled:
            result = result.filter { $0.scheduledTime != nil }
        case .unscheduled:
            result = result.filter { $0.scheduledTime == nil && !$0.isCompleted }
        case .completed:
            result = result.filter { $0.isCompleted }
        case .highPriority:
            result = result.filter { $0.priority >= 7 }
        }
        
        // Apply search
        if !searchText.isEmpty {
            result = result.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        
        return result
    }
    
    private var scheduledTasks: [MockTask] {
        filteredTasks.filter { $0.scheduledTime != nil && !$0.isCompleted }
    }
    
    private var unscheduledTasks: [MockTask] {
        filteredTasks.filter { $0.scheduledTime == nil && !$0.isCompleted }
    }
    
    private var completedTasks: [MockTask] {
        filteredTasks.filter { $0.isCompleted }
    }
    
    // MARK: - Actions
    private func toggleTaskCompletion(_ task: MockTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
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

// MARK: - Mock Data
enum TaskFilter: String, CaseIterable {
    case all = "All"
    case scheduled = "Scheduled"
    case unscheduled = "Unscheduled"
    case completed = "Completed"
    case highPriority = "High Priority"
}

struct MockTask: Identifiable {
    let id = UUID()
    var title: String
    var durationMinutes: Int
    var priority: Int
    var isCompleted: Bool
    var scheduledTime: String?
    
    var durationText: String {
        if durationMinutes >= 60 {
            let hours = durationMinutes / 60
            let minutes = durationMinutes % 60
            if minutes == 0 {
                return "\(hours)h"
            }
            return "\(hours)h \(minutes)m"
        }
        return "\(durationMinutes)m"
    }
    
    static let sampleTasks: [MockTask] = [
        MockTask(title: "Complete project proposal", durationMinutes: 120, priority: 8, isCompleted: false, scheduledTime: "9:00 AM"),
        MockTask(title: "Team meeting", durationMinutes: 60, priority: 7, isCompleted: false, scheduledTime: "2:00 PM"),
        MockTask(title: "Review code changes", durationMinutes: 45, priority: 6, isCompleted: false, scheduledTime: nil),
        MockTask(title: "Update documentation", durationMinutes: 30, priority: 4, isCompleted: false, scheduledTime: nil),
        MockTask(title: "Email clients", durationMinutes: 30, priority: 5, isCompleted: true, scheduledTime: "10:00 AM"),
        MockTask(title: "Lunch break", durationMinutes: 60, priority: 2, isCompleted: true, scheduledTime: "12:00 PM"),
    ]
}

#Preview {
    TaskListView()
}
