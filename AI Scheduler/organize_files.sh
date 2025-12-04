#!/bin/bash

# AI Scheduler - File Organization Script
# This script organizes project files into a logical folder structure

set -e  # Exit on error

echo "🚀 AI Scheduler - File Organization Script"
echo "=========================================="
echo ""

# Get the script's directory (should be the repo root)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "📂 Current directory: $SCRIPT_DIR"
echo ""

# Create folder structure
echo "📁 Creating folder structure..."

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
mkdir -p "Documentation"

echo "✅ Folder structure created"
echo ""

# Function to move file if it exists
move_file() {
    local source="$1"
    local destination="$2"
    
    if [ -f "$source" ]; then
        echo "  Moving: $source → $destination"
        mv "$source" "$destination"
    else
        echo "  ⚠️  Not found: $source"
    fi
}

# Move App files
echo "📱 Organizing App files..."
move_file "AI_SchedulerApp.swift" "AI Scheduler/App/"
move_file "ContentView.swift" "AI Scheduler/App/"
echo ""

# Move Design files
echo "🎨 Organizing Design files..."
move_file "DesignSystem.swift" "AI Scheduler/Design/"
move_file "UIComponents.swift" "AI Scheduler/Design/"
echo ""

# Move View files
echo "📱 Organizing View files..."
move_file "OnboardingView.swift" "AI Scheduler/Views/Onboarding/"
move_file "TaskListView.swift" "AI Scheduler/Views/Tasks/"
move_file "AddTaskView.swift" "AI Scheduler/Views/Tasks/"
move_file "CalendarView.swift" "AI Scheduler/Views/Calendar/"
move_file "SettingsView.swift" "AI Scheduler/Views/Settings/"
echo ""

# Move Domain Model files
echo "🗂️  Organizing Domain Model files..."
move_file "DomainModelsTaskItem.swift" "AI Scheduler/Models/Domain/"
move_file "DomainModelsTaskDTO.swift" "AI Scheduler/Models/Domain/"
move_file "DomainModelsScheduledSlot.swift" "AI Scheduler/Models/Domain/"
echo ""

# Move API Model files
echo "📡 Organizing API Model files..."
move_file "APIModelsSchedulerRequest.swift" "AI Scheduler/Models/API/"
move_file "APIModelsSchedulerResponse.swift" "AI Scheduler/Models/API/"
echo ""

# Move Service files
echo "🔧 Organizing Service files..."
move_file "APIConfiguration.swift" "AI Scheduler/Services/"
move_file "ServicesGeminiSchedulerService.swift" "AI Scheduler/Services/"
move_file "ServicesMockSchedulerService.swift" "AI Scheduler/Services/"
move_file "ServicesSchedulerCoordinator.swift" "AI Scheduler/Services/"
echo ""

# Move Testing files
echo "🧪 Organizing Testing files..."
move_file "TestingSampleData.swift" "AI Scheduler/Testing/"
move_file "TestsSchedulerServiceTests.swift" "AI Scheduler/Testing/"
echo ""

# Move old Item.swift (if exists - this is the old template file)
echo "🗑️  Checking for old template files..."
move_file "Item.swift" "AI Scheduler/Models/Domain/"
echo ""

# Move Documentation files
echo "📄 Organizing Documentation files..."
move_file "ARCHITECTURE.md" "Documentation/"
move_file "API_README.md" "Documentation/"
move_file "UI_README.md" "Documentation/"
move_file "IMAGE_ASSETS_NEEDED.md" "Documentation/"
move_file "UI_IMPLEMENTATION_SUMMARY.md" "Documentation/"
move_file "QUICK_START_UI.md" "Documentation/"
move_file "COLOR_ASSETS_GUIDE.md" "Documentation/"
move_file "QUICK_REFERENCE.md" "Documentation/"
move_file "FILE_ORGANIZATION_GUIDE.md" "Documentation/"
echo ""

# Create README in root if it doesn't exist
if [ ! -f "README.md" ]; then
    echo "📝 Creating root README.md..."
    cat > README.md << 'EOF'
# AI Scheduler

An intelligent task scheduling app powered by Google's Gemini AI.

## 📁 Project Structure

```
AI Scheduler/
├── App/                    # Main app entry and root view
├── Design/                 # Design system and UI components
├── Views/                  # All UI screens
│   ├── Onboarding/
│   ├── Tasks/
│   ├── Calendar/
│   └── Settings/
├── Models/                 # Data models
│   ├── Domain/            # SwiftData models
│   └── API/               # API request/response models
├── Services/              # Business logic and API services
└── Testing/               # Test helpers and sample data

Documentation/             # Project documentation
```

## 🚀 Quick Start

See [Documentation/QUICK_START_UI.md](Documentation/QUICK_START_UI.md) for getting started.

## 📚 Documentation

- [Architecture](Documentation/ARCHITECTURE.md) - Technical architecture
- [API Documentation](Documentation/API_README.md) - Gemini API integration
- [UI Documentation](Documentation/UI_README.md) - UI design system
- [Quick Start](Documentation/QUICK_START_UI.md) - Getting started guide

## ✨ Features

- 🤖 AI-powered task scheduling using Google Gemini
- 📅 Visual calendar and timeline views
- 🎯 Priority-based task management
- 🌙 Dark mode support
- 📱 Responsive design for all iOS devices

## 🛠️ Tech Stack

- SwiftUI
- SwiftData
- Google Gemini API
- Swift Concurrency (async/await)

## 📱 Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

---

**Created**: December 4, 2025
**Status**: UI Complete - Ready for Model Integration
EOF
    echo "✅ README.md created"
else
    echo "ℹ️  README.md already exists"
fi
echo ""

# Summary
echo "=========================================="
echo "✅ File organization complete!"
echo ""
echo "📁 New structure:"
echo "   AI Scheduler/"
echo "   ├── App/"
echo "   ├── Design/"
echo "   ├── Views/"
echo "   │   ├── Onboarding/"
echo "   │   ├── Tasks/"
echo "   │   ├── Calendar/"
echo "   │   └── Settings/"
echo "   ├── Models/"
echo "   │   ├── Domain/"
echo "   │   └── API/"
echo "   ├── Services/"
echo "   └── Testing/"
echo "   "
echo "   Documentation/"
echo ""
echo "⚠️  IMPORTANT: After running this script:"
echo "   1. Open Xcode"
echo "   2. Close your project if it's open"
echo "   3. Reopen the project"
echo "   4. If files show as red (missing):"
echo "      - Right-click on the file in Xcode"
echo "      - Choose 'Delete' → 'Remove Reference'"
echo "      - Drag the file back from Finder into the correct group"
echo "   5. Build and run (⌘R) to verify everything works"
echo ""
echo "🎉 Done!"
