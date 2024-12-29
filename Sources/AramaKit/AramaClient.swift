import Foundation

public class AramaClient {
  internal let apiKey: String
  internal let baseURL = "https://api.tavily.com"
  internal let session: URLSession

  public init(apiKey: String, session: URLSession = .shared) {
    self.apiKey = apiKey
    self.session = session
  }
}
