//
//  UIComponents.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import SwiftUI

// MARK: - Primary Button
struct PrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false
    
    init(
        _ title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.xsmall) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.small)
            .font(AppTypography.buttonLabel)
            .foregroundColor(.white)
            .background(isDisabled ? Color.textTertiary : Color.primaryBlue)
            .cornerRadius(AppCornerRadius.medium)
        }
        .disabled(isDisabled || isLoading)
    }
}

// MARK: - Secondary Button
struct SecondaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var isDisabled: Bool = false
    
    init(
        _ title: String,
        icon: String? = nil,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.xsmall) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.small)
            .font(AppTypography.buttonLabel)
            .foregroundColor(isDisabled ? .textTertiary : .primaryBlue)
            .background(Color.primaryBlue.opacity(0.1))
            .cornerRadius(AppCornerRadius.medium)
        }
        .disabled(isDisabled)
    }
}

// MARK: - Icon Button
struct IconButton: View {
    let icon: String
    let action: () -> Void
    var size: CGFloat = 44
    var color: Color = .primaryBlue
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size * 0.5, weight: .medium))
                .foregroundColor(color)
                .frame(width: size, height: size)
                .background(color.opacity(0.1))
                .clipShape(Circle())
        }
    }
}

// MARK: - Task Card
struct TaskCard: View {
    let title: String
    let duration: String
    let priority: Int
    let isCompleted: Bool
    let scheduledTime: String?
    let onTap: () -> Void
    let onComplete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppSpacing.small) {
                // Completion Button
                Button(action: onComplete) {
                    Image(systemName: isCompleted ? AppIcons.complete : AppIcons.incomplete)
                        .font(.system(size: 24))
                        .foregroundColor(isCompleted ? .accentGreen : .textTertiary)
                }
                .buttonStyle(PlainButtonStyle())
                
                VStack(alignment: .leading, spacing: AppSpacing.xxsmall) {
                    // Title
                    Text(title)
                        .font(AppTypography.taskTitle)
                        .foregroundColor(.textPrimary)
                        .lineLimit(2)
                    
                    // Duration & Time
                    HStack(spacing: AppSpacing.small) {
                        Label(duration, systemImage: AppIcons.clock)
                            .font(AppTypography.caption)
                            .foregroundColor(.textSecondary)
                        
                        if let scheduledTime = scheduledTime {
                            Text("•")
                                .foregroundColor(.textTertiary)
                            Text(scheduledTime)
                                .font(AppTypography.caption)
                                .foregroundColor(.primaryBlue)
                        }
                    }
                }
                
                Spacer()
                
                // Priority Indicator
                priorityIndicator(priority)
            }
            .padding(AppSpacing.small)
            .background(Color.adaptiveSecondaryBackground)
            .cornerRadius(AppCornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .stroke(Color.borderLight, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    private func priorityIndicator(_ priority: Int) -> some View {
        let color: Color = {
            switch priority {
            case 1...3: return .priorityLow
            case 4...6: return .priorityMedium
            case 7...9: return .priorityHigh
            default: return .priorityCritical
            }
        }()
        
        Circle()
            .fill(color)
            .frame(width: 8, height: 8)
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.large) {
            Image(systemName: icon)
                .font(.system(size: 80))
                .foregroundColor(.textTertiary)
            
            VStack(spacing: AppSpacing.xsmall) {
                Text(title)
                    .font(AppTypography.title2)
                    .foregroundColor(.textPrimary)
                
                Text(message)
                    .font(AppTypography.body)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.xlarge)
            }
            
            if let actionTitle = actionTitle, let action = action {
                PrimaryButton(actionTitle, icon: AppIcons.add, action: action)
                    .padding(.horizontal, AppSpacing.xlarge)
                    .padding(.top, AppSpacing.small)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.adaptiveBackground)
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(
        _ title: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppTypography.title3)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(AppTypography.callout)
                        .foregroundColor(.primaryBlue)
                }
            }
        }
        .padding(.horizontal, AppSpacing.medium)
        .padding(.vertical, AppSpacing.xsmall)
    }
}

// MARK: - Custom Text Field
struct CustomTextField: View {
    let placeholder: String
    let icon: String?
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: AppSpacing.small) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(.textSecondary)
            }
            
            TextField(placeholder, text: $text)
                .font(AppTypography.body)
        }
        .padding(AppSpacing.small)
        .background(Color.adaptiveSecondaryBackground)
        .cornerRadius(AppCornerRadius.small)
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.small)
                .stroke(Color.borderLight, lineWidth: 1)
        )
    }
}

// MARK: - Priority Picker
struct PriorityPicker: View {
    @Binding var priority: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xsmall) {
            Text("Priority")
                .font(AppTypography.subheadline)
                .foregroundColor(.textSecondary)
            
            HStack(spacing: AppSpacing.xsmall) {
                ForEach(1...10, id: \.self) { level in
                    PriorityButton(
                        level: level,
                        isSelected: priority == level
                    ) {
                        priority = level
                    }
                }
            }
        }
    }
}

struct PriorityButton: View {
    let level: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(level)")
                .font(AppTypography.footnote)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? .white : .textPrimary)
                .frame(width: 32, height: 32)
                .background(isSelected ? priorityColor : Color.backgroundTertiary)
                .clipShape(Circle())
        }
    }
    
    var priorityColor: Color {
        switch level {
        case 1...3: return .priorityLow
        case 4...6: return .priorityMedium
        case 7...9: return .priorityHigh
        default: return .priorityCritical
        }
    }
}

// MARK: - Duration Picker
struct DurationPicker: View {
    @Binding var durationMinutes: Int
    
    let durations = [15, 30, 45, 60, 90, 120, 180, 240]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xsmall) {
            Text("Duration")
                .font(AppTypography.subheadline)
                .foregroundColor(.textSecondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.xsmall) {
                    ForEach(durations, id: \.self) { duration in
                        DurationButton(
                            duration: duration,
                            isSelected: durationMinutes == duration
                        ) {
                            durationMinutes = duration
                        }
                    }
                }
            }
        }
    }
}

struct DurationButton: View {
    let duration: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Text(durationText)
                    .font(AppTypography.footnote)
                    .fontWeight(isSelected ? .bold : .regular)
                Text(unitText)
                    .font(AppTypography.caption2)
            }
            .foregroundColor(isSelected ? .white : .textPrimary)
            .padding(.horizontal, AppSpacing.small)
            .padding(.vertical, AppSpacing.xxsmall)
            .background(isSelected ? Color.primaryBlue : Color.backgroundTertiary)
            .cornerRadius(AppCornerRadius.small)
        }
    }
    
    var durationText: String {
        if duration >= 60 {
            return "\(duration / 60)"
        }
        return "\(duration)"
    }
    
    var unitText: String {
        if duration >= 60 {
            return duration == 60 ? "hour" : "hours"
        }
        return "min"
    }
}

// MARK: - Loading Overlay
struct LoadingOverlay: View {
    let message: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: AppSpacing.medium) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                
                Text(message)
                    .font(AppTypography.callout)
                    .foregroundColor(.white)
            }
            .padding(AppSpacing.xlarge)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.large)
                    .fill(Color.black.opacity(0.8))
            )
        }
    }
}

// MARK: - AI Badge
struct AIBadge: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: AppIcons.aiSchedule)
                .font(.system(size: 12, weight: .bold))
            Text("AI")
                .font(.system(size: 12, weight: .bold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            LinearGradient(
                colors: [.primaryBlue, .accentPurple],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(AppCornerRadius.small)
    }
}

// MARK: - Stats Card
struct StatsCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: AppSpacing.xsmall) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(AppTypography.title2)
                .foregroundColor(.textPrimary)
            
            Text(label)
                .font(AppTypography.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.medium)
        .background(Color.adaptiveSecondaryBackground)
        .cornerRadius(AppCornerRadius.medium)
    }
}

// MARK: - Preview Provider
#Preview("Buttons") {
    VStack(spacing: 20) {
        PrimaryButton("Schedule Tasks", icon: AppIcons.aiSchedule) {}
        SecondaryButton("Cancel", icon: AppIcons.close) {}
        IconButton(icon: AppIcons.add) {}
    }
    .padding()
}

#Preview("Task Card") {
    TaskCard(
        title: "Complete project proposal",
        duration: "2 hours",
        priority: 8,
        isCompleted: false,
        scheduledTime: "9:00 AM"
    ) {
        print("Task tapped")
    } onComplete: {
        print("Complete tapped")
    }
    .padding()
}

#Preview("Empty State") {
    EmptyStateView(
        icon: "calendar.badge.plus",
        title: "No Tasks Yet",
        message: "Add your first task to get started with AI-powered scheduling",
        actionTitle: "Add Task"
    ) {
        print("Add task")
    }
}
