# API Configuration Guide

## Quick Setup for Gemini API

### Step 1: Get Your API Key

1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy the generated API key

### Step 2: Add API Key to Your Project

#### Method 1: Info.plist (Recommended)

1. Open your `Info.plist` file
2. Add a new row with these values:
   - **Key**: `GEMINI_API_KEY`
   - **Type**: String
   - **Value**: Your API key

Or add this XML directly to `Info.plist`:

```xml
<key>GEMINI_API_KEY</key>
<string>YOUR_API_KEY_HERE</string>
```

#### Method 2: Environment Variable (Development)

1. In Xcode, go to **Product** → **Scheme** → **Edit Scheme...**
2. Select **Run** on the left
3. Go to the **Arguments** tab
4. Under **Environment Variables**, click **+**
5. Add:
   - **Name**: `GEMINI_API_KEY`
   - **Value**: Your API key

#### Method 3: Configuration File (Production)

Create a `Config.plist` file with your settings:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>GEMINI_API_KEY</key>
    <string>YOUR_API_KEY_HERE</string>
    <key>API_BASE_URL</key>
    <string>https://generativelanguage.googleapis.com/v1beta</string>
    <key>MODEL_NAME</key>
    <string>gemini-2.0-flash-exp</string>
</dict>
</plist>
```

Then load it in your code:

```swift
extension APIConfiguration {
    static func loadFromConfig() {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            return
        }
        
        if let apiKey = config["GEMINI_API_KEY"] as? String {
            // Store securely in Keychain
        }
    }
}
```

### Step 3: Verify Setup

Run this code to verify your configuration:

```swift
func verifyAPIConfiguration() {
    let apiKey = APIConfiguration.apiKey
    
    if apiKey.isEmpty {
        print("❌ API key is not configured")
    } else if apiKey.count < 20 {
        print("⚠️ API key seems too short")
    } else {
        print("✅ API key is configured")
    }
    
    if let url = APIConfiguration.generateContentURL {
        print("✅ API endpoint: \(url)")
    } else {
        print("❌ API endpoint is invalid")
    }
}
```

## Security Best Practices

### DO NOT:
- ❌ Hardcode API keys directly in source code
- ❌ Commit API keys to version control
- ❌ Share API keys in screenshots or documentation
- ❌ Use the same API key for development and production

### DO:
- ✅ Store API keys in environment variables or secure configuration
- ✅ Add `Config.plist` to `.gitignore`
- ✅ Use different API keys for development, staging, and production
- ✅ Rotate API keys regularly
- ✅ Set up API key restrictions in Google Cloud Console

### Example .gitignore

```
# API Configuration
Config.plist
*.xcconfig

# Secrets
**/Secrets.swift
**/APIKeys.swift
```

## API Usage Limits

### Gemini API Free Tier (as of December 2024)
- **Rate Limit**: 60 requests per minute
- **Daily Limit**: Check current limits in Google AI Studio
- **Token Limit**: Varies by model

### Handling Rate Limits in Code

```swift
// Add retry logic with exponential backoff
private func scheduleWithRetry(
    maxAttempts: Int = 3
) async throws -> SchedulerResponse {
    var lastError: Error?
    
    for attempt in 1...maxAttempts {
        do {
            return try await scheduleTasks(...)
        } catch APIError.rateLimitExceeded {
            lastError = APIError.rateLimitExceeded
            
            if attempt < maxAttempts {
                // Exponential backoff: 2^attempt seconds
                let delay = pow(2.0, Double(attempt))
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        } catch {
            throw error
        }
    }
    
    throw lastError ?? APIError.networkError(URLError(.unknown))
}
```

## Testing Without API Key

Use the mock service for development without an API key:

```swift
// In your view
@StateObject private var coordinator = SchedulerCoordinator.mock()

// Or create directly
let mockService = MockSchedulerService()
let response = try await mockService.scheduleTasks(...)
```

## Monitoring API Usage

Track your API usage in code:

```swift
actor APIUsageTracker {
    private var requestCount = 0
    private var lastResetDate = Date()
    
    func recordRequest() {
        requestCount += 1
        
        // Reset daily
        if Date().timeIntervalSince(lastResetDate) > 86400 {
            requestCount = 0
            lastResetDate = Date()
        }
    }
    
    func getCurrentUsage() -> Int {
        return requestCount
    }
}
```

## Troubleshooting

### "API key is missing"
- Check that `GEMINI_API_KEY` is set in Info.plist or environment
- Verify spelling of the key name (case-sensitive)
- Ensure the API key is not empty

### "Invalid API key"
- Verify the API key is correct (copy again from Google AI Studio)
- Check that the API key hasn't been revoked
- Ensure API key restrictions don't block your app

### "Rate limit exceeded"
- Wait a few minutes before trying again
- Implement exponential backoff retry logic
- Consider caching responses
- Check your usage in Google AI Studio

### "Server error (403)"
- API key may be invalid or restricted
- Check API key settings in Google Cloud Console
- Ensure billing is enabled (if required)

### Network errors
- Check internet connectivity
- Verify firewall settings
- Try accessing the API URL in a browser

## Alternative Configuration Methods

### Using Keychain (Most Secure)

```swift
import Security

class KeychainManager {
    static func saveAPIKey(_ key: String) {
        let data = key.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "GeminiAPIKey",
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    static func getAPIKey() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "GeminiAPIKey",
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let key = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return key
    }
}
```

### Using CloudKit (For Synced Settings)

```swift
import CloudKit

class CloudKitConfig {
    static func fetchAPIKey() async throws -> String {
        let container = CKContainer.default()
        let database = container.privateCloudDatabase
        
        let recordID = CKRecord.ID(recordName: "APIConfig")
        let record = try await database.record(for: recordID)
        
        return record["apiKey"] as? String ?? ""
    }
}
```

## Resources

- [Gemini API Documentation](https://ai.google.dev/docs)
- [Google AI Studio](https://makersuite.google.com/)
- [API Key Best Practices](https://cloud.google.com/docs/authentication/api-keys)
- [Swift Keychain Wrapper](https://developer.apple.com/documentation/security/keychain_services)
