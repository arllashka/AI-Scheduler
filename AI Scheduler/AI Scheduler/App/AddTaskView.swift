//
//  AddTaskView.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import SwiftUI
import SwiftData

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    // Input mode toggle
    @State private var useNaturalLanguage = true

    // Natural language input
    @State private var naturalLanguageInput = ""
    @StateObject private var nlpParser = NLPParserService()
    @State private var parsedTasks: [ParsedTaskAttributes] = []
    @State private var showParsedResults = false

    // Structured input fields
    @State private var title = ""
    @State private var details = ""
    @State private var durationMinutes = 60
    @State private var priority = 5
    @State private var isFixed = false
    @State private var fixedDate: Date?
    @State private var hasRecurrence = false
    @State private var recurrence: RecurrenceType = .daily
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.large) {
                    // Input Mode Toggle
                    Picker("Input Mode", selection: $useNaturalLanguage) {
                        Text("Natural Language").tag(true)
                        Text("Structured").tag(false)
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, AppSpacing.small)

                    if useNaturalLanguage {
                        naturalLanguageSection
                    } else {
                        structuredInputSection
                    }

                    // AI Scheduling Tip
                    tipCard

                    Spacer()
                }
                .padding(AppSpacing.medium)
            }
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.textSecondary)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    if useNaturalLanguage {
                        Button("Parse") {
                            Task {
                                await parseNaturalLanguage()
                            }
                        }
                        .foregroundColor(.primaryBlue)
                        .fontWeight(.semibold)
                        .disabled(naturalLanguageInput.isEmpty || nlpParser.isLoading)
                    } else {
                        Button("Save") {
                            saveTask()
                        }
                        .foregroundColor(.primaryBlue)
                        .fontWeight(.semibold)
                        .disabled(title.isEmpty)
                    }
                }
            }
            .sheet(isPresented: $showParsedResults) {
                ParsedTasksReviewView(
                    parsedTasks: parsedTasks,
                    onConfirm: { createTasksFromParsed() },
                    onCancel: { showParsedResults = false }
                )
            }
            .overlay {
                if nlpParser.isLoading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .overlay {
                            ProgressView("Parsing your request...")
                                .padding()
                                .background(Color.adaptiveBackground)
                                .cornerRadius(AppCornerRadius.medium)
                        }
                }
            }
        }
    }

    // MARK: - Natural Language Section
    private var naturalLanguageSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text("Describe your task")
                .font(AppTypography.subheadline)
                .foregroundColor(.textSecondary)

            Text("Examples:")
                .font(AppTypography.caption)
                .foregroundColor(.textTertiary)

            VStack(alignment: .leading, spacing: 4) {
                exampleText("• \"Go to gym three times next week at noon\"")
                exampleText("• \"Grocery shopping next weekend\"")
                exampleText("• \"Call John tomorrow afternoon for 30 minutes\"")
                exampleText("• \"Team meeting every Monday at 10am\"")
            }
            .padding(.bottom, AppSpacing.xsmall)

            TextEditor(text: $naturalLanguageInput)
                .frame(minHeight: 120)
                .padding(AppSpacing.xxsmall)
                .background(Color.adaptiveSecondaryBackground)
                .cornerRadius(AppCornerRadius.small)
                .overlay(
                    RoundedRectangle(cornerRadius: AppCornerRadius.small)
                        .stroke(Color.borderLight, lineWidth: 1)
                )
                .overlay(alignment: .topLeading) {
                    if naturalLanguageInput.isEmpty {
                        Text("E.g., \"I wish I go to gym three times a week next week at noon\"")
                            .font(AppTypography.body)
                            .foregroundColor(.textTertiary)
                            .padding(.horizontal, AppSpacing.small)
                            .padding(.vertical, AppSpacing.xsmall + 2)
                            .allowsHitTesting(false)
                    }
                }

            if let error = nlpParser.lastError {
                Text("Error: \(error.localizedDescription)")
                    .font(AppTypography.caption)
                    .foregroundColor(.red)
                    .padding(.top, AppSpacing.xxsmall)
            }
        }
    }

    private func exampleText(_ text: String) -> some View {
        Text(text)
            .font(AppTypography.caption)
            .foregroundColor(.textSecondary)
    }

    // MARK: - Structured Input Section
    private var structuredInputSection: some View {
        VStack(spacing: AppSpacing.large) {
            // Title Section
            VStack(alignment: .leading, spacing: AppSpacing.xsmall) {
                Text("Task Title")
                    .font(AppTypography.subheadline)
                    .foregroundColor(.textSecondary)

                CustomTextField(
                    placeholder: "Enter task title",
                    icon: AppIcons.tasks,
                    text: $title
                )
            }
                    
            // Details Section
            VStack(alignment: .leading, spacing: AppSpacing.xsmall) {
                Text("Details (Optional)")
                    .font(AppTypography.subheadline)
                    .foregroundColor(.textSecondary)

                TextEditor(text: $details)
                    .frame(height: 100)
                    .padding(AppSpacing.xxsmall)
                    .background(Color.adaptiveSecondaryBackground)
                    .cornerRadius(AppCornerRadius.small)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppCornerRadius.small)
                            .stroke(Color.borderLight, lineWidth: 1)
                    )
            }

            // Duration Picker
            DurationPicker(durationMinutes: $durationMinutes)

            // Priority Picker
            PriorityPicker(priority: $priority)

            // Fixed Time Toggle
            VStack(alignment: .leading, spacing: AppSpacing.small) {
                Toggle(isOn: $isFixed) {
                    HStack(spacing: AppSpacing.xsmall) {
                        Image(systemName: AppIcons.alarm)
                            .foregroundColor(.primaryBlue)
                        Text("Fixed Time Slot")
                            .font(AppTypography.body)
                    }
                }
                .tint(.primaryBlue)

                if isFixed {
                    DatePicker(
                        "Select Time",
                        selection: Binding(
                            get: { fixedDate ?? Date() },
                            set: { fixedDate = $0 }
                        ),
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                    .padding(AppSpacing.small)
                    .background(Color.adaptiveSecondaryBackground)
                    .cornerRadius(AppCornerRadius.small)
                }
            }

            // Recurrence Toggle
            VStack(alignment: .leading, spacing: AppSpacing.small) {
                Toggle(isOn: $hasRecurrence) {
                    HStack(spacing: AppSpacing.xsmall) {
                        Image(systemName: "repeat")
                            .foregroundColor(.primaryBlue)
                        Text("Recurring Task")
                            .font(AppTypography.body)
                    }
                }
                .tint(.primaryBlue)

                if hasRecurrence {
                    Picker("Recurrence", selection: $recurrence) {
                        ForEach(RecurrenceType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
        }
        .padding(.horizontal, AppSpacing.small)
    }

    // MARK: - Tip Card
    private var tipCard: some View {
        HStack(spacing: AppSpacing.small) {
            Image(systemName: AppIcons.aiSuggestion)
                .font(.system(size: 24))
                .foregroundColor(.accentPurple)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("AI Tip")
                    .font(AppTypography.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                Text("Set priority and duration for better scheduling results")
                    .font(AppTypography.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
        .padding(AppSpacing.small)
        .background(Color.accentPurple.opacity(0.1))
        .cornerRadius(AppCornerRadius.small)
    }
    
    // MARK: - Actions

    /// Parse natural language input using NLP service
    private func parseNaturalLanguage() async {
        do {
            let response = try await nlpParser.parseTaskFromNaturalLanguage(naturalLanguageInput)
            parsedTasks = response.tasks
            showParsedResults = true
        } catch {
            print("Error parsing natural language: \(error.localizedDescription)")
        }
    }

    /// Create tasks from parsed natural language
    private func createTasksFromParsed() {
        for parsedTask in parsedTasks {
            // Determine how many instances to create
            let instanceCount = parsedTask.recurrence?.totalOccurrences ?? 1

            for i in 0..<instanceCount {
                createTaskInstance(from: parsedTask, instanceNumber: i, totalInstances: instanceCount)
            }
        }

        // Save all changes
        do {
            try modelContext.save()
        } catch {
            print("Error saving parsed tasks: \(error.localizedDescription)")
        }

        dismiss()
    }

    /// Create a single task instance from parsed attributes
    private func createTaskInstance(from parsed: ParsedTaskAttributes, instanceNumber: Int, totalInstances: Int) {
        // Calculate scheduled start/end if we have temporal constraints
        var scheduledStart: Date?
        var scheduledEnd: Date?
        var isFixed = false

        if let constraints = parsed.temporalConstraints {
            scheduledStart = calculateScheduledDate(
                constraints: constraints,
                instanceNumber: instanceNumber,
                totalInstances: totalInstances,
                preferredTime: parsed.preferredTimeOfDay
            )

            if let start = scheduledStart {
                scheduledEnd = start.addingTimeInterval(TimeInterval(parsed.durationMinutes * 60))
                // Mark as fixed if we calculated a specific date/time from temporal constraints
                // This ensures the AI scheduler respects constraints like "next weekend"
                isFixed = true
            }
        }

        // Create recurrence string for simple patterns
        var recurrenceString: String?
        if let recurrence = parsed.recurrence, totalInstances == 1 {
            // Only set recurrence for single-instance tasks with simple patterns
            switch recurrence.type {
            case "daily":
                recurrenceString = "Daily"
            case "weekly":
                recurrenceString = "Weekly"
            case "monthly":
                recurrenceString = "Monthly"
            default:
                recurrenceString = nil
            }
        }

        let newTask = TaskItem(
            title: totalInstances > 1 ? "\(parsed.title) (\(instanceNumber + 1)/\(totalInstances))" : parsed.title,
            details: parsed.description,
            durationMinutes: parsed.durationMinutes,
            priority: parsed.priority,
            scheduledStart: scheduledStart,
            scheduledEnd: scheduledEnd,
            isFixed: isFixed,
            recurrence: recurrenceString
        )

        modelContext.insert(newTask)
    }

    /// Calculate the scheduled date based on temporal constraints
    private func calculateScheduledDate(
        constraints: TemporalConstraints,
        instanceNumber: Int,
        totalInstances: Int,
        preferredTime: String?
    ) -> Date? {
        let calendar = Calendar.current
        let dateCalculator = TemporalDateCalculator()
        var targetDate: Date?

        // First, try to calculate dates using our date calculator
        let (startDate, endDate) = dateCalculator.calculateDates(from: constraints)
        targetDate = startDate

        // Fallback: Parse start date string if available and calculator didn't work
        if targetDate == nil, let startDateString = constraints.startDate {
            let formatter = ISO8601DateFormatter()
            targetDate = formatter.date(from: startDateString)
        }

        // If we need to create multiple instances, distribute them across the allowed period
        if totalInstances > 1, let start = targetDate {
            // Get the end date (use calculated endDate or parse from string)
            var periodEnd = endDate ?? start.addingTimeInterval(7 * 24 * 60 * 60) // Default to 1 week

            if periodEnd == nil, let endDateString = constraints.endDate {
                let formatter = ISO8601DateFormatter()
                periodEnd = formatter.date(from: endDateString) ?? start.addingTimeInterval(7 * 24 * 60 * 60)
            }

            // Calculate spacing between instances
            let totalDays = calendar.dateComponents([.day], from: start, to: periodEnd ?? start).day ?? 7
            let daysPerInstance = max(1, totalDays / totalInstances)

            // Calculate this instance's date
            targetDate = calendar.date(byAdding: .day, value: instanceNumber * daysPerInstance, to: start)

            // Adjust to allowed days of week if specified
            if let allowedDays = constraints.allowedDaysOfWeek, let date = targetDate {
                targetDate = findNearestAllowedDay(from: date, allowedDays: allowedDays, calendar: calendar)
            }
        }

        // Apply preferred time
        if let date = targetDate {
            if let preferredTimeString = constraints.preferredTime {
                // Parse HH:mm format
                let components = preferredTimeString.split(separator: ":")
                if components.count == 2,
                   let hour = Int(components[0]),
                   let minute = Int(components[1]) {
                    var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
                    dateComponents.hour = hour
                    dateComponents.minute = minute
                    targetDate = calendar.date(from: dateComponents)
                }
            } else if let timeRange = constraints.timeRange {
                // Use the start of the time range
                let components = timeRange.startTime.split(separator: ":")
                if components.count == 2,
                   let hour = Int(components[0]),
                   let minute = Int(components[1]) {
                    var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
                    dateComponents.hour = hour
                    dateComponents.minute = minute
                    targetDate = calendar.date(from: dateComponents)
                }
            }
        }

        return targetDate
    }

    /// Find the nearest allowed day of the week
    private func findNearestAllowedDay(from date: Date, allowedDays: [String], calendar: Calendar) -> Date {
        let dayNameToWeekday: [String: Int] = [
            "Sunday": 1, "Monday": 2, "Tuesday": 3, "Wednesday": 4,
            "Thursday": 5, "Friday": 6, "Saturday": 7
        ]

        let allowedWeekdays = allowedDays.compactMap { dayNameToWeekday[$0] }
        guard !allowedWeekdays.isEmpty else { return date }

        let currentWeekday = calendar.component(.weekday, from: date)

        // If current day is allowed, use it
        if allowedWeekdays.contains(currentWeekday) {
            return date
        }

        // Otherwise, find the next allowed day
        for offset in 1...7 {
            if let nextDate = calendar.date(byAdding: .day, value: offset, to: date) {
                let nextWeekday = calendar.component(.weekday, from: nextDate)
                if allowedWeekdays.contains(nextWeekday) {
                    return nextDate
                }
            }
        }

        return date
    }

    /// Save task from structured form
    private func saveTask() {
        let newTask = TaskItem(
            title: title,
            details: details.isEmpty ? nil : details,
            durationMinutes: durationMinutes,
            priority: priority,
            scheduledStart: isFixed ? fixedDate : nil,
            scheduledEnd: isFixed && fixedDate != nil ? fixedDate!.addingTimeInterval(TimeInterval(durationMinutes * 60)) : nil,
            isFixed: isFixed,
            recurrence: hasRecurrence ? recurrence.rawValue : nil
        )

        modelContext.insert(newTask)

        do {
            try modelContext.save()
        } catch {
            print("Error saving task: \(error.localizedDescription)")
        }

        dismiss()
    }
}

// MARK: - Recurrence Type
enum RecurrenceType: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}

#Preview {
    AddTaskView()
}
