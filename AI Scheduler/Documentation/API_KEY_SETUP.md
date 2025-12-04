# 🔑 Gemini API Key Configuration Guide

## Overview

The AI Scheduler app supports **three ways** to configure your Gemini API key:

1. ✅ **Through the App Settings UI** (Recommended for users)
2. 📝 **In Info.plist** (Good for development)
3. 🔧 **Via Environment Variable** (Best for testing)

---

## Method 1: App Settings UI (Recommended) ⭐

This is the **best option for end users** because it's the most secure and user-friendly.

### How it works:
1. Open the app
2. Go to **Settings** tab
3. Tap **"Gemini API Key"**
4. Paste your API key
5. Tap **"Save API Key"**

### Where it's stored:
- Saved to UserDefaults via `@AppStorage`
- Persists between app launches
- Can be updated anytime
- Relatively secure (sandboxed)

### Code location:
- `DomainModelsUserPreferences.swift` (storage)
- `SettingsView.swift` (UI)
- `APIConfiguration.swift` (reads it)

---

## Method 2: Info.plist (For Development) 📝

This is good for **hardcoding during development**, but **NOT recommended for production** or App Store submission.

### Steps:

1. **Open `Info.plist`** in your Xcode project

2. **Find the GEMINI_API_KEY section:**
   ```xml
   <!-- OPTION 1: Hardcode your API key here -->
   <!--
   <key>GEMINI_API_KEY</key>
   <string>YOUR_GEMINI_API_KEY_HERE</string>
   -->
   ```

3. **Uncomment and add your key:**
   ```xml
   <key>GEMINI_API_KEY</key>
   <string>AIzaSyABCDEFGHIJKLMNOPQRSTUVWXYZ1234567</string>
   ```

4. **Save and rebuild** the app

### ⚠️ Important Notes:

- **DO NOT commit this to Git!** Add Info.plist to `.gitignore` if you hardcode the key
- This exposes your API key in the app bundle
- Anyone can extract it from your app
- Only use for personal development

### To protect your key:

Create a `.gitignore` file and add:
```
Info.plist
*.plist
```

Or use a template approach (see Method 4 below).

---

## Method 3: Environment Variable (For Testing) 🔧

This is perfect for **automated testing** and **CI/CD pipelines**.

### Steps:

#### In Xcode:

1. Select your scheme (e.g., "AI Scheduler")
2. Click **Edit Scheme...**
3. Go to **Run** → **Arguments**
4. Under **Environment Variables**, add:
   - **Name:** `GEMINI_API_KEY`
   - **Value:** `AIzaSyABCDEFGHIJKLMNOPQRSTUVWXYZ1234567`

#### In Terminal (for command-line testing):

```bash
export GEMINI_API_KEY="AIzaSyABCDEFGHIJKLMNOPQRSTUVWXYZ1234567"
```

### How it works:

The `APIConfiguration.swift` file checks environment variables:
```swift
if let key = ProcessInfo.processInfo.environment["GEMINI_API_KEY"] {
    return key
}
```

---

## Method 4: Configuration File (Best Practice) 🏆

For **team development** or **open-source projects**, use a separate configuration file.

### Setup:

1. **Create `Config.xcconfig` file:**
   ```
   GEMINI_API_KEY = AIzaSyABCDEFGHIJKLMNOPQRSTUVWXYZ1234567
   ```

2. **Add to `.gitignore`:**
   ```
   Config.xcconfig
   *.xcconfig
   ```

3. **Create `Config.xcconfig.template`:**
   ```
   // Copy this file to Config.xcconfig and add your API key
   GEMINI_API_KEY = YOUR_API_KEY_HERE
   ```

4. **Commit the template** (not the actual config)

5. **Update Info.plist to read from config:**
   ```xml
   <key>GEMINI_API_KEY</key>
   <string>$(GEMINI_API_KEY)</string>
   ```

6. **Link config in Xcode:**
   - Select your project
   - Go to **Info** tab
   - Under **Configurations**, select `Config.xcconfig` for each build configuration

### Team workflow:
1. Clone repo
2. Copy `Config.xcconfig.template` → `Config.xcconfig`
3. Add your own API key
4. Build and run!

---

## Priority Order

The `APIConfiguration.swift` checks sources in this order:

```swift
1. UserPreferences (App Settings UI)
   ↓
2. Info.plist (GEMINI_API_KEY)
   ↓
3. Environment Variable (GEMINI_API_KEY)
   ↓
4. Returns empty string (shows error in app)
```

This means:
- App settings take priority
- Falls back to Info.plist if not set
- Falls back to environment variable
- Shows "API Key Required" alert if none found

---

## How to Get a Gemini API Key

### Steps:

1. **Visit Google AI Studio:**
   https://makersuite.google.com/app/apikey

2. **Sign in** with your Google account

3. **Create API Key:**
   - Click "Create API Key"
   - Select a Google Cloud project (or create new)
   - Copy the generated key

4. **Your key looks like:**
   ```
   AIzaSyABCDEFGHIJKLMNOPQRSTUVWXYZ1234567
   ```

5. **Add to app** using any method above

### Free Tier:
- ✅ Free to get started
- ✅ Generous quotas for testing
- ✅ No credit card required initially
- ⚠️ May have rate limits

---

## Security Best Practices

### ✅ DO:
- Use App Settings UI for production apps
- Add Info.plist to `.gitignore` if hardcoding
- Use environment variables for CI/CD
- Use xcconfig files for team projects
- Rotate keys periodically
- Monitor API usage

### ❌ DON'T:
- Commit API keys to Git
- Share keys in screenshots
- Hardcode in source code
- Use same key for prod and dev
- Expose keys in client-side code (if possible)

### 🔒 For Production:
Consider using:
- **Keychain Services** for secure storage
- **Backend proxy** to hide the key completely
- **Firebase Remote Config** for dynamic updates
- **Rate limiting** to prevent abuse

---

## Current Implementation

The app currently uses this approach:

```
┌─────────────────────────────────────┐
│     User Opens App                  │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  APIConfiguration.apiKey            │
│  checks sources in order:           │
│  1. UserPreferences.shared.apiKey   │ ← App Settings
│  2. Info.plist GEMINI_API_KEY       │ ← Hardcoded
│  3. Environment GEMINI_API_KEY      │ ← Testing
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  If empty → Show "API Key Required" │
│  If found → Use for Gemini API      │
└─────────────────────────────────────┘
```

---

## Troubleshooting

### "API Key Required" error:

**Check 1:** App Settings
```
Settings → Gemini API Key → Make sure key is saved
```

**Check 2:** Info.plist
```
Open Info.plist → Look for GEMINI_API_KEY → Verify value
```

**Check 3:** Format
```
Key should start with: AIza...
No quotes, spaces, or extra characters
```

**Check 4:** Validity
```
Test at: https://makersuite.google.com/
Make sure key is active
```

### Key not working:

1. **Verify the key** at Google AI Studio
2. **Check quotas** - you might have exceeded limits
3. **Try generating a new key**
4. **Check network connection**
5. **Review Xcode console** for detailed errors

### Can't find Info.plist in Xcode:

1. Look in project navigator (left sidebar)
2. It might be under "Supporting Files"
3. Or create new: File → New → Property List
4. Name it `Info.plist`
5. Add the XML content from the file I created

---

## Quick Reference

### Current Info.plist location:
```
/repo/Info.plist
```

### To add your key now:

**Option A (In the file):**
1. Open `/repo/Info.plist`
2. Find line 60: `<string></string>`
3. Replace with: `<string>YOUR_API_KEY_HERE</string>`
4. Save

**Option B (Through app):**
1. Run the app
2. Settings → Gemini API Key
3. Paste and save

### To keep key secret:

Create `.gitignore`:
```bash
# Secrets
Info.plist
Config.xcconfig

# Build
build/
*.xcuserstate
```

---

## Testing Without Real API Key

You can test the app without a real API key using the mock service:

**In TaskListView.swift, line 20:**
```swift
// Change from:
@StateObject private var schedulerCoordinator = SchedulerCoordinator()

// To:
@StateObject private var schedulerCoordinator = SchedulerCoordinator.mock()
```

This simulates AI scheduling locally without calling Gemini API!

---

## Summary

| Method | Best For | Security | Ease |
|--------|----------|----------|------|
| App Settings UI | End users | Good | ⭐⭐⭐⭐⭐ |
| Info.plist | Development | Poor | ⭐⭐⭐⭐ |
| Environment Var | Testing/CI | Good | ⭐⭐⭐ |
| xcconfig File | Team dev | Good | ⭐⭐ |

**Recommendation:** Use **App Settings UI** for now, then implement **Keychain** for production.

---

## Next Steps

1. ✅ Info.plist is created
2. ✅ Add your API key (choose method above)
3. ✅ Run the app
4. ✅ Test AI scheduling!

Happy scheduling! 🎉
