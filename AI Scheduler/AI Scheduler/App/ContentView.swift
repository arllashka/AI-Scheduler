//
//  ContentView.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TaskListView()
                .tabItem {
                    Label("Tasks", systemImage: AppIcons.tasks)
                }
                .tag(0)
            
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: AppIcons.calendar)
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: AppIcons.settings)
                }
                .tag(2)
        }
        .tint(.primaryBlue)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TaskItem.self, inMemory: true)
}
