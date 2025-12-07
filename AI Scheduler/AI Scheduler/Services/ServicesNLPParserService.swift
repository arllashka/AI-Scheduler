//
//  NLPParserService.swift
//  AI Scheduler
//
//  Created by Arlan Kalin on 07.12.2025.
//

import Foundation
import Combine

/// Service for parsing natural language task descriptions using OpenAI
@MainActor
final class NLPParserService: ObservableObject {

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

    /// Parse natural language input to extract task attributes
    /// - Parameter naturalLanguageInput: The user's natural language prompt
    /// - Returns: Parsed task attributes
    func parseTaskFromNaturalLanguage(_ naturalLanguageInput: String) async throws -> NLPParserResponse {
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

        // Build prompt for parsing
        let prompt = buildParsingPrompt(from: naturalLanguageInput)

        // Call OpenAI API
        do {
            let response = try await callOpenAIAPI(with: prompt)
            return try parseNLPResponse(from: response)
        } catch {
            let apiError = error as? APIError ?? .networkError(error)
            lastError = apiError
            throw apiError
        }
    }

    // MARK: - Private Methods

    /// Build the NLP parsing prompt for GPT
    private func buildParsingPrompt(from input: String) -> String {
        let now = Date()
        let formatter = ISO8601DateFormatter()
        let currentDate = formatter.string(from: now)

        let calendar = Calendar.current
        let currentWeekday = calendar.component(.weekday, from: now)

        // Calculate common reference dates for AI
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: now)!

        // Next weekend calculation
        let daysUntilSaturday = currentWeekday == 7 ? 7 : (currentWeekday == 1 ? 6 : 7 - currentWeekday)
        let nextSaturday = calendar.date(byAdding: .day, value: daysUntilSaturday, to: now)!
        let nextSunday = calendar.date(byAdding: .day, value: 1, to: nextSaturday)!

        // Next week calculation (Monday to Sunday)
        let daysUntilMonday = currentWeekday == 2 ? 7 : (currentWeekday == 1 ? 1 : 9 - currentWeekday)
        let nextMonday = calendar.date(byAdding: .day, value: daysUntilMonday, to: now)!
        let nextWeekEnd = calendar.date(byAdding: .day, value: 6, to: nextMonday)!

        return """
        You are an intelligent task parser. Your job is to extract structured task information from natural language input.

        **Current Date & Time:** \(currentDate)

        **Reference Dates for Calculations:**
        - Today: \(currentDate)
        - Tomorrow: \(formatter.string(from: tomorrow))
        - Next Weekend: Saturday \(formatter.string(from: nextSaturday)) to Sunday \(formatter.string(from: nextSunday))
        - Next Week: Monday \(formatter.string(from: nextMonday)) to Sunday \(formatter.string(from: nextWeekEnd))

        **User Input:**
        "\(input)"

        **Instructions:**
        1. Identify all distinct tasks mentioned in the input
        2. For each task, extract:
           - Title: A clear, concise task name (required)
           - Description: Any additional context or details (optional)
           - Duration: Estimated time in minutes (infer from context or use reasonable defaults)
           - Priority: 1-10 scale based on urgency indicators (default: 5)
           - Recurrence: Pattern of repetition if mentioned
           - Temporal Constraints: When the task should occur
           - Preferred Time: Specific times of day if mentioned

        3. **Recurrence Pattern Rules:**
           - "X times per week/day/month" → Set type="custom", frequency=X, totalOccurrences=X
           - "daily" → type="daily"
           - "weekly" → type="weekly"
           - "every [day]" → type="weekly", specificDays=["day"]
           - For "3 times a week", create 3 separate task instances (totalOccurrences=3)

        4. **Temporal Constraints Rules:**
           - "next week" → startDate=next Monday, endDate=next Sunday
           - "next weekend" → allowedDaysOfWeek=["Saturday", "Sunday"], startDate=next Saturday
           - "this weekend" → allowedDaysOfWeek=["Saturday", "Sunday"], startDate=this Saturday
           - "weekends" or "on weekends" → allowedDaysOfWeek=["Saturday", "Sunday"]
           - "weekdays" → allowedDaysOfWeek=["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
           - "tomorrow" → startDate=tomorrow, endDate=tomorrow
           - "today" → startDate=today, endDate=today

        5. **Time of Day Rules:**
           - "morning" → timeRange: 06:00-12:00
           - "noon" or "midday" → preferredTime: 12:00
           - "afternoon" → timeRange: 12:00-17:00
           - "evening" → timeRange: 17:00-21:00
           - "night" → timeRange: 21:00-23:59
           - "at [time]" → preferredTime: exact time

        6. **Duration Inference:**
           - "gym", "workout" → 60 minutes
           - "call", "meeting" → 30 minutes
           - "coffee", "break" → 15 minutes
           - "grocery", "shopping" → 45 minutes
           - "lunch", "dinner" → 60 minutes
           - Otherwise use context or default to 30 minutes

        7. **Priority Inference:**
           - "urgent", "asap", "important" → 8-10
           - "need to", "must", "have to" → 6-7
           - Normal tasks → 5
           - "when I can", "maybe", "if possible" → 3-4

        **Output Format:**
        Return a valid JSON object with this exact structure:
        {
          "tasks": [
            {
              "title": "string",
              "description": "string or null",
              "durationMinutes": number,
              "priority": number (1-10),
              "recurrence": {
                "type": "string (daily|weekly|monthly|custom)",
                "frequency": number or null,
                "specificDays": ["string"] or null,
                "totalOccurrences": number or null,
                "explanation": "string"
              } or null,
              "temporalConstraints": {
                "startDate": "ISO8601 date string or null",
                "endDate": "ISO8601 date string or null",
                "allowedDaysOfWeek": ["string"] or null,
                "preferredTime": "HH:mm or null",
                "timeRange": {
                  "startTime": "HH:mm",
                  "endTime": "HH:mm"
                } or null,
                "explanation": "string or null"
              } or null,
              "preferredTimeOfDay": "string or null"
            }
          ],
          "metadata": {
            "tasksIdentified": number,
            "confidence": number (0.0-1.0),
            "clarifications": ["string"] or null,
            "aiModel": "gpt-4o",
            "timestamp": "ISO8601 datetime"
          }
        }

        **Examples:**

        Input: "I wish I go to gym three times a week next week at noon"
        Output: {
          "tasks": [{
            "title": "Go to gym",
            "description": "Weekly gym session",
            "durationMinutes": 60,
            "priority": 5,
            "recurrence": {
              "type": "custom",
              "frequency": 3,
              "specificDays": null,
              "totalOccurrences": 3,
              "explanation": "3 times during next week"
            },
            "temporalConstraints": {
              "startDate": "\(formatter.string(from: nextMonday))",
              "endDate": "\(formatter.string(from: nextWeekEnd))",
              "allowedDaysOfWeek": null,
              "preferredTime": "12:00",
              "timeRange": null,
              "explanation": "next week at noon"
            },
            "preferredTimeOfDay": "noon"
          }],
          "metadata": {
            "tasksIdentified": 1,
            "confidence": 0.95,
            "clarifications": null,
            "aiModel": "gpt-4o",
            "timestamp": "\(currentDate)"
          }
        }

        Input: "I wanna go grocery next weekend"
        Output: {
          "tasks": [{
            "title": "Go grocery shopping",
            "description": null,
            "durationMinutes": 45,
            "priority": 5,
            "recurrence": null,
            "temporalConstraints": {
              "startDate": "\(formatter.string(from: nextSaturday))",
              "endDate": "\(formatter.string(from: nextSunday))",
              "allowedDaysOfWeek": ["Saturday", "Sunday"],
              "preferredTime": null,
              "timeRange": null,
              "explanation": "next weekend"
            },
            "preferredTimeOfDay": null
          }],
          "metadata": {
            "tasksIdentified": 1,
            "confidence": 0.9,
            "clarifications": null,
            "aiModel": "gpt-4o",
            "timestamp": "\(currentDate)"
          }
        }

        **Important:**
        - Return ONLY the JSON object, no additional text or explanation
        - **CRITICAL**: Use the Reference Dates provided above. For "next weekend" use the exact Saturday/Sunday dates shown. For "next week" use the Monday-Sunday dates shown.
        - Always return REAL ISO8601 date strings, never use placeholders like "[next Monday]"
        - Calculate all dates relative to the current date: \(currentDate)
        - Be smart about inferring missing information from context
        - If the input mentions multiple distinct tasks, create separate task objects
        - The explanation field should be lowercase and simple (e.g., "next weekend", "tomorrow", "next week at noon")
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
                    "content": "You are an expert natural language parser for task scheduling. Always respond with valid JSON only, no additional text."
                ],
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "temperature": 0.3, // Slightly higher than scheduling for creativity in interpretation
            "max_tokens": 2048,
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

    /// Parse the NLP response from GPT's output
    private func parseNLPResponse(from text: String) throws -> NLPParserResponse {
        // Extract JSON from text (in case there's extra text)
        let jsonText = extractJSON(from: text)

        guard let data = jsonText.data(using: .utf8) else {
            throw APIError.invalidResponse
        }

        do {
            return try jsonDecoder.decode(NLPParserResponse.self, from: data)
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
