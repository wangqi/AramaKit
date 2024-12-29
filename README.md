# AramaKit

AramaKit is an unofficial Swift SDK for Tavily's Search and Extract APIs. The name "Arama" comes from the Turkish word for "search," making it a perfect fit for this search-focused package.

## Features

- Modern async/await API
- iOS 16.0+, macOS 13.0+, and visionOS 1.0+ support
- Support for both basic and advanced search depths
- Support for news and general search topics
- Image search with descriptions
- Domain filtering
- Raw content access
- Extract raw content from any webpage
- Batch URL content extraction

## Requirements

- iOS 16.0 or later
- macOS 13.0 or later
- visionOS 1.0 or later
- Swift 6.0 or later
- [Tavily API Key](https://tavily.com)

## Installation

Add AramaKit to your Swift package dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/rryam/AramaKit.git", from: "1.0.0")
]
```

## Usage

### Basic Search

```swift
import AramaKit

let client = AramaClient(apiKey: "your-tavily-api-key")

// Basic search with default parameters
let parameters = SearchParameters(query: "What is CES 2025?")
let response = try await client.search(parameters)

// Access search results
for result in response.results {
    print(result.title)
    print(result.url)
    print(result.content)
}
```

### Advanced Search with All Options

```swift
let parameters = SearchParameters(
    query: "Latest news about CES 2025",
    searchDepth: .advanced,
    topic: .news,
    days: 7,
    maxResults: 10,
    includeImages: true,
    includeImageDescriptions: true,
    includeAnswers: true,
    includeRawContent: true,
    includeDomains: ["techcrunch.com", "theverge.com"],
    excludeDomains: ["reddit.com"]
)

let response = try await client.search(parameters)

// Access the AI-generated answer
if let answer = response.answer {
    print("AI Answer: \(answer)")
}

// Access images with descriptions
if let images = response.images {
    for image in images {
        print("Image URL: \(image.url)")
        if let description = image.description {
            print("Description: \(description)")
        }
    }
}

// Access search results with raw content
for result in response.results {
    print("Title: \(result.title)")
    print("URL: \(result.url)")
    print("Content: \(result.content)")
    print("Score: \(result.score)")
    if let rawContent = result.rawContent {
        print("Raw Content: \(rawContent)")
    }
    if let publishedDate = result.publishedDate {
        print("Published Date: \(publishedDate)")
    }
}

print("Response Time: \(response.responseTime) seconds")
```

### Extract Content from URLs

```swift
// Extract content from a single URL
let extractResponse = try await client.extract(url: "https://example.com")

// Access the extracted content
if let result = extractResponse.results.first {
    print("URL: \(result.url)")
    print("Raw Content: \(result.rawContent)")
}

// Extract content from multiple URLs
let urls = [
    "https://example.com/page1",
    "https://example.com/page2",
    "https://invalid-url"
]
let multiResponse = try await client.extract(urls: urls)

// Access successful extractions
for result in multiResponse.results {
    print("URL: \(result.url)")
    print("Raw Content: \(result.rawContent)")
}

// Check for failed extractions
for failure in multiResponse.failedResults {
    print("Failed URL: \(failure.url)")
    print("Error: \(failure.error)")
}

print("Response Time: \(multiResponse.responseTime) seconds")
```

## License

AramaKit is available under the MIT license.