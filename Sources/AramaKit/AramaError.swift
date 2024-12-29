/// Errors that can occur when using the Arama search API.
public enum AramaError: Error {

  /// The provided URL was invalid or could not be constructed.
  case invalidURL

  /// An error occurred during the network request.
  /// - Parameter error: The underlying network error that occurred.
  case networkError(Error)

  /// The API response was invalid or could not be parsed.
  case invalidResponse

  /// The API returned an error message.
  /// - Parameter message: The error message returned by the API.
  case apiError(String)
}
