# 📋 Info.plist & API Key Setup - Complete

## ✅ What Was Created

### 1. **Info.plist**
- Complete iOS app property list file
- Configured for AI Scheduler app
- Ready to accept Gemini API key
- Includes app metadata and security settings

**Location:** `/repo/Info.plist`

### 2. **Info.plist.template**
- Template version for team development
- Safe to commit to Git
- Users copy and add their own key

**Location:** `/repo/Info.plist.template`

### 3. **API_KEY_SETUP.md**
- Comprehensive guide for API key configuration
- Covers all 4 methods (App UI, Info.plist, Environment, xcconfig)
- Security best practices
- Troubleshooting section

**Location:** `/repo/API_KEY_SETUP.md`

### 4. **.gitignore**
- Protects sensitive files from Git
- Standard Xcode ignores
- API key protection (commented out by default)

**Location:** `/repo/.gitignore`

### 5. **setup.sh**
- Interactive setup script
- Helps users configure API key quickly
- Multiple configuration options

**Location:** `/repo/setup.sh`

---

## 🔑 How to Add Your API Key

### Method 1: Through App Settings (Easiest) ⭐

1. Get your API key from: https://makersuite.google.com/app/apikey
2. Run the app
3. Go to **Settings** tab
4. Tap **"Gemini API Key"**
5. Paste your key
6. Tap **"Save API Key"**

✅ **This is the recommended method for most users!**

---

### Method 2: Edit Info.plist (Quick for Development) 📝

#### Option A: Direct Edit

1. Open `/repo/Info.plist` in a text editor
2. Find this section (around line 60):
   ```xml
   <key>GEMINI_API_KEY</key>
   <string></string>
   ```
3. Replace with your key:
   ```xml
   <key>GEMINI_API_KEY</key>
   <string>AIzaSyABCDEFGHIJKLMNOPQRSTUVWXYZ1234567</string>
   ```
4. Save the file

#### Option B: Use Setup Script

```bash
chmod +x setup.sh
./setup.sh
```

Follow the interactive prompts!

#### ⚠️ Security Warning:
If you hardcode the key in Info.plist:
1. **Add Info.plist to .gitignore** to prevent committing it
2. Or use the template approach (see below)

---

### Method 3: Environment Variable (For Testing) 🔧

#### In Xcode:
1. Click on your scheme → **Edit Scheme...**
2. Go to **Run** → **Arguments** tab
3. Under **Environment Variables**, add:
   - **Name:** `GEMINI_API_KEY`
   - **Value:** `[your actual key]`

#### In Terminal:
```bash
export GEMINI_API_KEY="AIzaSyABCDEFGHIJKLMNOPQRSTUVWXYZ1234567"
```

---

### Method 4: Template Approach (For Teams) 👥

**Setup once:**

1. Keep `Info.plist.template` in Git
2. Add actual `Info.plist` to `.gitignore`

**Each team member:**

```bash
# Copy template
cp Info.plist.template Info.plist

# Add their own key
nano Info.plist  # or use any editor
```

This way:
- Template is shared (no secrets)
- Real Info.plist stays local
- Each dev has their own key

---

## 📁 In Xcode Project

To use Info.plist in your Xcode project:

1. **If creating new project:**
   - Xcode creates Info.plist automatically
   - Replace its content with our Info.plist content

2. **If project exists:**
   - Right-click project folder
   - "Add Files to [Project]"
   - Select Info.plist
   - ✅ Check "Copy items if needed"

3. **Verify in Build Settings:**
   - Select your target
   - Build Settings → Packaging
   - Find "Info.plist File"
   - Should point to: `Info.plist` or `AI Scheduler/Info.plist`

---

## 🔒 Security Best Practices

### Current Setup:

The Info.plist file I created:
- ✅ Has empty API key by default
- ✅ Includes security settings for HTTPS
- ✅ Configured for Gemini API domain
- ✅ Includes app metadata

### To Keep It Secure:

#### Option 1: Don't Commit Info.plist

Uncomment these lines in `.gitignore`:
```bash
# API KEYS & SECRETS
Info.plist
Config.xcconfig
*.xcconfig
Secrets.plist
```

#### Option 2: Use Template Approach

Keep this workflow:
```
Info.plist.template (in Git) 
  → Copy locally → 
Info.plist (not in Git)
  → Each dev adds their key
```

#### Option 3: Use App Settings Only

Don't put the key in Info.plist at all:
- Users configure through Settings UI
- Key stored in UserDefaults
- Info.plist stays clean and committable

---

## 🧪 Testing Without API Key

You can test the full app without a real API key!

**In `TaskListView.swift`, line 20, change:**
```swift
// From this:
@StateObject private var schedulerCoordinator = SchedulerCoordinator()

// To this:
@StateObject private var schedulerCoordinator = SchedulerCoordinator.mock()
```

This uses a **mock scheduler** that simulates AI responses locally. Perfect for:
- Development without API costs
- Testing offline
- Demos
- Unit tests

---

## 📊 Priority Order

The app checks for API keys in this order:

```
1. UserPreferences (App Settings)
   └─ Stored in UserDefaults
   └─ User enters through UI
   
2. Info.plist
   └─ GEMINI_API_KEY value
   └─ Hardcoded or template
   
3. Environment Variable
   └─ GEMINI_API_KEY
   └─ From Xcode scheme or terminal
   
4. None Found
   └─ Shows "API Key Required" alert
   └─ Directs user to Settings
```

**First found wins!**

This means:
- If user sets key in Settings → that's used (highest priority)
- If not in Settings but in Info.plist → that's used
- If not in either but in environment → that's used
- If nowhere → error shown

---

## 🎯 Info.plist Contents

### What's Included:

✅ **App Metadata**
- Bundle identifier
- Display name: "AI Scheduler"
- Version: 1.0
- Build: 1

✅ **Platform Requirements**
- Minimum iOS: 17.0
- Required capabilities: arm64

✅ **Orientations**
- iPhone: Portrait + Landscape
- iPad: All orientations

✅ **Security**
- App Transport Security configured
- HTTPS only
- Gemini API domain whitelisted
- TLS 1.2 minimum

✅ **API Key Slot**
- GEMINI_API_KEY entry
- Empty by default
- Ready for your key

✅ **App Category**
- Productivity

✅ **Scene Configuration**
- Supports multiple scenes

### What's NOT Included (Commented Out):

These are ready if you need them:
- Calendar access permission
- Reminders access permission
- Notifications permission
- Background modes

**To enable:** Just uncomment the relevant sections.

---

## 🚀 Quick Start Commands

### Get Started Now:

```bash
# Make setup script executable
chmod +x setup.sh

# Run interactive setup
./setup.sh

# Or manually copy template
cp Info.plist.template Info.plist

# Edit with your favorite editor
nano Info.plist
# or
code Info.plist
# or
open -a Xcode Info.plist
```

### Protect Your Key:

```bash
# Add Info.plist to gitignore
echo "Info.plist" >> .gitignore

# Verify it's ignored
git status
# Info.plist should not appear
```

### Open in Xcode:

```bash
# Find your .xcodeproj file
find . -name "*.xcodeproj"

# Open it
open AI_Scheduler.xcodeproj
# or
xed .
```

---

## 📖 Documentation Reference

### For Users:
- **QUICK_START.md** - How to use the app
- **API_KEY_SETUP.md** - Detailed API key guide (this is most relevant)

### For Developers:
- **ARCHITECTURE.md** - System architecture
- **AI_SCHEDULING_IMPLEMENTATION.md** - Technical implementation
- **COMPLETE.md** - Overall project summary

### Quick Reference:
All docs are in `/repo/` folder.

---

## ✅ Checklist

Before running the app:

- [ ] Info.plist exists
- [ ] API key configured (choose one):
  - [ ] In app Settings UI, OR
  - [ ] In Info.plist, OR
  - [ ] As environment variable, OR
  - [ ] Using mock scheduler (no key needed)
- [ ] If hardcoded: Info.plist in .gitignore
- [ ] Xcode project references Info.plist
- [ ] Build settings point to Info.plist

---

## 🐛 Troubleshooting

### "Info.plist not found in Xcode"

**Solution:**
1. Check if it's in your project folder
2. Add to Xcode: Right-click → Add Files
3. Ensure it's in target membership

### "API Key Required" error

**Check:**
1. App Settings → Gemini API Key (is it empty?)
2. Info.plist → GEMINI_API_KEY (is it empty or "YOUR_GEMINI_API_KEY_HERE"?)
3. Key format (should start with "AIza")
4. Key validity (test at https://makersuite.google.com/)

### "Build setting for Info.plist not found"

**Solution:**
1. Select your target in Xcode
2. Build Settings → Packaging
3. Set "Info.plist File" to: `Info.plist`

### "Git showing Info.plist as modified"

**Solution:**
```bash
# Add to gitignore
echo "Info.plist" >> .gitignore

# Remove from Git tracking (keeps local file)
git rm --cached Info.plist

# Commit the removal
git commit -m "Remove Info.plist from tracking"
```

---

## 🎉 Summary

You now have:

1. ✅ **Complete Info.plist** ready for your app
2. ✅ **Template version** for team collaboration  
3. ✅ **Setup script** for easy configuration
4. ✅ **.gitignore** to protect secrets
5. ✅ **Comprehensive guide** (API_KEY_SETUP.md)

### Next Steps:

1. **Choose your API key method** (App UI recommended)
2. **Add your key** using one of the methods above
3. **Open in Xcode** and build
4. **Run the app** and test AI scheduling!

### Remember:

- 🔐 Keep your API key private
- 📝 Use template approach for teams
- 🧪 Use mock scheduler for testing
- ⚙️ App Settings UI is easiest for users

---

**Info.plist is ready! Your API key setup is complete!** 🎊

Go ahead and start scheduling with AI! 🚀
