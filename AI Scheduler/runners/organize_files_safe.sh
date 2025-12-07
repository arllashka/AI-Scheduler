#!/bin/bash

# AI Scheduler - Safe File Organization Script
# This script creates a backup and organizes files with safety checks

set -e  # Exit on error

echo "🚀 AI Scheduler - Safe File Organization"
echo "========================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the script's directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo -e "${BLUE}📂 Working directory: $SCRIPT_DIR${NC}"
echo ""

# Check if running from correct location
if [ ! -f "AI_SchedulerApp.swift" ] && [ ! -f "AI Scheduler/App/AI_SchedulerApp.swift" ]; then
    echo -e "${RED}❌ Error: Cannot find project files${NC}"
    echo "Please run this script from the repository root"
    exit 1
fi

# Check if already organized
if [ -d "AI Scheduler/App" ] && [ -f "AI Scheduler/App/AI_SchedulerApp.swift" ]; then
    echo -e "${YELLOW}⚠️  Files appear to already be organized${NC}"
    echo ""
    read -p "Do you want to reorganize anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelled."
        exit 0
    fi
fi

# Create backup
echo -e "${BLUE}💾 Creating backup...${NC}"
BACKUP_DIR="backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup Swift files
for file in *.swift; do
    if [ -f "$file" ]; then
        cp "$file" "$BACKUP_DIR/"
    fi
done

# Backup markdown files
for file in *.md; do
    if [ -f "$file" ]; then
        cp "$file" "$BACKUP_DIR/"
    fi
done

echo -e "${GREEN}✅ Backup created at: $BACKUP_DIR${NC}"
echo ""

# Create folder structure
echo -e "${BLUE}📁 Creating folder structure...${NC}"

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

echo -e "${GREEN}✅ Folders created${NC}"
echo ""

# Function to safely move file
safe_move() {
    local source="$1"
    local dest_dir="$2"
    local filename=$(basename "$source")
    
    if [ -f "$source" ]; then
        # Check if destination already exists
        if [ -f "$dest_dir/$filename" ]; then
            echo -e "${YELLOW}  ⚠️  Already exists: $dest_dir/$filename${NC}"
            return
        fi
        
        echo -e "  ${GREEN}✓${NC} $source → $dest_dir/"
        mv "$source" "$dest_dir/"
    fi
}

# Move App files
echo -e "${BLUE}📱 Organizing App files...${NC}"
safe_move "AI_SchedulerApp.swift" "AI Scheduler/App"
safe_move "ContentView.swift" "AI Scheduler/App"
echo ""

# Move Design files
echo -e "${BLUE}🎨 Organizing Design files...${NC}"
safe_move "DesignSystem.swift" "AI Scheduler/Design"
safe_move "UIComponents.swift" "AI Scheduler/Design"
echo ""

# Move View files
echo -e "${BLUE}📱 Organizing View files...${NC}"
safe_move "OnboardingView.swift" "AI Scheduler/Views/Onboarding"
safe_move "TaskListView.swift" "AI Scheduler/Views/Tasks"
safe_move "AddTaskView.swift" "AI Scheduler/Views/Tasks"
safe_move "CalendarView.swift" "AI Scheduler/Views/Calendar"
safe_move "SettingsView.swift" "AI Scheduler/Views/Settings"
echo ""

# Move Domain Model files
echo -e "${BLUE}🗂️  Organizing Domain Model files...${NC}"
safe_move "DomainModelsTaskItem.swift" "AI Scheduler/Models/Domain"
safe_move "DomainModelsTaskDTO.swift" "AI Scheduler/Models/Domain"
safe_move "DomainModelsScheduledSlot.swift" "AI Scheduler/Models/Domain"
safe_move "Item.swift" "AI Scheduler/Models/Domain"
echo ""

# Move API Model files
echo -e "${BLUE}📡 Organizing API Model files...${NC}"
safe_move "APIModelsSchedulerRequest.swift" "AI Scheduler/Models/API"
safe_move "APIModelsSchedulerResponse.swift" "AI Scheduler/Models/API"
echo ""

# Move Service files
echo -e "${BLUE}🔧 Organizing Service files...${NC}"
safe_move "APIConfiguration.swift" "AI Scheduler/Services"
safe_move "ServicesGeminiSchedulerService.swift" "AI Scheduler/Services"
safe_move "ServicesMockSchedulerService.swift" "AI Scheduler/Services"
safe_move "ServicesSchedulerCoordinator.swift" "AI Scheduler/Services"
echo ""

# Move Testing files
echo -e "${BLUE}🧪 Organizing Testing files...${NC}"
safe_move "TestingSampleData.swift" "AI Scheduler/Testing"
safe_move "TestsSchedulerServiceTests.swift" "AI Scheduler/Testing"
echo ""

# Move UI Test files
echo -e "${BLUE}🧪 Organizing UI Test files...${NC}"
safe_move "AI_SchedulerUITestsLaunchTests.swift" "AI Scheduler/UI Tests"
echo ""

# Move Documentation files
echo -e "${BLUE}📄 Organizing Documentation files...${NC}"
safe_move "ARCHITECTURE.md" "Documentation"
safe_move "API_README.md" "Documentation"
safe_move "UI_README.md" "Documentation"
safe_move "IMAGE_ASSETS_NEEDED.md" "Documentation"
safe_move "UI_IMPLEMENTATION_SUMMARY.md" "Documentation"
safe_move "QUICK_START_UI.md" "Documentation"
safe_move "COLOR_ASSETS_GUIDE.md" "Documentation"
safe_move "QUICK_REFERENCE.md" "Documentation"
safe_move "FILE_ORGANIZATION_GUIDE.md" "Documentation"
echo ""

# Create/Update root README
echo -e "${BLUE}📝 Creating README.md...${NC}"
if [ ! -f "README.md" ]; then
    cat > README.md << 'EOF'
# AI Scheduler

An intelligent task scheduling app powered by Google's Gemini AI.

## 📁 Project Structure

```
AI Scheduler/
├── App/                    # Main app entry and root view
├── Design/                 # Design system and UI components
├── Views/                  # All UI screens
│   ├── Onboarding/        # Welcome flow
│   ├── Tasks/             # Task management
│   ├── Calendar/          # Schedule visualization
│   └── Settings/          # App configuration
├── Models/                # Data models
│   ├── Domain/            # SwiftData models
│   └── API/               # API request/response models
├── Services/              # Business logic and API services
└── Testing/               # Test helpers and sample data

Documentation/             # Project documentation
```

## 🚀 Quick Start

1. **Open Project**: Open `AI Scheduler.xcodeproj` in Xcode
2. **Read Docs**: Check [Documentation/QUICK_START_UI.md](Documentation/QUICK_START_UI.md)
3. **Run**: Press ⌘R to build and run

## 📚 Documentation

- [Architecture](Documentation/ARCHITECTURE.md) - Technical architecture
- [API Documentation](Documentation/API_README.md) - Gemini API integration
- [UI Documentation](Documentation/UI_README.md) - UI design system
- [Quick Start](Documentation/QUICK_START_UI.md) - Getting started guide
- [File Organization](Documentation/FILE_ORGANIZATION_GUIDE.md) - Project structure

## ✨ Features

- 🤖 **AI-Powered Scheduling** - Google Gemini optimizes your schedule
- 📅 **Visual Calendar** - See your day at a glance
- 🎯 **Priority Management** - Focus on what matters most
- ⏱️ **Smart Time Blocking** - Optimal task arrangement
- 🌙 **Dark Mode** - Beautiful in any lighting
- 📱 **Responsive Design** - Works on all iOS devices

## 🎨 UI Components

- Complete design system with consistent colors and typography
- 12+ reusable SwiftUI components
- Onboarding flow
- Task list with filters and search
- Calendar with monthly and daily views
- Comprehensive settings

## 🛠️ Tech Stack

- **SwiftUI** - Modern declarative UI
- **SwiftData** - Local persistence
- **Google Gemini API** - AI scheduling
- **Swift Concurrency** - async/await
- **Swift Testing** - Modern testing framework

## 📱 Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+
- Gemini API Key (optional for UI testing)

## 🔧 Setup

1. Clone the repository
2. Open `AI Scheduler.xcodeproj`
3. (Optional) Add Gemini API key in Settings
4. Build and run

## 🎯 Current Status

✅ **UI Complete** - All screens designed and implemented
✅ **Design System** - Colors, typography, components ready
✅ **API Layer** - Gemini integration complete
✅ **Mock Data** - Testing without API calls
⏳ **Data Integration** - Ready to connect UI to models

## 🗺️ Roadmap

- [x] Design system and components
- [x] Core UI views
- [x] API layer
- [ ] Connect UI to SwiftData models
- [ ] Implement AI scheduling in UI
- [ ] Add animations and polish
- [ ] Widget support
- [ ] iPad optimization

## 📖 Learn More

Visit the [Documentation](Documentation/) folder for detailed guides on:
- Architecture and design decisions
- API integration
- UI customization
- Adding new features

---

**Created**: December 4, 2025  
**Version**: 1.0  
**Status**: UI Complete - Ready for Integration
EOF
    echo -e "${GREEN}✅ README.md created${NC}"
else
    echo -e "${YELLOW}ℹ️  README.md already exists (skipped)${NC}"
fi
echo ""

# Create .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
    echo -e "${BLUE}📝 Creating .gitignore...${NC}"
    cat > .gitignore << 'EOF'
# Xcode
.DS_Store
*/build/*
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3
xcuserdata/
*.xccheckout
*.moved-aside
DerivedData
*.hmap
*.ipa
*.xcuserstate
*.xcscmblueprint

# CocoaPods
Pods/

# Carthage
Carthage/Build

# fastlane
fastlane/report.xml
fastlane/Preview.html
fastlane/screenshots
fastlane/test_output

# Swift Package Manager
.swiftpm/
.build/

# API Keys (IMPORTANT!)
**/Info.plist
**/*APIKey*
*.plist

# Backup folders
backup_*/

# IDE
.vscode/
.idea/
EOF
    echo -e "${GREEN}✅ .gitignore created${NC}"
else
    echo -e "${YELLOW}ℹ️  .gitignore already exists (skipped)${NC}"
fi
echo ""

# Summary
echo ""
echo "========================================"
echo -e "${GREEN}✅ File organization complete!${NC}"
echo ""
echo -e "${BLUE}📁 New structure created:${NC}"
echo "   AI Scheduler/"
echo "   ├── App/ (2 files)"
echo "   ├── Design/ (2 files)"
echo "   ├── Views/"
echo "   │   ├── Onboarding/ (1 file)"
echo "   │   ├── Tasks/ (2 files)"
echo "   │   ├── Calendar/ (1 file)"
echo "   │   └── Settings/ (1 file)"
echo "   ├── Models/"
echo "   │   ├── Domain/ (4 files)"
echo "   │   └── API/ (2 files)"
echo "   ├── Services/ (4 files)"
echo "   └── Testing/ (2 files)"
echo "   "
echo "   Documentation/ (9+ files)"
echo ""
echo -e "${YELLOW}⚠️  NEXT STEPS:${NC}"
echo ""
echo "1. ${BLUE}Close Xcode${NC} if it's currently open"
echo ""
echo "2. ${BLUE}Open Terminal${NC} and run:"
echo "   cd \"$SCRIPT_DIR\""
echo "   open *.xcodeproj"
echo ""
echo "3. ${BLUE}In Xcode:${NC}"
echo "   - If files show as red (missing references):"
echo "     • Right-click → Delete → 'Remove Reference'"
echo "     • Drag folders from Finder back into Xcode"
echo "     • Choose 'Create groups' when prompted"
echo ""
echo "4. ${BLUE}Build and test:${NC}"
echo "   - Press ⌘R to build and run"
echo "   - Verify everything works"
echo ""
echo "5. ${BLUE}If everything works:${NC}"
echo "   - You can delete the backup: rm -rf $BACKUP_DIR"
echo ""
echo "6. ${BLUE}If something breaks:${NC}"
echo "   - Restore from backup: cp $BACKUP_DIR/* ."
echo "   - Or run: git reset --hard (if using git)"
echo ""
echo -e "${GREEN}🎉 Organization complete!${NC}"
echo ""
