import Foundation

/// A response containing the results of extracting content from one or more URLs.
public struct ExtractResponse: Codable {

  /// The successfully extracted results.
  public let results: [ExtractResult]

  /// Results that failed during extraction.
  public let failedResults: [FailedResult]

  /// The time taken to process the extraction request in seconds.
  public let responseTime: Double

  private enum CodingKeys: String, CodingKey {
    case results
    case failedResults = "failed_results"
    case responseTime = "response_time"
  }

  /// A successful content extraction result.
  public struct ExtractResult: Codable {
    /// The URL that was extracted from.
    public let url: String

    /// The raw content extracted from the URL.
    public let rawContent: String

    private enum CodingKeys: String, CodingKey {
      case url
      case rawContent = "raw_content"
    }
  }

  /// A failed content extraction result.
  public struct FailedResult: Codable {
    /// The URL that failed extraction.
    public let url: String

    /// The error message describing why extraction failed.
    public let error: String
  }
}
