//
//  CalendarView.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [TaskItem]
    
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var showAddTask = false
    @State private var taskDateToCreate: Date?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.large) {
                    // Calendar Grid
                    calendarGrid
                    
                    // Today's Schedule
                    todaySchedule
                }
                .padding(.horizontal, AppSpacing.medium)
                .padding(.bottom, AppSpacing.xlarge)
            }
            .navigationTitle("Calendar")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        taskDateToCreate = selectedDate
                        showAddTask = true
                    } label: {
                        Image(systemName: AppIcons.add)
                            .foregroundColor(.primaryBlue)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        currentMonth = Date()
                        selectedDate = Date()
                    } label: {
                        Text("Today")
                            .foregroundColor(.primaryBlue)
                    }
                }
            }
            .sheet(isPresented: $showAddTask) {
                if let date = taskDateToCreate {
                    QuickAddTaskView(scheduledDate: date)
                }
            }
        }
    }
    
    // MARK: - Calendar Grid
    private var calendarGrid: some View {
        VStack(spacing: AppSpacing.small) {
            // Month Header
            HStack {
                Button {
                    changeMonth(by: -1)
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primaryBlue)
                }
                
                Spacer()
                
                Text(monthYearString)
                    .font(AppTypography.title3)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button {
                    changeMonth(by: 1)
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.primaryBlue)
                }
            }
            .padding(.vertical, AppSpacing.small)
            
            // Day Labels
            HStack(spacing: 0) {
                ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                    Text(day)
                        .font(AppTypography.caption)
                        .foregroundColor(.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, AppSpacing.xxsmall)
            
            // Calendar Days
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: AppSpacing.xxsmall) {
                ForEach(daysInMonth, id: \.self) { date in
                    if let date = date {
                        DayCell(
                            date: date,
                            isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                            isToday: Calendar.current.isDateInToday(date),
                            hasEvents: hasTasksOnDate(date)
                        ) {
                            selectedDate = date
                        }
                    } else {
                        Color.clear
                            .frame(height: 50)
                    }
                }
            }
        }
        .padding(AppSpacing.medium)
        .background(Color.adaptiveSecondaryBackground)
        .cornerRadius(AppCornerRadius.medium)
    }
    
    // MARK: - Today's Schedule
    private var todaySchedule: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            HStack {
                Text(dateHeaderString)
                    .font(AppTypography.title3)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button {
                    taskDateToCreate = selectedDate
                    showAddTask = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: AppIcons.add)
                        Text("Add")
                    }
                    .font(AppTypography.callout)
                    .foregroundColor(.primaryBlue)
                }
            }
            .padding(.horizontal, AppSpacing.medium)
            
            if tasksForSelectedDate.isEmpty {
                emptyScheduleView
            } else {
                ForEach(tasksForSelectedDate) { task in
                    ScheduledTaskCard(task: task)
                }
            }
        }
    }
    
    private var emptyScheduleView: some View {
        VStack(spacing: AppSpacing.small) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 40))
                .foregroundColor(.textTertiary)
            
            Text("No tasks scheduled")
                .font(AppTypography.body)
                .foregroundColor(.textSecondary)
            
            Button {
                taskDateToCreate = selectedDate
                showAddTask = true
            } label: {
                HStack {
                    Image(systemName: AppIcons.add)
                    Text("Add Task for \(selectedDateString)")
                }
                .font(AppTypography.callout)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, AppSpacing.medium)
                .padding(.vertical, AppSpacing.small)
                .background(Color.primaryBlue)
                .cornerRadius(AppCornerRadius.medium)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.xlarge)
        .background(Color.adaptiveSecondaryBackground)
        .cornerRadius(AppCornerRadius.medium)
    }
    
    // MARK: - Computed Properties
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    private var dateHeaderString: String {
        if Calendar.current.isDateInToday(selectedDate) {
            return "Today's Schedule"
        } else if Calendar.current.isDateInTomorrow(selectedDate) {
            return "Tomorrow's Schedule"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMM d"
            return formatter.string(from: selectedDate)
        }
    }
    
    private var selectedDateString: String {
        if Calendar.current.isDateInToday(selectedDate) {
            return "Today"
        } else if Calendar.current.isDateInTomorrow(selectedDate) {
            return "Tomorrow"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: selectedDate)
        }
    }
    
    private var daysInMonth: [Date?] {
        guard let monthInterval = Calendar.current.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeek = Calendar.current.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }
        
        let days = Calendar.current.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
        
        var result: [Date?] = []
        
        // Add empty cells for days before month starts
        let firstWeekday = Calendar.current.component(.weekday, from: monthInterval.start)
        for _ in 1..<firstWeekday {
            result.append(nil)
        }
        
        // Add actual days
        result.append(contentsOf: days)
        
        return result
    }
    
    private var tasksForSelectedDate: [TaskItem] {
        tasks.filter { task in
            guard let scheduledStart = task.scheduledStart else { return false }
            return Calendar.current.isDate(scheduledStart, inSameDayAs: selectedDate)
        }.sorted { task1, task2 in
            guard let start1 = task1.scheduledStart, let start2 = task2.scheduledStart else {
                return false
            }
            return start1 < start2
        }
    }
    
    // MARK: - Helper Functions
    private func hasTasksOnDate(_ date: Date) -> Bool {
        tasks.contains { task in
            guard let scheduledStart = task.scheduledStart else { return false }
            return Calendar.current.isDate(scheduledStart, inSameDayAs: date)
        }
    }
    
    private func changeMonth(by value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
}

// MARK: - Day Cell
struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasEvents: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(AppTypography.callout)
                    .fontWeight(isSelected || isToday ? .bold : .regular)
                    .foregroundColor(textColor)
                
                if hasEvents {
                    Circle()
                        .fill(isSelected ? Color.white : Color.primaryBlue)
                        .frame(width: 4, height: 4)
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 4, height: 4)
                }
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(AppCornerRadius.small)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.small)
                    .stroke(borderColor, lineWidth: isToday ? 2 : 0)
            )
        }
    }
    
    private var textColor: Color {
        if isSelected {
            return .white
        }
        return .textPrimary
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return .primaryBlue
        }
        return Color.clear
    }
    
    private var borderColor: Color {
        if isToday && !isSelected {
            return .primaryBlue
        }
        return .clear
    }
}

// MARK: - Scheduled Task Card
struct ScheduledTaskCard: View {
    let task: TaskItem
    
    var body: some View {
        HStack(spacing: AppSpacing.small) {
            // Time Indicator
            if let startTime = task.scheduledStart, let endTime = task.scheduledEnd {
                VStack(alignment: .leading, spacing: 2) {
                    Text(timeString(startTime))
                        .font(AppTypography.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.primaryBlue)
                    
                    Text(timeString(endTime))
                        .font(AppTypography.caption2)
                        .foregroundColor(.textSecondary)
                }
                .frame(width: 60, alignment: .leading)
            }
            
            // Color Bar
            RoundedRectangle(cornerRadius: 2)
                .fill(priorityColor(task.priority))
                .frame(width: 3)
            
            // Task Info
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(AppTypography.body)
                    .fontWeight(.medium)
                    .foregroundColor(.textPrimary)
                
                Text(durationText(for: task))
                    .font(AppTypography.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            // Status Indicator
            if task.isCompleted {
                Image(systemName: AppIcons.complete)
                    .foregroundColor(.accentGreen)
            }
        }
        .padding(AppSpacing.small)
        .background(Color.adaptiveSecondaryBackground)
        .cornerRadius(AppCornerRadius.small)
    }
    
    private func timeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func durationText(for task: TaskItem) -> String {
        let duration = task.durationMinutes
        let hours = duration / 60
        let minutes = duration % 60
        
        if hours > 0 {
            return minutes > 0 ? "\(hours)h \(minutes)m" : "\(hours)h"
        }
        return "\(minutes)m"
    }
    
    private func priorityColor(_ priority: Int) -> Color {
        switch priority {
        case 1...2: return .priorityLow
        case 3: return .priorityMedium
        case 4: return .priorityHigh
        default: return .priorityCritical
        }
    }
}

// MARK: - Calendar Extension
extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        
        return dates
    }
}

#Preview {
    CalendarView()
}
