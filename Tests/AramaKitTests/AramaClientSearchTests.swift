import XCTest

@testable import AramaKit

final class AramaClientSearchTests: XCTestCase {
  var client: AramaClient!
  let mockAPIKey = "tvly-mock-api-key"

  override func setUp() {
    super.setUp()
    client = AramaClient(apiKey: mockAPIKey)
  }

  override func tearDown() {
    client = nil
    super.tearDown()
  }

  func testBasicSearch() async throws {
    // Given
    let query = "What is CES 2025?"
    let parameters = SearchParameters(query: query)

    // When
    let response = try await client.search(parameters)

    // Then
    XCTAssertEqual(response.query, query)
    XCTAssertFalse(response.results.isEmpty)
    XCTAssertGreaterThan(response.responseTime, 0)
  }

  func testAdvancedSearch() async throws {
    // Given
    let parameters = SearchParameters(
      query: "Latest news about CES 2025",
      searchDepth: .advanced,
      topic: .news,
      includeAnswers: true,
      includeRawContent: true,
      includeImages: true,
      includeImageDescriptions: true,
      includeDomains: ["techcrunch.com"],
      excludeDomains: ["reddit.com"],
      maxResults: 10,
      days: 7
    )

    // When
    let response = try await client.search(parameters)

    // Then
    XCTAssertNotNil(response.answer)
    XCTAssertNotNil(response.images)
    XCTAssertFalse(response.results.isEmpty)
    XCTAssertLessThanOrEqual(response.results.count, 10)

    // Verify domain filtering
    for result in response.results {
      XCTAssertTrue(result.url.contains("techcrunch.com"))
      XCTAssertFalse(result.url.contains("reddit.com"))
    }

    // Verify raw content and published dates
    for result in response.results {
      XCTAssertNotNil(result.rawContent)
      XCTAssertNotNil(result.publishedDate)
    }

    // Verify image descriptions
    if let images = response.images {
      for image in images {
        XCTAssertNotNil(image.description)
      }
    }
  }

  func testInvalidAPIKey() async {
    // Given
    let invalidClient = AramaClient(apiKey: "invalid-key")
    let parameters = SearchParameters(query: "Test query")

    // When/Then
    do {
      _ = try await invalidClient.search(parameters)
      XCTFail("Expected error for invalid API key")
    } catch AramaError.apiError {
      // Success - expected error
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }

  func testEmptyQuery() async {
    // Given
    let parameters = SearchParameters(query: "")

    // When/Then
    do {
      _ = try await client.search(parameters)
      XCTFail("Expected error for empty query")
    } catch AramaError.apiError {
      // Success - expected error
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }

  func testMaxResultsLimit() async throws {
    // Given
    let parameters = SearchParameters(
      query: "Test query",
      maxResults: 3
    )

    // When
    let response = try await client.search(parameters)

    // Then
    XCTAssertLessThanOrEqual(response.results.count, 3)
  }

  func testNewsTopicWithDays() async throws {
    // Given
    let parameters = SearchParameters(
      query: "Test news",
      topic: .news,
      days: 3
    )

    // When
    let response = try await client.search(parameters)

    // Then
    for result in response.results {
      if let publishedDate = result.publishedDate {
        // Verify the published date is within the last 3 days
        let date = ISO8601DateFormatter().date(from: publishedDate)
        XCTAssertNotNil(date)
        if let date = date {
          let daysDifference =
            Calendar.current.dateComponents(
              [.day],
              from: date,
              to: Date()
            ).day ?? 0
          XCTAssertLessThanOrEqual(daysDifference, 3)
        }
      }
    }
  }

  func testSearchDepthValues() async throws {
    // Test basic search depth
    let basicParameters = SearchParameters(
      query: "Test query",
      searchDepth: .basic
    )
    let basicResponse = try await client.search(basicParameters)
    XCTAssertNotNil(basicResponse)

    // Test advanced search depth
    let advancedParameters = SearchParameters(
      query: "Test query",
      searchDepth: .advanced
    )
    let advancedResponse = try await client.search(advancedParameters)
    XCTAssertNotNil(advancedResponse)
  }
}
