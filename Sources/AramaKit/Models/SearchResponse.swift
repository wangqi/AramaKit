import Foundation

/// A response containing search results and metadata from the Tavily Search API.
public struct SearchResponse: Codable {

  /// The original search query that was submitted.
  public let query: String

  /// An array of search results matching the query.
  public let results: [SearchResult]

  /// An optional AI-generated answer summarizing the search results.
  public let answer: String?

  /// The time taken to process the search request in seconds.
  public let responseTime: Double

  /// Optional array of image results if image search was enabled.
  public let images: [ImageResult]?

  private enum CodingKeys: String, CodingKey {
    case query
    case results
    case answer
    case responseTime = "response_time"
    case images
  }

  /// A single search result containing information about a matching webpage.
  public struct SearchResult: Codable {

    /// The title of the webpage.
    public let title: String

    /// The URL of the webpage.
    public let url: String

    /// A relevant excerpt or summary of the webpage content.
    public let content: String

    /// A relevance score indicating how well this result matches the query.
    public let score: Double

    /// The publication date of the content, if available.
    public let publishedDate: String?

    /// The full raw content of the webpage, if requested.
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

  /// A search result containing an image and optional description.
  public struct ImageResult: Codable {
    /// The URL of the image.
    public let url: String

    /// An optional AI-generated description of the image.
    public let description: String?
  }
}
