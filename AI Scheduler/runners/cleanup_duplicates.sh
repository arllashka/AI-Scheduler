#!/bin/bash

# Cleanup Duplicate Files Script
# Removes duplicate AddTaskView files, keeping only the correct one

echo "🧹 Cleaning up duplicate files..."
echo ""

# Remove duplicate AddTaskView files (keep the latest one)
if [ -f "AddTaskView 2.swift" ]; then
    echo "Removing: AddTaskView 2.swift"
    rm "AddTaskView 2.swift"
fi

if [ -f "AddTaskView 3.swift" ]; then
    echo "Removing: AddTaskView 3.swift"
    rm "AddTaskView 3.swift"
fi

if [ -f "AddTaskView-App.swift" ]; then
    echo "Removing: AddTaskView-App.swift"
    rm "AddTaskView-App.swift"
fi

# Check in App folder
if [ -f "AI Scheduler/App/AddTaskView 2.swift" ]; then
    echo "Removing: AI Scheduler/App/AddTaskView 2.swift"
    rm "AI Scheduler/App/AddTaskView 2.swift"
fi

if [ -f "AI Scheduler/App/AddTaskView 3.swift" ]; then
    echo "Removing: AI Scheduler/App/AddTaskView 3.swift"
    rm "AI Scheduler/App/AddTaskView 3.swift"
fi

echo ""
echo "✅ Cleanup complete!"
echo ""
echo "⚠️  Next steps:"
echo "1. Close Xcode"
echo "2. Reopen your project"
echo "3. Clean Build Folder (Shift+Cmd+K)"
echo "4. Build (Cmd+B)"
echo ""
