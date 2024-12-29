import Foundation

extension AramaClient {
  public struct SearchParameters {
    public let query: String
    public let searchDepth: SearchDepth
    public let topic: SearchTopic
    public let days: Int?
    public let maxResults: Int?
    public let includeImages: Bool
    public let includeImageDescriptions: Bool
    public let includeAnswers: Bool
    public let includeRawContent: Bool
    public let includeDomains: [String]
    public let excludeDomains: [String]

    public init(
      query: String,
      searchDepth: SearchDepth = .basic,
      topic: SearchTopic = .general,
      days: Int? = nil,
      maxResults: Int? = nil,
      includeImages: Bool = false,
      includeImageDescriptions: Bool = false,
      includeAnswers: Bool = false,
      includeRawContent: Bool = false,
      includeDomains: [String] = [],
      excludeDomains: [String] = []
    ) {
      self.query = query
      self.searchDepth = searchDepth
      self.topic = topic
      self.days = days
      self.maxResults = maxResults
      self.includeImages = includeImages
      self.includeImageDescriptions = includeImageDescriptions
      self.includeAnswers = includeAnswers
      self.includeRawContent = includeRawContent
      self.includeDomains = includeDomains
      self.excludeDomains = excludeDomains
    }
  }

  public enum SearchDepth: String {
    case basic = "basic"
    case advanced = "advanced"
  }

  public enum SearchTopic: String {
    case general = "general"
    case news = "news"
  }

  public func search(_ parameters: SearchParameters) async throws -> SearchResponse {
    guard let components = URLComponents(string: "\(baseURL)/search"),
      let url = components.url
    else {
      throw AramaError.invalidURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(apiKey, forHTTPHeaderField: "api-key")

    var body: [String: Any] = [
      "query": parameters.query,
      "search_depth": parameters.searchDepth.rawValue,
      "topic": parameters.topic.rawValue,
      "include_answer": parameters.includeAnswers,
      "include_images": parameters.includeImages,
      "include_image_descriptions": parameters.includeImageDescriptions,
      "include_raw_content": parameters.includeRawContent,
      "include_domains": parameters.includeDomains,
      "exclude_domains": parameters.excludeDomains,
    ]

    if let maxResults = parameters.maxResults {
      body["max_results"] = maxResults
    }

    if let days = parameters.days {
      body["days"] = days
    }

    request.httpBody = try JSONSerialization.data(withJSONObject: body)

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw AramaError.invalidResponse
    }

    if httpResponse.statusCode != 200 {
      throw AramaError.apiError("HTTP \(httpResponse.statusCode)")
    }

    return try JSONDecoder().decode(SearchResponse.self, from: data)
  }
}
