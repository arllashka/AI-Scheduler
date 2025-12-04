//
//  SettingsView.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import SwiftUI

struct SettingsView: View {
    @State private var apiKey = ""
    @State private var showApiKeySheet = false
    @State private var notificationsEnabled = true
    @State private var workHoursStart = Date()
    @State private var workHoursEnd = Date()
    @State private var breakDuration = 60
    @State private var maxConsecutiveHours = 3
    
    var body: some View {
        NavigationStack {
            Form {
                // API Configuration
                Section {
                    Button {
                        showApiKeySheet = true
                    } label: {
                        HStack {
                            Image(systemName: "key.fill")
                                .foregroundColor(.primaryBlue)
                            Text("Gemini API Key")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.textTertiary)
                        }
                    }
                    .foregroundColor(.textPrimary)
                } header: {
                    Text("AI Configuration")
                } footer: {
                    Text("Configure your Gemini API key for AI-powered scheduling")
                }
                
                // Work Hours
                Section {
                    DatePicker(
                        "Start Time",
                        selection: $workHoursStart,
                        displayedComponents: .hourAndMinute
                    )
                    
                    DatePicker(
                        "End Time",
                        selection: $workHoursEnd,
                        displayedComponents: .hourAndMinute
                    )
                    
                    Stepper("Break Duration: \(breakDuration) min", value: $breakDuration, in: 0...120, step: 15)
                    
                    Stepper("Max Consecutive Hours: \(maxConsecutiveHours)", value: $maxConsecutiveHours, in: 1...8)
                } header: {
                    Text("Work Hours")
                } footer: {
                    Text("AI will schedule tasks within these hours")
                }
                
                // Notifications
                Section {
                    Toggle("Task Reminders", isOn: $notificationsEnabled)
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
                        // Clear all data
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
            .sheet(isPresented: $showApiKeySheet) {
                ApiKeySheet(apiKey: $apiKey)
            }
        }
    }
}

// MARK: - API Key Sheet
struct ApiKeySheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var apiKey: String
    @State private var inputKey = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.large) {
                // Header Icon
                Image(systemName: AppIcons.aiMagic)
                    .font(.system(size: 60))
                    .foregroundColor(.accentPurple)
                    .padding(.top, AppSpacing.xlarge)
                
                // Info Text
                VStack(spacing: AppSpacing.xsmall) {
                    Text("Gemini API Key")
                        .font(AppTypography.title2)
                        .foregroundColor(.textPrimary)
                    
                    Text("Enter your API key to enable AI-powered scheduling")
                        .font(AppTypography.body)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppSpacing.xlarge)
                }
                
                // Key Input
                VStack(alignment: .leading, spacing: AppSpacing.xsmall) {
                    Text("API Key")
                        .font(AppTypography.subheadline)
                        .foregroundColor(.textSecondary)
                    
                    SecureField("Enter your API key", text: $inputKey)
                        .textFieldStyle()
                        .padding(.horizontal, AppSpacing.medium)
                }
                .padding(.top, AppSpacing.large)
                
                // Instructions
                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    Text("How to get an API key:")
                        .font(AppTypography.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                    
                    InstructionRow(number: 1, text: "Visit Google AI Studio")
                    InstructionRow(number: 2, text: "Create a new API key")
                    InstructionRow(number: 3, text: "Copy and paste it here")
                    
                    Link("Open Google AI Studio →", destination: URL(string: "https://makersuite.google.com/app/apikey")!)
                        .font(AppTypography.callout)
                        .foregroundColor(.primaryBlue)
                        .padding(.top, AppSpacing.xsmall)
                }
                .padding(AppSpacing.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.adaptiveSecondaryBackground)
                .cornerRadius(AppCornerRadius.medium)
                .padding(.horizontal, AppSpacing.medium)
                
                Spacer()
                
                // Save Button
                PrimaryButton("Save API Key") {
                    apiKey = inputKey
                    dismiss()
                }
                .padding(.horizontal, AppSpacing.medium)
                .disabled(inputKey.isEmpty)
            }
            .navigationTitle("API Configuration")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct InstructionRow: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack(spacing: AppSpacing.small) {
            Text("\(number)")
                .font(AppTypography.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(Color.primaryBlue)
                .clipShape(Circle())
            
            Text(text)
                .font(AppTypography.callout)
                .foregroundColor(.textSecondary)
        }
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
