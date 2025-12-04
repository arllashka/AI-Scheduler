//
//  OnboardingView.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import SwiftUI

//struct OnboardingView2: View {
//    @State private var currentPage = 0
//    @Binding var isOnboardingComplete: Bool
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            // Page Content
//            TabView(selection: $currentPage) {
//                OnboardingPage(
//                    icon: "sparkles",
//                    iconColor: .accentPurple,
//                    title: "Welcome to AI Scheduler",
//                    description: "Let artificial intelligence organize your day. Smart scheduling powered by Google Gemini.",
//                    pageNumber: 0
//                )
//                .tag(0)
//                
//                OnboardingPage(
//                    icon: "brain.head.profile",
//                    iconColor: .primaryBlue,
//                    title: "Intelligent Scheduling",
//                    description: "AI analyzes your tasks, priorities, and available time to create the perfect schedule for you.",
//                    pageNumber: 1
//                )
//                .tag(1)
//                
//                OnboardingPage(
//                    icon: "clock.badge.checkmark",
//                    iconColor: .accentGreen,
//                    title: "Optimize Your Time",
//                    description: "Focus on what matters. The AI handles the scheduling, you handle getting things done.",
//                    pageNumber: 2
//                )
//                .tag(2)
//                
//                OnboardingPage(
//                    icon: "calendar.badge.plus",
//                    iconColor: .accentOrange,
//                    title: "Ready to Start?",
//                    description: "Add your tasks, set priorities, and let AI create your perfect schedule.",
//                    pageNumber: 3,
//                    isLastPage: true,
//                    onGetStarted: {
//                        isOnboardingComplete = true
//                    }
//                )
//                .tag(3)
//            }
//            .tabViewStyle(.page(indexDisplayMode: .never))
//            
//            // Custom Page Indicator & Navigation
//            VStack(spacing: AppSpacing.large) {
//                // Page Dots
//                HStack(spacing: AppSpacing.xsmall) {
//                    ForEach(0..<4) { index in
//                        Circle()
//                            .fill(index == currentPage ? Color.primaryBlue : Color.borderMedium)
//                            .frame(width: 8, height: 8)
//                            .animation(.easeInOut, value: currentPage)
//                    }
//                }
//                
//                // Navigation Buttons
//                HStack {
//                    if currentPage > 0 {
//                        Button {
//                            withAnimation {
//                                currentPage -= 1
//                            }
//                        } label: {
//                            Text("Back")
//                                .font(AppTypography.callout)
//                                .foregroundColor(.textSecondary)
//                        }
//                    }
//                    
//                    Spacer()
//                    
//                    if currentPage < 3 {
//                        Button {
//                            withAnimation {
//                                currentPage += 1
//                            }
//                        } label: {
//                            HStack(spacing: AppSpacing.xxsmall) {
//                                Text("Next")
//                                    .font(AppTypography.callout)
//                                    .fontWeight(.semibold)
//                                Image(systemName: "arrow.right")
//                                    .font(.system(size: 14, weight: .semibold))
//                            }
//                            .foregroundColor(.primaryBlue)
//                        }
//                    }
//                }
//                .padding(.horizontal, AppSpacing.large)
//            }
//            .padding(.bottom, AppSpacing.xlarge)
//        }
//        .background(Color.adaptiveBackground)
//    }
//}
//
//// MARK: - Onboarding Page
//struct OnboardingPage: View {
//    let icon: String
//    let iconColor: Color
//    let title: String
//    let description: String
//    let pageNumber: Int
//    var isLastPage: Bool = false
//    var onGetStarted: (() -> Void)? = nil
//    
//    var body: some View {
//        VStack(spacing: AppSpacing.xlarge) {
//            Spacer()
//            
//            // Icon with gradient background
//            ZStack {
//                Circle()
//                    .fill(
//                        LinearGradient(
//                            colors: [iconColor.opacity(0.2), iconColor.opacity(0.05)],
//                            startPoint: .topLeading,
//                            endPoint: .bottomTrailing
//                        )
//                    )
//                    .frame(width: 200, height: 200)
//                
//                Image(systemName: icon)
//                    .font(.system(size: 80, weight: .medium))
//                    .foregroundColor(iconColor)
//            }
//            .padding(.top, AppSpacing.xxxlarge)
//            
//            // Text Content
//            VStack(spacing: AppSpacing.medium) {
//                Text(title)
//                    .font(AppTypography.largeTitle)
//                    .fontWeight(.bold)
//                    .foregroundColor(.textPrimary)
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal, AppSpacing.large)
//                
//                Text(description)
//                    .font(AppTypography.body)
//                    .foregroundColor(.textSecondary)
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal, AppSpacing.xlarge)
//                    .fixedSize(horizontal: false, vertical: true)
//            }
//            
//            // Get Started Button (only on last page)
//            if isLastPage {
//                PrimaryButton(
//                    "Get Started",
//                    icon: "arrow.right"
//                ) {
//                    onGetStarted?()
//                }
//                .padding(.horizontal, AppSpacing.xlarge)
//                .padding(.top, AppSpacing.medium)
//            }
//            
//            Spacer()
//            Spacer()
//        }
//    }
//}

//// MARK: - Onboarding Wrapper
//struct OnboardingWrapper: View {
//    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
//    
//    var body: some View {
//        if hasCompletedOnboarding {
//            ContentView()
//        } else {
//            OnboardingView(isOnboardingComplete: $hasCompletedOnboarding)
//        }
//    }
//}
//
//#Preview("Onboarding") {
//    OnboardingView(isOnboardingComplete: .constant(false))
//}
//
//#Preview("Main App") {
//    OnboardingWrapper()
//}
