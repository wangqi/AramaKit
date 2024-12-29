/// Parameters used to configure and customize a search request.
public struct SearchParameters {
  /// The search query string to be executed.
  public let query: String

  /// The depth level of the search to perform.
  public let searchDepth: SearchDepth

  /// The topic category to search within.
  public let topic: Topic?

  /// Optional number of days to limit the search results to.
  /// If nil, no date restriction is applied.
  public let days: Int?

  /// Optional maximum number of results to return.
  /// If nil, uses the API default limit.
  public let maxResults: Int?

  /// Whether to include image results in the search response.
  public let includeImages: Bool

  /// Whether to include descriptions for any returned images.
  /// Only applicable if `includeImages` is true.
  public let includeImageDescriptions: Bool

  /// Whether to include AI-generated answer summaries in the response.
  public let includeAnswers: Bool

  /// Whether to include raw content in the search results.
  public let includeRawContent: Bool

  /// List of domains to restrict search results to.
  /// If empty, searches across all domains.
  public let includeDomains: [String]?

  /// List of domains to exclude from search results.
  public let excludeDomains: [String]?

  /// Creates a new search parameters configuration.
  ///
  /// - Parameters:
  ///   - query: The search query string to execute
  ///   - searchDepth: The depth level of search to perform. Defaults to `.basic`
  ///   - topic: The topic category to search within. Defaults to `.general`
  ///   - days: Optional number of days to limit results to
  ///   - maxResults: Optional maximum number of results to return
  ///   - includeImages: Whether to include image results. Defaults to `false`
  ///   - includeImageDescriptions: Whether to include image descriptions. Defaults to `false`
  ///   - includeAnswers: Whether to include AI-generated answers. Defaults to `false`
  ///   - includeRawContent: Whether to include raw content. Defaults to `false`
  ///   - includeDomains: List of domains to restrict results to. Defaults to empty
  ///   - excludeDomains: List of domains to exclude. Defaults to empty
  public init(
    query: String,
    searchDepth: SearchDepth = .basic,
    topic: Topic? = nil,
    includeAnswers: Bool = false,
    includeRawContent: Bool = false,
    includeImages: Bool = false,
    includeImageDescriptions: Bool = false,
    includeDomains: [String]? = nil,
    excludeDomains: [String]? = nil,
    maxResults: Int? = nil,
    days: Int? = nil
  ) {
    self.query = query
    self.searchDepth = searchDepth
    self.topic = topic
    self.includeAnswers = includeAnswers
    self.includeRawContent = includeRawContent
    self.includeImages = includeImages
    self.includeImageDescriptions = includeImageDescriptions
    self.includeDomains = includeDomains
    self.excludeDomains = excludeDomains
    self.maxResults = maxResults
    self.days = days
  }
}

/// Specifies the depth level of search to perform.
public enum SearchDepth: String {
  /// Basic search that returns standard results.
  case basic = "basic"
  /// Advanced search that may include additional metadata and analysis.
  case advanced = "advanced"
}

/// Specifies the topic category to search within.
public enum Topic: String {
  /// General web search across all topics.
  case general = "general"
  /// Search specifically within news content.
  case news = "news"
}
