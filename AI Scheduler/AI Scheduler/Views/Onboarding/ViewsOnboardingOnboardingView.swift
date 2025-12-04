//
//  OnboardingView.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var userPreferences = UserPreferences.shared
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [.primaryBlue, .accentPurple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                // Page indicator
                HStack(spacing: 8) {
                    ForEach(0..<4) { index in
                        Circle()
                            .fill(currentPage == index ? Color.white : Color.white.opacity(0.5))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 50)
                
                // Content
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        icon: "calendar.badge.checkmark",
                        title: "Welcome to AI Scheduler",
                        description: "Let AI organize your day intelligently. Schedule tasks based on priority, duration, and your work hours.",
                        page: 0
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        icon: "brain.head.profile",
                        title: "Smart AI Scheduling",
                        description: "Our AI understands your preferences and creates an optimal schedule that maximizes your productivity.",
                        page: 1
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        icon: "clock.badge.checkmark",
                        title: "Track Your Progress",
                        description: "See all your scheduled tasks in a beautiful calendar view. Mark tasks complete as you finish them.",
                        page: 2
                    )
                    .tag(2)
                    
                    OnboardingPageView(
                        icon: "sparkles",
                        title: "Get Started",
                        description: "Ready to boost your productivity? Let's set up your work hours and start scheduling!",
                        page: 3,
                        isLast: true
                    )
                    .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Navigation buttons
                HStack {
                    if currentPage > 0 {
                        Button {
                            withAnimation {
                                currentPage -= 1
                            }
                        } label: {
                            Text("Back")
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 15)
                        }
                    }
                    
                    Spacer()
                    
                    if currentPage < 3 {
                        Button {
                            withAnimation {
                                currentPage += 1
                            }
                        } label: {
                            Text("Next")
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryBlue)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 15)
                                .background(Color.white)
                                .cornerRadius(25)
                        }
                    } else {
                        Button {
                            completeOnboarding()
                        } label: {
                            Text("Get Started")
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryBlue)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 15)
                                .background(Color.white)
                                .cornerRadius(25)
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
    }
    
    private func completeOnboarding() {
        withAnimation {
            userPreferences.onboardingCompleted = true
        }
    }
}

struct OnboardingPageView: View {
    let icon: String
    let title: String
    let description: String
    let page: Int
    var isLast: Bool = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon
            Image(systemName: icon)
                .font(.system(size: 120))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
            
            // Title
            Text(title)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            // Description
            Text(description)
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .lineSpacing(8)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}
