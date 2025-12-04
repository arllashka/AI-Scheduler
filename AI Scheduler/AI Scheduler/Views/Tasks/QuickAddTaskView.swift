//
//  QuickAddTaskView.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import SwiftUI
import SwiftData

struct QuickAddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let scheduledDate: Date
    
    @State private var title = ""
    @State private var durationMinutes = 60
    @State private var priority = 5
    @State private var scheduledTime = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Task Title", text: $title)
                        .font(AppTypography.body)
                } header: {
                    Text("Task Details")
                }
                
                Section {
                    DatePicker(
                        "Time",
                        selection: $scheduledTime,
                        displayedComponents: .hourAndMinute
                    )
                    
                    Picker("Duration", selection: $durationMinutes) {
                        Text("15 min").tag(15)
                        Text("30 min").tag(30)
                        Text("45 min").tag(45)
                        Text("1 hour").tag(60)
                        Text("1.5 hours").tag(90)
                        Text("2 hours").tag(120)
                        Text("3 hours").tag(180)
                        Text("4 hours").tag(240)
                    }
                } header: {
                    Text("Schedule for \(formattedDate)")
                }
                
                Section {
                    Picker("Priority", selection: $priority) {
                        Text("Low (1-3)").tag(2)
                        Text("Medium (4-6)").tag(5)
                        Text("High (7-9)").tag(8)
                        Text("Critical (10)").tag(10)
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Priority")
                }
                
                Section {
                    HStack {
                        Image(systemName: AppIcons.aiSuggestion)
                            .foregroundColor(.accentPurple)
                        Text("Task will be scheduled for \(formattedDate) at \(formattedTime)")
                            .font(AppTypography.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            .navigationTitle("Quick Add Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        saveTask()
                    }
                    .fontWeight(.semibold)
                    .disabled(title.isEmpty)
                }
            }
            .onAppear {
                // Set the scheduled time to the selected date
                let calendar = Calendar.current
                var components = calendar.dateComponents([.year, .month, .day], from: scheduledDate)
                
                // Set time to next available hour or 9 AM if past
                let currentHour = calendar.component(.hour, from: Date())
                if calendar.isDateInToday(scheduledDate) && currentHour < 20 {
                    components.hour = currentHour + 1
                } else {
                    components.hour = 9
                }
                components.minute = 0
                
                scheduledTime = calendar.date(from: components) ?? scheduledDate
            }
        }
    }
    
    // MARK: - Computed Properties
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: scheduledDate)
    }
    
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: scheduledTime)
    }
    
    // MARK: - Actions
    private func saveTask() {
        // Combine the selected date with the chosen time
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: scheduledDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: scheduledTime)
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        
        guard let finalStartDate = calendar.date(from: components) else {
            return
        }
        
        let finalEndDate = finalStartDate.addingTimeInterval(TimeInterval(durationMinutes * 60))
        
        // Create new task
        let newTask = TaskItem(
            title: title,
            details: nil,
            durationMinutes: durationMinutes,
            priority: priority,
            scheduledStart: finalStartDate,
            scheduledEnd: finalEndDate,
            isFixed: true
        )
        
        // Save to database
        modelContext.insert(newTask)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error saving task: \(error.localizedDescription)")
        }
    }
}

#Preview {
    QuickAddTaskView(scheduledDate: Date())
        .modelContainer(for: TaskItem.self, inMemory: true)
}
