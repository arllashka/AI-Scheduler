#!/bin/bash

# AI Scheduler - Quick Setup Script
# This script helps you set up the Info.plist with your Gemini API key

echo "🚀 AI Scheduler - Setup Script"
echo "================================"
echo ""

# Check if Info.plist exists
if [ -f "Info.plist" ]; then
    echo "✅ Info.plist already exists"
    echo ""
    echo "Current API key status:"
    
    # Try to read the API key
    API_KEY=$(grep -A 1 "GEMINI_API_KEY" Info.plist | grep "string" | sed 's/.*<string>\(.*\)<\/string>.*/\1/')
    
    if [ -z "$API_KEY" ] || [ "$API_KEY" == "YOUR_GEMINI_API_KEY_HERE" ]; then
        echo "❌ No API key configured"
    else
        # Show first and last 4 characters only
        MASKED_KEY="${API_KEY:0:4}...${API_KEY: -4}"
        echo "✅ API key configured: $MASKED_KEY"
    fi
else
    echo "⚠️  Info.plist not found. Creating from template..."
    
    if [ -f "Info.plist.template" ]; then
        cp Info.plist.template Info.plist
        echo "✅ Info.plist created from template"
    else
        echo "❌ Error: Info.plist.template not found"
        exit 1
    fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 API Key Configuration Options"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Choose how you want to configure your API key:"
echo ""
echo "1) Through the app Settings UI (Recommended)"
echo "2) Edit Info.plist manually"
echo "3) Set environment variable"
echo "4) Skip (I'll do it later)"
echo ""
read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo ""
        echo "✅ Great choice!"
        echo ""
        echo "Steps:"
        echo "1. Get your API key from: https://makersuite.google.com/app/apikey"
        echo "2. Open the AI Scheduler app"
        echo "3. Go to Settings tab"
        echo "4. Tap 'Gemini API Key'"
        echo "5. Paste your key and save"
        echo ""
        echo "That's it! The key will be stored securely."
        ;;
    2)
        echo ""
        read -p "Enter your Gemini API key: " user_key
        
        if [ -z "$user_key" ]; then
            echo "❌ No key provided. Skipping..."
        else
            # Update Info.plist with the key
            if [[ "$OSTYPE" == "darwin"* ]]; then
                # macOS
                sed -i '' "s/YOUR_GEMINI_API_KEY_HERE/$user_key/g" Info.plist
                sed -i '' "s/<string><\/string>/<string>$user_key<\/string>/g" Info.plist
            else
                # Linux
                sed -i "s/YOUR_GEMINI_API_KEY_HERE/$user_key/g" Info.plist
                sed -i "s/<string><\/string>/<string>$user_key<\/string>/g" Info.plist
            fi
            
            echo "✅ API key added to Info.plist"
            echo ""
            echo "⚠️  IMPORTANT:"
            echo "- Info.plist is in .gitignore (won't be committed)"
            echo "- Keep this key private!"
            echo "- Don't share your Info.plist file"
        fi
        ;;
    3)
        echo ""
        echo "To set as environment variable:"
        echo ""
        echo "In Xcode:"
        echo "1. Edit Scheme → Run → Arguments"
        echo "2. Add Environment Variable:"
        echo "   Name: GEMINI_API_KEY"
        echo "   Value: [your key]"
        echo ""
        echo "In Terminal:"
        echo "export GEMINI_API_KEY=\"your_key_here\""
        echo ""
        echo "Add to ~/.zshrc or ~/.bashrc to make it permanent"
        ;;
    4)
        echo ""
        echo "✅ Skipping API key setup"
        echo ""
        echo "You can configure it later by:"
        echo "- Using the app Settings UI"
        echo "- Editing Info.plist"
        echo "- Reading API_KEY_SETUP.md"
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 Setup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo "1. Open the project in Xcode"
echo "2. Build and run"
echo "3. Add some tasks"
echo "4. Tap 'AI Schedule' to test"
echo ""
echo "📚 Documentation:"
echo "- API_KEY_SETUP.md - Detailed API key guide"
echo "- QUICK_START.md - User guide"
echo "- ARCHITECTURE.md - Technical overview"
echo ""
echo "Happy scheduling! 🚀"
