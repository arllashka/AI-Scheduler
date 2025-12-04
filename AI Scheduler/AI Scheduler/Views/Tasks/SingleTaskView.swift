//
//  SingleTaskView.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import SwiftUI
import SwiftData

struct SingleTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Bindable var task: TaskItem

    @State private var isEditing = false
    @State private var showDeleteConfirmation = false

    // Edit state
    @State private var editedTitle: String = ""
    @State private var editedDetails: String = ""
    @State private var editedDuration: Int = 60
    @State private var editedPriority: Int = 5
    @State private var editedIsFixed: Bool = false
    @State private var editedFixedDate: Date?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.large) {
                    // Status Section
                    statusSection

                    if isEditing {
                        // Edit Mode
                        editSection
                    } else {
                        // View Mode
                        detailsSection

                        // Schedule Info
                        if task.scheduledStart != nil {
                            scheduleSection
                        }

                        // Description
                        if let details = task.details, !details.isEmpty {
                            descriptionSection
                        }

                        // Metadata
                        metadataSection
                    }

                    // Actions
                    if !isEditing {
                        actionsSection
                    }
                }
                .padding(AppSpacing.medium)
            }
            .navigationTitle(isEditing ? "Edit Task" : "Task Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(isEditing ? "Cancel" : "Close") {
                        if isEditing {
                            cancelEditing()
                        } else {
                            dismiss()
                        }
                    }
                    .foregroundColor(.textSecondary)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    if isEditing {
                        Button("Save") {
                            saveChanges()
                        }
                        .foregroundColor(.primaryBlue)
                        .fontWeight(.semibold)
                        .disabled(editedTitle.isEmpty)
                    } else {
                        Button("Edit") {
                            startEditing()
                        }
                        .foregroundColor(.primaryBlue)
                        .fontWeight(.semibold)
                    }
                }
            }
            .alert("Delete Task", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteTask()
                }
            } message: {
                Text("Are you sure you want to delete this task? This action cannot be undone.")
            }
        }
    }

    // MARK: - Status Section

    private var statusSection: some View {
        HStack(spacing: AppSpacing.medium) {
            // Completion Toggle
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    task.isCompleted.toggle()
                    task.updatedAt = Date()
                    try? modelContext.save()
                }

                // Haptic feedback
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            } label: {
                ZStack {
                    Circle()
                        .strokeBorder(task.isCompleted ? Color.accentGreen : Color.textTertiary, lineWidth: 3)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(task.isCompleted ? Color.accentGreen.opacity(0.2) : Color.clear)
                        )

                    if task.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.accentGreen)
                    }
                }
            }

            VStack(alignment: .leading, spacing: AppSpacing.xxsmall) {
                Text(task.isCompleted ? "Completed" : "In Progress")
                    .font(AppTypography.title3)
                    .foregroundColor(task.isCompleted ? .accentGreen : .primaryBlue)

                Text(task.isCompleted ? "Great job!" : "Tap circle to mark as complete")
                    .font(AppTypography.caption)
                    .foregroundColor(.textSecondary)
            }

            Spacer()

            // Priority Badge
            priorityBadge
        }
        .padding(AppSpacing.medium)
        .background(Color.adaptiveSecondaryBackground)
        .cornerRadius(AppCornerRadius.medium)
    }

    private var priorityBadge: some View {
        let (label, color) = priorityInfo(task.priority)

        return HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)

            Text(label)
                .font(AppTypography.caption)
                .foregroundColor(.textSecondary)
        }
        .padding(.horizontal, AppSpacing.small)
        .padding(.vertical, AppSpacing.xxsmall)
        .background(color.opacity(0.1))
        .cornerRadius(AppCornerRadius.small)
    }

    private func priorityInfo(_ priority: Int) -> (String, Color) {
        switch priority {
        case 1...3: return ("Low", .priorityLow)
        case 4...6: return ("Medium", .priorityMedium)
        case 7...9: return ("High", .priorityHigh)
        default: return ("Critical", .priorityCritical)
        }
    }

    // MARK: - Details Section

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text(task.title)
                .font(AppTypography.title2)
                .foregroundColor(.textPrimary)

            HStack(spacing: AppSpacing.medium) {
                Label(formatDuration(task.durationMinutes), systemImage: AppIcons.clock)
                    .font(AppTypography.body)
                    .foregroundColor(.textSecondary)

                if task.isFixed {
                    Label("Fixed Time", systemImage: AppIcons.alarm)
                        .font(AppTypography.body)
                        .foregroundColor(.accentPurple)
                }

                if task.recurrence != nil {
                    Label("Recurring", systemImage: "repeat")
                        .font(AppTypography.body)
                        .foregroundColor(.accentPurple)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.medium)
        .background(Color.adaptiveSecondaryBackground)
        .cornerRadius(AppCornerRadius.medium)
    }

    // MARK: - Schedule Section

    private var scheduleSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            HStack {
                Image(systemName: AppIcons.schedule)
                    .foregroundColor(.primaryBlue)
                Text("Schedule")
                    .font(AppTypography.title3)
                    .foregroundColor(.textPrimary)
            }

            Divider()

            if let start = task.scheduledStart, let end = task.scheduledEnd {
                VStack(alignment: .leading, spacing: AppSpacing.xsmall) {
                    HStack {
                        Text("Start:")
                            .font(AppTypography.body)
                            .foregroundColor(.textSecondary)
                        Spacer()
                        Text(formatFullDateTime(start))
                            .font(AppTypography.body)
                            .foregroundColor(.textPrimary)
                    }

                    HStack {
                        Text("End:")
                            .font(AppTypography.body)
                            .foregroundColor(.textSecondary)
                        Spacer()
                        Text(formatFullDateTime(end))
                            .font(AppTypography.body)
                            .foregroundColor(.textPrimary)
                    }
                }
            }
        }
        .padding(AppSpacing.medium)
        .background(Color.adaptiveSecondaryBackground)
        .cornerRadius(AppCornerRadius.medium)
    }

    // MARK: - Description Section

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            HStack {
                Image(systemName: "text.alignleft")
                    .foregroundColor(.primaryBlue)
                Text("Description")
                    .font(AppTypography.title3)
                    .foregroundColor(.textPrimary)
            }

            Divider()

            Text(task.details ?? "")
                .font(AppTypography.body)
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
        }
        .padding(AppSpacing.medium)
        .background(Color.adaptiveSecondaryBackground)
        .cornerRadius(AppCornerRadius.medium)
    }

    // MARK: - Metadata Section

    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(.primaryBlue)
                Text("Details")
                    .font(AppTypography.title3)
                    .foregroundColor(.textPrimary)
            }

            Divider()

            VStack(spacing: AppSpacing.xsmall) {
                HStack {
                    Text("Created:")
                        .font(AppTypography.body)
                        .foregroundColor(.textSecondary)
                    Spacer()
                    Text(formatRelativeDate(task.createdAt))
                        .font(AppTypography.body)
                        .foregroundColor(.textPrimary)
                }

                HStack {
                    Text("Last Updated:")
                        .font(AppTypography.body)
                        .foregroundColor(.textSecondary)
                    Spacer()
                    Text(formatRelativeDate(task.updatedAt))
                        .font(AppTypography.body)
                        .foregroundColor(.textPrimary)
                }
            }
        }
        .padding(AppSpacing.medium)
        .background(Color.adaptiveSecondaryBackground)
        .cornerRadius(AppCornerRadius.medium)
    }

    // MARK: - Edit Section

    private var editSection: some View {
        VStack(spacing: AppSpacing.large) {
            // Title
            VStack(alignment: .leading, spacing: AppSpacing.xsmall) {
                Text("Task Title")
                    .font(AppTypography.subheadline)
                    .foregroundColor(.textSecondary)

                CustomTextField(
                    placeholder: "Enter task title",
                    icon: AppIcons.tasks,
                    text: $editedTitle
                )
            }

            // Details
            VStack(alignment: .leading, spacing: AppSpacing.xsmall) {
                Text("Details (Optional)")
                    .font(AppTypography.subheadline)
                    .foregroundColor(.textSecondary)

                TextEditor(text: $editedDetails)
                    .frame(height: 100)
                    .padding(AppSpacing.xxsmall)
                    .background(Color.adaptiveSecondaryBackground)
                    .cornerRadius(AppCornerRadius.small)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppCornerRadius.small)
                            .stroke(Color.borderLight, lineWidth: 1)
                    )
            }

            // Duration
            DurationPicker(durationMinutes: $editedDuration)

            // Priority
            PriorityPicker(priority: $editedPriority)

            // Fixed Time Toggle
            VStack(alignment: .leading, spacing: AppSpacing.small) {
                Toggle(isOn: $editedIsFixed) {
                    HStack(spacing: AppSpacing.xsmall) {
                        Image(systemName: AppIcons.alarm)
                            .foregroundColor(.primaryBlue)
                        Text("Fixed Time Slot")
                            .font(AppTypography.body)
                    }
                }
                .tint(.primaryBlue)

                if editedIsFixed {
                    DatePicker(
                        "Select Time",
                        selection: Binding(
                            get: { editedFixedDate ?? Date() },
                            set: { editedFixedDate = $0 }
                        ),
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                    .padding(AppSpacing.small)
                    .background(Color.adaptiveSecondaryBackground)
                    .cornerRadius(AppCornerRadius.small)
                }
            }
        }
    }

    // MARK: - Actions Section

    private var actionsSection: some View {
        VStack(spacing: AppSpacing.small) {
            // Clear Schedule Button (if scheduled)
            if task.scheduledStart != nil {
                Button {
                    clearSchedule()
                } label: {
                    HStack {
                        Image(systemName: "calendar.badge.minus")
                        Text("Clear Schedule")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.small)
                    .font(AppTypography.buttonLabel)
                    .foregroundColor(.primaryBlue)
                    .background(Color.primaryBlue.opacity(0.1))
                    .cornerRadius(AppCornerRadius.medium)
                }
            }

            // Delete Button
            Button {
                showDeleteConfirmation = true
            } label: {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete Task")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.small)
                .font(AppTypography.buttonLabel)
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(AppCornerRadius.medium)
            }
        }
        .padding(.top, AppSpacing.medium)
    }

    // MARK: - Actions

    private func startEditing() {
        editedTitle = task.title
        editedDetails = task.details ?? ""
        editedDuration = task.durationMinutes
        editedPriority = task.priority
        editedIsFixed = task.isFixed
        editedFixedDate = task.scheduledStart
        isEditing = true
    }

    private func cancelEditing() {
        isEditing = false
    }

    private func saveChanges() {
        task.title = editedTitle
        task.details = editedDetails.isEmpty ? nil : editedDetails
        task.durationMinutes = editedDuration
        task.priority = editedPriority
        task.isFixed = editedIsFixed

        if editedIsFixed, let fixedDate = editedFixedDate {
            task.scheduledStart = fixedDate
            task.scheduledEnd = fixedDate.addingTimeInterval(TimeInterval(editedDuration * 60))
        } else if !editedIsFixed && task.isFixed {
            // Changed from fixed to flexible, clear schedule
            task.scheduledStart = nil
            task.scheduledEnd = nil
        }

        task.updatedAt = Date()

        do {
            try modelContext.save()
            isEditing = false
        } catch {
            print("Error saving task: \(error.localizedDescription)")
        }
    }

    private func clearSchedule() {
        withAnimation {
            task.scheduledStart = nil
            task.scheduledEnd = nil
            task.isFixed = false
            task.updatedAt = Date()
            try? modelContext.save()
        }
    }

    private func deleteTask() {
        modelContext.delete(task)
        try? modelContext.save()
        dismiss()
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

    private func formatFullDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func formatRelativeDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TaskItem.self, configurations: config)

    let task = TaskItem(
        title: "Complete project proposal",
        details: "Need to finish the Q4 project proposal including budget estimates and timeline.",
        durationMinutes: 120,
        priority: 8,
        scheduledStart: Date(),
        scheduledEnd: Date().addingTimeInterval(7200)
    )

    container.mainContext.insert(task)

    return SingleTaskView(task: task)
        .modelContainer(container)
}
