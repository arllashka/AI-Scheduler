//
//  APIConfiguration.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import Foundation

/// Configuration for API communication with OpenAI ChatGPT
struct APIConfiguration {
    /// Company's OpenAI API key (hardcoded for production use)
    /// NOTE: In production, consider using environment-specific configuration
    private static let companyAPIKey = ""
    
    /// OpenAI API key - returns company key
    @MainActor
    static var apiKey: String {
        // Return company's hardcoded key
        // This ensures the app always works without user configuration
        return companyAPIKey
    }
    
    /// Base URL for OpenAI API
    static let baseURL = "https://api.openai.com/v1"
    
    /// Model to use for scheduling
    static let modelName = "gpt-4o"
    
    /// Full endpoint URL for chat completions
    static var chatCompletionsURL: URL? {
        URL(string: "\(baseURL)/chat/completions")
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
            return "OpenAI API key is missing. Please configure it in your app settings."
        case .rateLimitExceeded:
            return "API rate limit exceeded. Please try again later."
        case .invalidRequest(let message):
            return "Invalid request: \(message)"
        case .serverError(let code, let message):
            return "Server error (\(code)): \(message)"
        }
    }
}
