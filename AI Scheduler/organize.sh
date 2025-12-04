#!/bin/bash

# AI Scheduler - Quick File Organization
# Run this script to organize your project files

echo "🚀 Organizing AI Scheduler project files..."
echo ""

# Create all directories
echo "Creating directories..."
mkdir -p "AI Scheduler/App"
mkdir -p "AI Scheduler/Design"
mkdir -p "AI Scheduler/Views/Onboarding"
mkdir -p "AI Scheduler/Views/Tasks"
mkdir -p "AI Scheduler/Views/Calendar"
mkdir -p "AI Scheduler/Views/Settings"
mkdir -p "AI Scheduler/Models/Domain"
mkdir -p "AI Scheduler/Models/API"
mkdir -p "AI Scheduler/Services"
mkdir -p "AI Scheduler/Testing"
mkdir -p "AI Scheduler/UI Tests"
mkdir -p "Documentation"

# Move files (only if they exist in current directory)
echo "Moving files..."

# App files
[ -f "AI_SchedulerApp.swift" ] && mv "AI_SchedulerApp.swift" "AI Scheduler/App/" && echo "✓ Moved AI_SchedulerApp.swift"
[ -f "ContentView.swift" ] && mv "ContentView.swift" "AI Scheduler/App/" && echo "✓ Moved ContentView.swift"

# Design files
[ -f "DesignSystem.swift" ] && mv "DesignSystem.swift" "AI Scheduler/Design/" && echo "✓ Moved DesignSystem.swift"
[ -f "UIComponents.swift" ] && mv "UIComponents.swift" "AI Scheduler/Design/" && echo "✓ Moved UIComponents.swift"

# View files
[ -f "OnboardingView.swift" ] && mv "OnboardingView.swift" "AI Scheduler/Views/Onboarding/" && echo "✓ Moved OnboardingView.swift"
[ -f "TaskListView.swift" ] && mv "TaskListView.swift" "AI Scheduler/Views/Tasks/" && echo "✓ Moved TaskListView.swift"
[ -f "AddTaskView.swift" ] && mv "AddTaskView.swift" "AI Scheduler/Views/Tasks/" && echo "✓ Moved AddTaskView.swift"
[ -f "CalendarView.swift" ] && mv "CalendarView.swift" "AI Scheduler/Views/Calendar/" && echo "✓ Moved CalendarView.swift"
[ -f "SettingsView.swift" ] && mv "SettingsView.swift" "AI Scheduler/Views/Settings/" && echo "✓ Moved SettingsView.swift"

# Model files - Domain
[ -f "DomainModelsTaskItem.swift" ] && mv "DomainModelsTaskItem.swift" "AI Scheduler/Models/Domain/" && echo "✓ Moved DomainModelsTaskItem.swift"
[ -f "DomainModelsTaskDTO.swift" ] && mv "DomainModelsTaskDTO.swift" "AI Scheduler/Models/Domain/" && echo "✓ Moved DomainModelsTaskDTO.swift"
[ -f "DomainModelsScheduledSlot.swift" ] && mv "DomainModelsScheduledSlot.swift" "AI Scheduler/Models/Domain/" && echo "✓ Moved DomainModelsScheduledSlot.swift"
[ -f "Item.swift" ] && mv "Item.swift" "AI Scheduler/Models/Domain/" && echo "✓ Moved Item.swift"

# Model files - API
[ -f "APIModelsSchedulerRequest.swift" ] && mv "APIModelsSchedulerRequest.swift" "AI Scheduler/Models/API/" && echo "✓ Moved APIModelsSchedulerRequest.swift"
[ -f "APIModelsSchedulerResponse.swift" ] && mv "APIModelsSchedulerResponse.swift" "AI Scheduler/Models/API/" && echo "✓ Moved APIModelsSchedulerResponse.swift"

# Service files
[ -f "APIConfiguration.swift" ] && mv "APIConfiguration.swift" "AI Scheduler/Services/" && echo "✓ Moved APIConfiguration.swift"
[ -f "ServicesGeminiSchedulerService.swift" ] && mv "ServicesGeminiSchedulerService.swift" "AI Scheduler/Services/" && echo "✓ Moved ServicesGeminiSchedulerService.swift"
[ -f "ServicesMockSchedulerService.swift" ] && mv "ServicesMockSchedulerService.swift" "AI Scheduler/Services/" && echo "✓ Moved ServicesMockSchedulerService.swift"
[ -f "ServicesSchedulerCoordinator.swift" ] && mv "ServicesSchedulerCoordinator.swift" "AI Scheduler/Services/" && echo "✓ Moved ServicesSchedulerCoordinator.swift"

# Testing files
[ -f "TestingSampleData.swift" ] && mv "TestingSampleData.swift" "AI Scheduler/Testing/" && echo "✓ Moved TestingSampleData.swift"
[ -f "TestsSchedulerServiceTests.swift" ] && mv "TestsSchedulerServiceTests.swift" "AI Scheduler/Testing/" && echo "✓ Moved TestsSchedulerServiceTests.swift"

# UI Test files
[ -f "AI_SchedulerUITestsLaunchTests.swift" ] && mv "AI_SchedulerUITestsLaunchTests.swift" "AI Scheduler/UI Tests/" && echo "✓ Moved AI_SchedulerUITestsLaunchTests.swift"

# Documentation files
[ -f "ARCHITECTURE.md" ] && mv "ARCHITECTURE.md" "Documentation/" && echo "✓ Moved ARCHITECTURE.md"
[ -f "API_README.md" ] && mv "API_README.md" "Documentation/" && echo "✓ Moved API_README.md"
[ -f "UI_README.md" ] && mv "UI_README.md" "Documentation/" && echo "✓ Moved UI_README.md"
[ -f "IMAGE_ASSETS_NEEDED.md" ] && mv "IMAGE_ASSETS_NEEDED.md" "Documentation/" && echo "✓ Moved IMAGE_ASSETS_NEEDED.md"
[ -f "UI_IMPLEMENTATION_SUMMARY.md" ] && mv "UI_IMPLEMENTATION_SUMMARY.md" "Documentation/" && echo "✓ Moved UI_IMPLEMENTATION_SUMMARY.md"
[ -f "QUICK_START_UI.md" ] && mv "QUICK_START_UI.md" "Documentation/" && echo "✓ Moved QUICK_START_UI.md"
[ -f "COLOR_ASSETS_GUIDE.md" ] && mv "COLOR_ASSETS_GUIDE.md" "Documentation/" && echo "✓ Moved COLOR_ASSETS_GUIDE.md"
[ -f "QUICK_REFERENCE.md" ] && mv "QUICK_REFERENCE.md" "Documentation/" && echo "✓ Moved QUICK_REFERENCE.md"
[ -f "FILE_ORGANIZATION_GUIDE.md" ] && mv "FILE_ORGANIZATION_GUIDE.md" "Documentation/" && echo "✓ Moved FILE_ORGANIZATION_GUIDE.md"
[ -f "HOW_TO_RUN_ORGANIZATION.md" ] && mv "HOW_TO_RUN_ORGANIZATION.md" "Documentation/" && echo "✓ Moved HOW_TO_RUN_ORGANIZATION.md"

echo ""
echo "✅ Done! Files organized into:"
echo ""
echo "   AI Scheduler/"
echo "   ├── App/"
echo "   ├── Design/"
echo "   ├── Views/"
echo "   ├── Models/"
echo "   ├── Services/"
echo "   └── Testing/"
echo ""
echo "   Documentation/"
echo ""
echo "⚠️  Next: Open Xcode and rebuild the project"
echo ""
