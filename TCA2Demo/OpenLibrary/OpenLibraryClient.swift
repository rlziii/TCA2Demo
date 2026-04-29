import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
struct OpenLibraryClient {
    var cover: @Sendable (_ id: String) async throws -> Data
    var search: @Sendable (_ term: String) async throws -> [Book]
}

extension DependencyValues {
  var openLibrary: OpenLibraryClient {
    get { self[OpenLibraryClient.self] }
    set { self[OpenLibraryClient.self] = newValue }
  }
}

extension OpenLibraryClient: TestDependencyKey {
    static let testValue = Self()
}

extension OpenLibraryClient: DependencyKey {
    static var liveValue: Self {
        Self(
            cover: { id in
                guard let url = URL(string: "https://covers.openlibrary.org/b/olid/\(id)-M.jpg") else {
                    throw OpenLibraryError.invalidURL
                }
                return try await Self.fetchData(from: url)
            },
            search: { term in
                let term = term.replacingOccurrences(of: " ", with: "+")
                guard let url = URL(string: "https://openlibrary.org/search.json?q=\(term)") else {
                    throw OpenLibraryError.invalidURL
                }
                let data = try await Self.fetchData(from: url)
                return try JSONDecoder().decode(SearchResponse.self, from: data).docs
            }
        )
    }

    private static func fetchData(from url: URL) async throws -> Data {
        @Dependency(\.urlSession) var urlSession
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("TCA2Demo (rlziii@icloud.com)", forHTTPHeaderField: "User-Agent")
        let (data, response) = try await urlSession.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse else {
            throw OpenLibraryError.invalidResponse
        }
        guard response.statusCode == 200 else {
            throw OpenLibraryError.invalidStatusCode(response.statusCode)
        }
        return data
    }
}

extension OpenLibraryClient {
    enum OpenLibraryError: Error {
        case invalidResponse
        case invalidStatusCode(Int)
        case invalidURL
    }
}
