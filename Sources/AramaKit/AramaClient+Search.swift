import Foundation

extension AramaClient {

  /// Performs a search using the Tavily Search API with the specified parameters.
  ///
  /// This method makes a POST request to the Tavily Search API with the provided search parameters
  /// to retrieve relevant search results, optionally including AI-generated answers and images.
  ///
  /// - Parameter parameters: The ``SearchParameters`` containing the search configuration.
  ///
  /// - Returns: A ``SearchResponse`` containing the search results, answer, and any images.
  ///
  /// - Throws: ``AramaError/invalidURL`` if the API endpoint URL is invalid,
  ///           ``AramaError/invalidResponse`` if the response is not HTTP,
  ///           ``AramaError/apiError`` if the API returns a non-200 status code.
  ///
  /// - Note: The response time and result scoring are included in the response to help
  ///         evaluate the quality and performance of the search.
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
