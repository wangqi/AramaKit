import Foundation

extension AramaClient {

  /// Extracts raw content from multiple URLs.
  ///
  /// This method makes a POST request to the Tavily Extract API to retrieve the raw content from multiple URLs.
  /// The API will attempt to extract content from each URL and return both successful and failed results.
  ///
  /// - Parameter urls: An array of URLs to extract content from.
  ///
  /// - Returns: An ``ExtractResponse`` containing the extracted content and any failed extractions.
  ///
  /// - Throws: ``AramaError/invalidURL`` if the API endpoint URL is invalid,
  ///           ``AramaError/invalidResponse`` if the response is not HTTP,
  ///           ``AramaError/apiError`` if the API returns a non-200 status code.
  ///
  /// - Note: The API will attempt to extract content from all URLs even if some fail.
  ///         Failed extractions will be included in the response's `failedResults` array.
  public func extract(urls: [String]) async throws -> ExtractResponse {
    guard let components = URLComponents(string: "\(baseURL)/extract"),
      let url = components.url
    else {
      throw AramaError.invalidURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body: [String: Any] = [
      "urls": urls,
      "api_key": apiKey,
    ]

    request.httpBody = try JSONSerialization.data(withJSONObject: body)

    let (data, response) = try await session.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw AramaError.invalidResponse
    }

    if httpResponse.statusCode != 200 {
      throw AramaError.apiError("HTTP \(httpResponse.statusCode)")
    }

    return try JSONDecoder().decode(ExtractResponse.self, from: data)
  }

  /// Extracts raw content from a single URL.
  ///
  /// This is a convenience method that calls ``extract(urls:)`` with a single URL.
  ///
  /// - Parameter url: The URL to extract content from.
  ///
  /// - Returns: An ``ExtractResponse`` containing the extracted content.
  ///
  /// - Throws: The same errors as ``extract(urls:)``.
  public func extract(url: String) async throws -> ExtractResponse {
    return try await extract(urls: [url])
  }
}
