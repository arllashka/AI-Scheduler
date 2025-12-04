//
//  OpenAISchedulerService.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 04.12.2025.
//

import Foundation
import Combine

/// Service for communicating with OpenAI ChatGPT API to schedule tasks
@MainActor
final class OpenAISchedulerService: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isLoading = false
    @Published var lastError: APIError?
    
    // MARK: - Private Properties
    
    private let urlSession: URLSession
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    
    // MARK: - Initialization
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
        
        // Configure JSON encoder
        self.jsonEncoder = JSONEncoder()
        self.jsonEncoder.dateEncodingStrategy = .iso8601
        self.jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        // Configure JSON decoder
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: - Public Methods
    
    /// Schedule tasks using OpenAI ChatGPT API
    /// - Parameters:
    ///   - tasks: Array of tasks to schedule
    ///   - availableSlots: Available time slots for scheduling
    ///   - constraints: Time constraints for scheduling
    /// - Returns: Scheduler response with scheduled slots
    func scheduleTasks(
        tasks: [TaskDTO],
        availableSlots: [AvailableSlot],
        constraints: TimeConstraints
    ) async throws -> SchedulerResponse {
        isLoading = true
        lastError = nil
        
        defer {
            isLoading = false
        }
        
        // Validate API key
        guard !APIConfiguration.apiKey.isEmpty else {
            let error = APIError.apiKeyMissing
            lastError = error
            throw error
        }
        
        // Create request
        let request = SchedulerRequest(
            tasks: tasks,
            availableSlots: availableSlots,
            timeConstraints: constraints
        )
        
        // Build prompt for ChatGPT
        let prompt = try buildSchedulingPrompt(from: request)
        
        // Call OpenAI API
        do {
            let response = try await callOpenAIAPI(with: prompt)
            return try parseSchedulerResponse(from: response)
        } catch {
            let apiError = error as? APIError ?? .networkError(error)
            lastError = apiError
            throw apiError
        }
    }
    
    // MARK: - Private Methods
    
    /// Build the scheduling prompt for ChatGPT
    private func buildSchedulingPrompt(from request: SchedulerRequest) throws -> String {
        // Convert request to JSON string
        let requestData = try jsonEncoder.encode(request)
        guard let requestJSON = String(data: requestData, encoding: .utf8) else {
            throw APIError.invalidRequest("Failed to encode request")
        }
        
        return """
        You are an intelligent task scheduler. Your job is to optimally schedule tasks into available time slots.
        
        **Input Data:**
        \(requestJSON)
        
        **Instructions:**
        1. Schedule each task into the available time slots
        2. Respect task priorities (1=Low, 5=High) - schedule high priority tasks first
        3. Respect fixed time slots (tasks with fixedTimeSlot must be scheduled at that exact time)
        4. Respect time constraints (work hours, break duration, max consecutive hours)
        5. Do not overlap tasks
        6. Tasks with recurrence should be scheduled on appropriate days
        7. Optimize for productivity by grouping similar tasks when possible
        8. Leave buffer time between tasks for transitions
        
        **Output Format:**
        Return a valid JSON object with this exact structure:
        {
          "scheduledSlots": [
            {
              "id": "UUID",
              "taskId": "UUID",
              "scheduledStart": "ISO8601 datetime",
              "scheduledEnd": "ISO8601 datetime"
            }
          ],
          "unscheduledTasks": [
            {
              "id": "UUID",
              "taskId": "UUID",
              "reason": "explanation why task couldn't be scheduled"
            }
          ],
          "metadata": {
            "totalTasks": number,
            "scheduledCount": number,
            "unscheduledCount": number,
            "processingTime": number,
            "aiModel": "gpt-4o",
            "timestamp": "ISO8601 datetime"
          }
        }
        
        **Important:** Return ONLY the JSON object, no additional text or explanation.
        """
    }
    
    /// Call OpenAI API with the prompt
    private func callOpenAIAPI(with prompt: String) async throws -> String {
        guard let url = APIConfiguration.chatCompletionsURL else {
            throw APIError.invalidURL
        }
        
        // Build request body for OpenAI Chat Completions API
        let requestBody: [String: Any] = [
            "model": APIConfiguration.modelName,
            "messages": [
                [
                    "role": "system",
                    "content": "You are an expert AI task scheduler. Always respond with valid JSON only, no additional text."
                ],
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "temperature": 0.2,
            "max_tokens": 4096,
            "response_format": ["type": "json_object"]
        ]
        
        let requestData = try JSONSerialization.data(withJSONObject: requestBody)
        
        // Create URL request
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(APIConfiguration.apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = requestData
        urlRequest.timeoutInterval = APIConfiguration.timeoutInterval
        
        // Perform request
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        // Validate response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        // Check status code
        guard (200...299).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 429 {
                throw APIError.rateLimitExceeded
            }
            
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw APIError.serverError(httpResponse.statusCode, errorMessage)
        }
        
        // Parse OpenAI response
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = json["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw APIError.invalidResponse
        }
        
        return content
    }
    
    /// Parse the scheduler response from ChatGPT's output
    private func parseSchedulerResponse(from text: String) throws -> SchedulerResponse {
        // Extract JSON from text (in case there's extra text)
        let jsonText = extractJSON(from: text)
        
        guard let data = jsonText.data(using: .utf8) else {
            throw APIError.invalidResponse
        }
        
        do {
            return try jsonDecoder.decode(SchedulerResponse.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    /// Extract JSON from text (handles cases where AI adds extra text)
    private func extractJSON(from text: String) -> String {
        // Try to find JSON object boundaries
        if let startIndex = text.firstIndex(of: "{"),
           let endIndex = text.lastIndex(of: "}") {
            return String(text[startIndex...endIndex])
        }
        return text
    }
}

// MARK: - Convenience Methods

extension OpenAISchedulerService: SchedulerServiceProtocol {
    /// Schedule tasks from TaskItem models
    func scheduleTasks(
        from taskItems: [TaskItem],
        availableSlots: [AvailableSlot],
        constraints: TimeConstraints
    ) async throws -> SchedulerResponse {
        let taskDTOs = taskItems.map { $0.toDTO() }
        return try await scheduleTasks(
            tasks: taskDTOs,
            availableSlots: availableSlots,
            constraints: constraints
        )
    }
}
