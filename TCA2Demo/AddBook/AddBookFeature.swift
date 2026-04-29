import ComposableArchitecture2
import Foundation

@Feature struct AddBookFeature {
    struct State {
        var books: [Book] = []
        var searchTerm = ""
        var searchFocused = false

        @StoreTaskID var bookRequest
    }

    enum Action {
        case bookTapped(Book)
    }

    var body: some Feature {
        Update { state, action in
            switch action {
            case let .bookTapped(book):
                store.addTask {
                    try store.post(key: AddBookEvent.self, value: book)
                }
            }
        }
        .onChange(of: store.searchTerm) { state in
            store.addTask(id: state.bookRequest) {
                try await search(term: store.searchTerm)
            }
        }
    }

    private func search(term: String) async throws {
        @Dependency(\.openLibrary) var openLibrary
        do {
            let books = try await openLibrary.search(term: term)
            try store.modify {
                $0.books = books
            }
        } catch let error as URLError where error.code == .cancelled {
            // Do nothing.
        } catch {
            // Re-throw error.
            throw error
        }
    }
}

extension AddBookFeature {
    enum AddBookEvent: FeatureEventKey {
        typealias Value = Book
    }

    // Alternative way to write (better for multiple cases).
    enum Event: FeatureEventKey {
        case addBook(Book)
    }
}
