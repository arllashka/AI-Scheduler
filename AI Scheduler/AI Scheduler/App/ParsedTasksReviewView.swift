//
//  ParsedTasksReviewView.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 07.12.2025.
//

import SwiftUI

struct ParsedTasksReviewView: View {
    let parsedTasks: [ParsedTaskAttributes]
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.medium) {
                    // Header
                    VStack(spacing: AppSpacing.xsmall) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.primaryBlue)

                        Text("Tasks Parsed Successfully")
                            .font(AppTypography.title2)
                            .fontWeight(.bold)

                        Text("Review the tasks below and confirm to create them")
                            .font(AppTypography.body)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, AppSpacing.large)

                    // Task cards
                    ForEach(Array(parsedTasks.enumerated()), id: \.offset) { index, task in
                        ParsedTaskCard(task: task, index: index)
                    }

                    // Action buttons
                    HStack(spacing: AppSpacing.medium) {
                        Button(action: onCancel) {
                            Text("Cancel")
                                .font(AppTypography.body)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.adaptiveSecondaryBackground)
                                .foregroundColor(.textPrimary)
                                .cornerRadius(AppCornerRadius.medium)
                        }

                        Button(action: onConfirm) {
                            Text("Create \(parsedTasks.count) Task\(parsedTasks.count == 1 ? "" : "s")")
                                .font(AppTypography.body)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.primaryBlue)
                                .foregroundColor(.white)
                                .cornerRadius(AppCornerRadius.medium)
                        }
                    }
                    .padding(.top, AppSpacing.medium)
                }
                .padding(AppSpacing.medium)
            }
            .navigationTitle("Review Tasks")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ParsedTaskCard: View {
    let task: ParsedTaskAttributes
    let index: Int

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            // Task number and title
            HStack {
                Text("Task \(index + 1)")
                    .font(AppTypography.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, AppSpacing.small)
                    .padding(.vertical, 4)
                    .background(Color.primaryBlue)
                    .cornerRadius(AppCornerRadius.small)

                Spacer()

                // Priority badge
                HStack(spacing: 4) {
                    Image(systemName: "flag.fill")
                        .font(.caption)
                    Text("Priority \(task.priority)")
                        .font(AppTypography.caption)
                }
                .foregroundColor(priorityColor(task.priority))
            }

            // Title
            Text(task.title)
                .font(AppTypography.taskTitle)
                .fontWeight(.semibold)

            // Description
            if let description = task.description {
                Text(description)
                    .font(AppTypography.body)
                    .foregroundColor(.textSecondary)
            }

            Divider()

            // Details grid
            VStack(spacing: AppSpacing.xsmall) {
                DetailRow(icon: "clock", label: "Duration", value: "\(task.durationMinutes) min")

                if let recurrence = task.recurrence {
                    DetailRow(
                        icon: "repeat",
                        label: "Recurrence",
                        value: recurrence.explanation
                    )

                    if let totalOccurrences = recurrence.totalOccurrences, totalOccurrences > 1 {
                        DetailRow(
                            icon: "number",
                            label: "Instances",
                            value: "\(totalOccurrences) separate tasks will be created"
                        )
                    }
                }

                if let constraints = task.temporalConstraints {
                    if let explanation = constraints.explanation {
                        DetailRow(
                            icon: "calendar",
                            label: "When",
                            value: explanation
                        )
                    }

                    // Show actual calculated dates
                    if let dateString = formatStartDate(from: constraints) {
                        DetailRow(
                            icon: "calendar.badge.plus",
                            label: "Start Date",
                            value: dateString
                        )
                    }

                    if let allowedDays = constraints.allowedDaysOfWeek {
                        DetailRow(
                            icon: "calendar.badge.clock",
                            label: "Days",
                            value: allowedDays.joined(separator: ", ")
                        )
                    }

                    if let preferredTime = constraints.preferredTime {
                        DetailRow(
                            icon: "clock.fill",
                            label: "Time",
                            value: preferredTime
                        )
                    } else if let timeRange = constraints.timeRange {
                        DetailRow(
                            icon: "clock.fill",
                            label: "Time Range",
                            value: "\(timeRange.startTime) - \(timeRange.endTime)"
                        )
                    }
                }

                if let preferredTime = task.preferredTimeOfDay {
                    DetailRow(
                        icon: "sun.max",
                        label: "Time of Day",
                        value: preferredTime.capitalized
                    )
                }
            }
        }
        .padding(AppSpacing.medium)
        .background(Color.adaptiveSecondaryBackground)
        .cornerRadius(AppCornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                .stroke(Color.borderLight, lineWidth: 1)
        )
    }

    private func priorityColor(_ priority: Int) -> Color {
        switch priority {
        case 8...10: return .red
        case 6...7: return .orange
        case 4...5: return .blue
        default: return .gray
        }
    }

    private func formatStartDate(from constraints: TemporalConstraints) -> String? {
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .none

        // Try to parse the startDate string
        if let startDateString = constraints.startDate {
            let formatter = ISO8601DateFormatter()
            if let date = formatter.date(from: startDateString) {
                return displayFormatter.string(from: date)
            }
        }

        // Fallback: use TemporalDateCalculator
        let calculator = TemporalDateCalculator()
        let (start, _) = calculator.calculateDates(from: constraints)
        if let start = start {
            return displayFormatter.string(from: start)
        }

        return nil
    }
}

struct DetailRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.small) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.primaryBlue)
                .frame(width: 20)

            Text(label + ":")
                .font(AppTypography.caption)
                .foregroundColor(.textSecondary)
                .frame(width: 80, alignment: .leading)

            Text(value)
                .font(AppTypography.caption)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ParsedTasksReviewView(
        parsedTasks: [
            ParsedTaskAttributes(
                title: "Go to gym",
                description: "Weekly gym session",
                durationMinutes: 60,
                priority: 5,
                recurrence: RecurrencePattern(
                    type: "custom",
                    frequency: 3,
                    specificDays: nil,
                    totalOccurrences: 3,
                    explanation: "3 times during next week"
                ),
                temporalConstraints: TemporalConstraints(
                    startDate: "2024-12-09T00:00:00Z",
                    endDate: "2024-12-15T23:59:59Z",
                    allowedDaysOfWeek: nil,
                    preferredTime: "12:00",
                    timeRange: nil,
                    explanation: "Next week at noon"
                ),
                preferredTimeOfDay: "noon"
            )
        ],
        onConfirm: {},
        onCancel: {}
    )
}
