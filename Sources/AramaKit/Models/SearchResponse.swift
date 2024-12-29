import Foundation

public struct SearchResponse: Codable {
  public let query: String
  public let results: [SearchResult]
  public let count: Int
  public let answer: String?
  public let responseTime: Double
  public let images: [ImageResult]?

  private enum CodingKeys: String, CodingKey {
    case query
    case results
    case count
    case answer
    case responseTime = "response_time"
    case images
  }

  public struct SearchResult: Codable {
    public let title: String
    public let url: String
    public let content: String
    public let score: Double
    public let publishedDate: String?
    public let rawContent: String?

    enum CodingKeys: String, CodingKey {
      case title
      case url
      case content
      case score
      case publishedDate = "published_date"
      case rawContent = "raw_content"
    }
  }

  public struct ImageResult: Codable {
    public let url: String
    public let description: String?
  }
}
