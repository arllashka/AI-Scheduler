//
//  DesignSystem.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import SwiftUI

// MARK: - Colors
extension Color {
    // MARK: Primary Colors
    static let primaryBlue = Color(hex: "3B82F6") // Main brand color
    static let primaryBlueLight = Color(hex: "60A5FA") // Lighter variant
    static let primaryBlueDark = Color(hex: "2563EB") // Darker variant
    
    // MARK: Accent Colors
    static let accentPurple = Color(hex: "8B5CF6") // For AI/Intelligence features
    static let accentGreen = Color(hex: "10B981") // For success/completed tasks
    static let accentOrange = Color(hex: "F59E0B") // For warnings/medium priority
    static let accentRed = Color(hex: "EF4444") // For errors/high priority
    
    // MARK: Background Colors
    static let backgroundPrimary = Color(hex: "FFFFFF") // Main background
    static let backgroundSecondary = Color(hex: "F9FAFB") // Card backgrounds
    static let backgroundTertiary = Color(hex: "F3F4F6") // Subtle sections
    
    // MARK: Dark Mode Backgrounds
    static let darkBackgroundPrimary = Color(hex: "111827")
    static let darkBackgroundSecondary = Color(hex: "1F2937")
    static let darkBackgroundTertiary = Color(hex: "374151")
    
    // MARK: Text Colors
    static let textPrimary = Color(hex: "111827") // Main text
    static let textSecondary = Color(hex: "6B7280") // Secondary text
    static let textTertiary = Color(hex: "9CA3AF") // Tertiary/disabled text
    
    // MARK: Border Colors
    static let borderLight = Color(hex: "E5E7EB")
    static let borderMedium = Color(hex: "D1D5DB")
    static let borderDark = Color(hex: "9CA3AF")
    
    // MARK: Priority Colors
    static let priorityLow = Color(hex: "10B981") // Green
    static let priorityMedium = Color(hex: "F59E0B") // Orange
    static let priorityHigh = Color(hex: "EF4444") // Red
    static let priorityCritical = Color(hex: "DC2626") // Dark Red
    
    // MARK: Calendar Colors
    static let calendarToday = Color(hex: "3B82F6")
    static let calendarSelected = Color(hex: "8B5CF6")
    static let calendarWeekend = Color(hex: "F3F4F6")
    
    // MARK: Helper
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Typography
struct AppTypography {
    // MARK: Display Text
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let title1 = Font.system(size: 28, weight: .bold, design: .rounded)
    static let title2 = Font.system(size: 22, weight: .bold, design: .rounded)
    static let title3 = Font.system(size: 20, weight: .semibold, design: .rounded)
    
    // MARK: Body Text
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    static let bodyBold = Font.system(size: 17, weight: .semibold, design: .default)
    static let callout = Font.system(size: 16, weight: .regular, design: .default)
    static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
    static let footnote = Font.system(size: 13, weight: .regular, design: .default)
    static let caption = Font.system(size: 12, weight: .regular, design: .default)
    static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
    
    // MARK: Custom Styles
    static let taskTitle = Font.system(size: 18, weight: .semibold, design: .rounded)
    static let taskTime = Font.system(size: 14, weight: .medium, design: .default)
    static let buttonLabel = Font.system(size: 16, weight: .semibold, design: .rounded)
}

// MARK: - Spacing
struct AppSpacing {
    static let xxxsmall: CGFloat = 2
    static let xxsmall: CGFloat = 4
    static let xsmall: CGFloat = 8
    static let small: CGFloat = 12
    static let medium: CGFloat = 16
    static let large: CGFloat = 20
    static let xlarge: CGFloat = 24
    static let xxlarge: CGFloat = 32
    static let xxxlarge: CGFloat = 40
}

// MARK: - Corner Radius
struct AppCornerRadius {
    static let xsmall: CGFloat = 4
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let xlarge: CGFloat = 20
    static let xxlarge: CGFloat = 24
    static let round: CGFloat = 999 // For fully rounded buttons
}

// MARK: - Shadows
struct AppShadow {
    static let small = Shadow(
        color: Color.black.opacity(0.05),
        radius: 2,
        x: 0,
        y: 1
    )
    
    static let medium = Shadow(
        color: Color.black.opacity(0.1),
        radius: 8,
        x: 0,
        y: 4
    )
    
    static let large = Shadow(
        color: Color.black.opacity(0.15),
        radius: 16,
        x: 0,
        y: 8
    )
    
    struct Shadow {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }
}

// MARK: - Icons
struct AppIcons {
    // MARK: Navigation
    static let home = "house.fill"
    static let calendar = "calendar"
    static let tasks = "list.bullet"
    static let settings = "gearshape.fill"
    static let profile = "person.fill"
    
    // MARK: Actions
    static let add = "plus"
    static let edit = "pencil"
    static let delete = "trash.fill"
    static let done = "checkmark"
    static let close = "xmark"
    static let more = "ellipsis"
    static let search = "magnifyingglass"
    static let filter = "line.3.horizontal.decrease.circle"
    static let sort = "arrow.up.arrow.down"
    
    // MARK: Task Actions
    static let schedule = "calendar.badge.clock"
    static let reschedule = "arrow.triangle.2.circlepath"
    static let complete = "checkmark.circle.fill"
    static let incomplete = "circle"
    static let priority = "exclamationmark.circle.fill"
    
    // MARK: AI Features
    static let aiSchedule = "sparkles"
    static let aiSuggestion = "lightbulb.fill"
    static let aiMagic = "wand.and.stars"
    
    // MARK: Time
    static let clock = "clock.fill"
    static let timer = "timer"
    static let alarm = "alarm.fill"
    static let duration = "hourglass"
    
    // MARK: Categories
    static let work = "briefcase.fill"
    static let personal = "person.fill"
    static let health = "heart.fill"
    static let learning = "book.fill"
    static let shopping = "cart.fill"
    
    // MARK: Status
    static let success = "checkmark.circle.fill"
    static let warning = "exclamationmark.triangle.fill"
    static let error = "xmark.circle.fill"
    static let info = "info.circle.fill"
}

// MARK: - View Modifiers
extension View {
    // MARK: Card Style
    func cardStyle() -> some View {
        self
            .background(Color.backgroundSecondary)
            .cornerRadius(AppCornerRadius.medium)
            .shadow(
                color: AppShadow.medium.color,
                radius: AppShadow.medium.radius,
                x: AppShadow.medium.x,
                y: AppShadow.medium.y
            )
    }
    
    // MARK: Primary Button Style
    func primaryButtonStyle() -> some View {
        self
            .font(AppTypography.buttonLabel)
            .foregroundColor(.white)
            .padding(.horizontal, AppSpacing.large)
            .padding(.vertical, AppSpacing.small)
            .background(Color.primaryBlue)
            .cornerRadius(AppCornerRadius.medium)
    }
    
    // MARK: Secondary Button Style
    func secondaryButtonStyle() -> some View {
        self
            .font(AppTypography.buttonLabel)
            .foregroundColor(.primaryBlue)
            .padding(.horizontal, AppSpacing.large)
            .padding(.vertical, AppSpacing.small)
            .background(Color.primaryBlue.opacity(0.1))
            .cornerRadius(AppCornerRadius.medium)
    }
    
    // MARK: Text Field Style
    func textFieldStyle() -> some View {
        self
            .padding(AppSpacing.small)
            .background(Color.backgroundSecondary)
            .cornerRadius(AppCornerRadius.small)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.small)
                    .stroke(Color.borderLight, lineWidth: 1)
            )
    }
}

// MARK: - Adaptive Colors
extension Color {
    static func adaptive(light: Color, dark: Color) -> Color {
        return Color(
            UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor(dark)
                default:
                    return UIColor(light)
                }
            }
        )
    }
    
    // MARK: Adaptive Backgrounds
    static let adaptiveBackground = adaptive(
        light: .backgroundPrimary,
        dark: .darkBackgroundPrimary
    )
    
    static let adaptiveSecondaryBackground = adaptive(
        light: .backgroundSecondary,
        dark: .darkBackgroundSecondary
    )
    
    static let adaptiveTertiaryBackground = adaptive(
        light: .backgroundTertiary,
        dark: .darkBackgroundTertiary
    )
}
