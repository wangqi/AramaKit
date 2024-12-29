import Foundation

extension AramaClient {
  public func search(_ parameters: SearchParameters) async throws -> SearchResponse {
    guard let components = URLComponents(string: "\(baseURL)/search"),
      let url = components.url
    else {
      throw AramaError.invalidURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    var body: [String: Any] = [
      "query": parameters.query,
      "api_key": apiKey,
      "search_depth": parameters.searchDepth.rawValue,
      "topic": parameters.topic?.rawValue ?? "general",
      "include_answer": parameters.includeAnswers,
      "include_raw_content": parameters.includeRawContent,
      "include_images": parameters.includeImages,
      "include_image_descriptions": parameters.includeImageDescriptions,
      "include_domains": parameters.includeDomains ?? [],
      "max_results": parameters.maxResults ?? 5,
    ]

    if let days = parameters.days {
      body["days"] = days
    }

    request.httpBody = try JSONSerialization.data(withJSONObject: body)

    let (data, response) = try await session.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw AramaError.invalidResponse
    }

    if httpResponse.statusCode != 200 {
      throw AramaError.apiError("HTTP \(httpResponse.statusCode)")
    }

    return try JSONDecoder().decode(SearchResponse.self, from: data)
  }
}
