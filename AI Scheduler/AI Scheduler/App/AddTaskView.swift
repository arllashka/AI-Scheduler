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
                    Button("Save") {
                        saveTask()
                    }
                    .foregroundColor(.primaryBlue)
                    .fontWeight(.semibold)
                    .disabled(title.isEmpty)
                }
            }
        }
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
