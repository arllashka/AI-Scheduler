//
//  UserPreferences.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import Foundation
import SwiftUI
import Combine

/// Manages user preferences for scheduling
@MainActor
final class UserPreferences: ObservableObject {
    
    // MARK: - Published Properties
    
    @AppStorage("gemini_api_key") var apiKey: String = ""
    @AppStorage("work_hours_start") var workHoursStart: String = "09:00"
    @AppStorage("work_hours_end") var workHoursEnd: String = "17:00"
    @AppStorage("break_duration") var breakDuration: Int = 60
    @AppStorage("max_consecutive_hours") var maxConsecutiveHours: Int = 3
    @AppStorage("notifications_enabled") var notificationsEnabled: Bool = true
    @AppStorage("onboarding_completed") var onboardingCompleted: Bool = false
    
    // MARK: - Singleton
    
    static let shared = UserPreferences()
    
    private init() {}
    
    // MARK: - Computed Properties
    
    /// Check if API key is configured
    var hasAPIKey: Bool {
        !apiKey.isEmpty
    }
    
    /// Get time constraints for scheduling
    var timeConstraints: TimeConstraints {
        TimeConstraints(
            workHoursStart: workHoursStart,
            workHoursEnd: workHoursEnd,
            breakDuration: breakDuration,
            maxConsecutiveHours: maxConsecutiveHours,
            timezone: TimeZone.current.identifier
        )
    }
    
    // MARK: - Methods
    
    /// Update API key and save to APIConfiguration
    func updateAPIKey(_ key: String) {
        apiKey = key
        // Update APIConfiguration as well
        // Note: APIConfiguration.apiKey is computed, so we need to update the source
    }
    
    /// Reset all preferences to defaults
    func resetToDefaults() {
        workHoursStart = "09:00"
        workHoursEnd = "17:00"
        breakDuration = 60
        maxConsecutiveHours = 3
        notificationsEnabled = true
    }
}
