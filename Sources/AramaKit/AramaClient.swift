import Foundation

public class AramaClient {
  internal let apiKey: String
  internal let baseURL = "https://api.tavily.com"

  public init(apiKey: String) {
    self.apiKey = apiKey
  }

  public enum AramaError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case apiError(String)
  }
}
