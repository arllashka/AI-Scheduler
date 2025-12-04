//
//  SettingsView.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var userPreferences = UserPreferences.shared
    
    @State private var showingReloadConfirmation = false
    @State private var showingClearConfirmation = false
    @State private var workHoursStartDate = Date()
    @State private var workHoursEndDate = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                // Work Hours
                Section {
                    DatePicker(
                        "Start Time",
                        selection: $workHoursStartDate,
                        displayedComponents: .hourAndMinute
                    )
                    .onChange(of: workHoursStartDate) { _, newValue in
                        userPreferences.workHoursStart = formatTimeString(from: newValue)
                    }
                    
                    DatePicker(
                        "End Time",
                        selection: $workHoursEndDate,
                        displayedComponents: .hourAndMinute
                    )
                    .onChange(of: workHoursEndDate) { _, newValue in
                        userPreferences.workHoursEnd = formatTimeString(from: newValue)
                    }
                    
                    Stepper("Break Duration: \(userPreferences.breakDuration) min", value: $userPreferences.breakDuration, in: 0...120, step: 15)
                    
                    Stepper("Max Consecutive Hours: \(userPreferences.maxConsecutiveHours)", value: $userPreferences.maxConsecutiveHours, in: 1...8)
                } header: {
                    Text("Work Hours")
                } footer: {
                    Text("AI will schedule tasks within these hours")
                }
                
                // Notifications
                Section {
                    Toggle("Task Reminders", isOn: $userPreferences.notificationsEnabled)
                } header: {
                    Text("Notifications")
                }
                
                // Appearance
                Section {
                    NavigationLink {
                        AppearanceSettingsView()
                    } label: {
                        Label("Appearance", systemImage: "paintbrush.fill")
                    }
                } header: {
                    Text("Display")
                }
                
                // Data Management
                Section {
                    Button {
                        // Export data
                    } label: {
                        Label("Export Data", systemImage: "square.and.arrow.up")
                    }
                    
                    Button {
                        // Import data
                    } label: {
                        Label("Import Data", systemImage: "square.and.arrow.down")
                    }
                    
                    Button(role: .destructive) {
                        showingClearConfirmation = true
                    } label: {
                        Label("Clear All Data", systemImage: "trash.fill")
                    }
                } header: {
                    Text("Data")
                }
                
                // About
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.textSecondary)
                    }
                    
                    NavigationLink {
                        AboutView()
                    } label: {
                        Label("About", systemImage: "info.circle")
                    }
                    
                    Link(destination: URL(string: "https://github.com")!) {
                        Label("GitHub", systemImage: "link")
                    }
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                loadWorkHours()
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func loadWorkHours() {
        workHoursStartDate = parseTimeString(userPreferences.workHoursStart) ?? Date()
        workHoursEndDate = parseTimeString(userPreferences.workHoursEnd) ?? Date()
    }
    
    private func parseTimeString(_ timeString: String) -> Date? {
        let components = timeString.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else {
            return nil
        }
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        return Calendar.current.date(from: dateComponents)
    }
    
    private func formatTimeString(from date: Date) -> String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        guard let hour = components.hour, let minute = components.minute else {
            return "09:00"
        }
        return String(format: "%02d:%02d", hour, minute)
    }
}

// MARK: - Appearance Settings
struct AppearanceSettingsView: View {
    @State private var selectedTheme: ThemeMode = .system
    
    var body: some View {
        Form {
            Section {
                Picker("Theme", selection: $selectedTheme) {
                    ForEach(ThemeMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.inline)
            } header: {
                Text("Color Scheme")
            }
            
            Section {
                ColorRow(title: "Primary Blue", color: .primaryBlue)
                ColorRow(title: "Accent Purple", color: .accentPurple)
                ColorRow(title: "Success Green", color: .accentGreen)
                ColorRow(title: "Warning Orange", color: .accentOrange)
                ColorRow(title: "Error Red", color: .accentRed)
            } header: {
                Text("Color Palette")
            }
        }
        .navigationTitle("Appearance")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ColorRow: View {
    let title: String
    let color: Color
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 32, height: 32)
            
            Text(title)
            
            Spacer()
        }
    }
}

enum ThemeMode: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
}

// MARK: - About View
struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xlarge) {
                // App Icon
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 80))
                    .foregroundColor(.primaryBlue)
                    .padding(.top, AppSpacing.xlarge)
                
                // App Info
                VStack(spacing: AppSpacing.xsmall) {
                    Text("AI Scheduler")
                        .font(AppTypography.largeTitle)
                        .foregroundColor(.textPrimary)
                    
                    Text("Version 1.0.0")
                        .font(AppTypography.callout)
                        .foregroundColor(.textSecondary)
                    
                    AIBadge()
                        .padding(.top, AppSpacing.xsmall)
                }
                
                // Description
                Text("Intelligent task scheduling powered by Google's Gemini AI. Optimize your day with smart time management.")
                    .font(AppTypography.body)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.xlarge)
                
                // Features
                VStack(spacing: AppSpacing.small) {
                    FeatureRow(icon: AppIcons.aiSchedule, title: "AI-Powered Scheduling", description: "Let AI organize your tasks intelligently")
                    FeatureRow(icon: AppIcons.priority, title: "Priority-Based", description: "Important tasks get scheduled first")
                    FeatureRow(icon: AppIcons.calendar, title: "Smart Calendar", description: "Visual timeline of your day")
                }
                .padding(AppSpacing.medium)
                .background(Color.adaptiveSecondaryBackground)
                .cornerRadius(AppCornerRadius.medium)
                .padding(.horizontal, AppSpacing.medium)
                
                // Credits
                VStack(spacing: AppSpacing.xsmall) {
                    Text("Created by Arlan Kalin")
                        .font(AppTypography.callout)
                        .foregroundColor(.textSecondary)
                    
                    Text("Powered by Google Gemini")
                        .font(AppTypography.caption)
                        .foregroundColor(.textTertiary)
                }
                
                Spacer()
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: AppSpacing.small) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.primaryBlue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppTypography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                Text(description)
                    .font(AppTypography.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
    }
}

#Preview("Settings") {
    SettingsView()
}

#Preview("About") {
    NavigationStack {
        AboutView()
    }
}
