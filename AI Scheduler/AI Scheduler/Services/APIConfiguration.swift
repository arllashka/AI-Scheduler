//
//  APIConfiguration.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import Foundation

/// Configuration for API communication with Gemini
struct APIConfiguration {
    /// Gemini API key from environment or configuration
    static var apiKey: String {
        // In production, load from secure storage or environment
        // For now, return from Info.plist or environment variable
        if let key = Bundle.main.object(forInfoDictionaryKey: "GEMINI_API_KEY") as? String {
            return key
        }
        
        // Fallback to environment variable (useful for testing)
        if let key = ProcessInfo.processInfo.environment["GEMINI_API_KEY"] {
            return key
        }
        
        // For development, you can hardcode it here (not recommended for production)
        return ""
    }
    
    /// Base URL for Gemini API
    static let baseURL = "https://generativelanguage.googleapis.com/v1beta"
    
    /// Model to use for scheduling
    static let modelName = "gemini-2.0-flash-exp"
    
    /// Full endpoint URL for generating content
    static var generateContentURL: URL? {
        URL(string: "\(baseURL)/models/\(modelName):generateContent")
    }
    
    /// Request timeout interval
    static let timeoutInterval: TimeInterval = 30
    
    /// Maximum retries for failed requests
    static let maxRetries = 3
}

/// API Error types
enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)
    case apiKeyMissing
    case rateLimitExceeded
    case invalidRequest(String)
    case serverError(Int, String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .apiKeyMissing:
            return "Gemini API key is missing. Please configure it in your app settings."
        case .rateLimitExceeded:
            return "API rate limit exceeded. Please try again later."
        case .invalidRequest(let message):
            return "Invalid request: \(message)"
        case .serverError(let code, let message):
            return "Server error (\(code)): \(message)"
        }
    }
}
