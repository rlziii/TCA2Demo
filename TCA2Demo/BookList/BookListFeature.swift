import ComposableArchitecture2
import Foundation
import SwiftUI // For `RangeReplaceableCollection.remove(atOffsets:)`

@Feature struct BookListFeature {
    @Feature enum Destination {
        case addBookSheet(AddBookFeature)
        case readingLogListSheet(Spawn<ReadingLogListFeature>)
        case settingsSheet(Spawn<SettingsReducer>)
    }

    struct State {
        var books: [BookListRowFeature.State] = []
        var destination: Destination.State?

        var showLoadCoversButton: Bool {
            !books.isEmpty
        }

        var loadCoversButtonEnabled: Bool {
            books.reduce(false) { $1.imageData == nil }
        }
    }

    enum Action {
        case addBookButtonTapped
        case books(BookListRowFeature.State.ID, BookListRowFeature.Action)
        case closeAddBookSheetButtonTapped
        case closeReadingLogListSheetButtonTapped
        case closeSettingsSheetButtonTapped
        case readingLogListButtonTapped
        case destination(Destination.Action)
        case onDeleteBooks(IndexSet)
        case loadCoversButtonTapped
        case settingsButtonTapped
    }

    var body: some Feature {
        Update { state, action in
            switch action {
            case .addBookButtonTapped:
                state.destination = .addBookSheet(.init())
            case .books:
                break
            case .closeAddBookSheetButtonTapped:
                state.destination = nil
            case .closeReadingLogListSheetButtonTapped:
                state.destination = nil
            case .closeSettingsSheetButtonTapped:
                state.destination = nil
            case .readingLogListButtonTapped:
                state.destination = .readingLogListSheet(Spawn(.init()))
            case .destination:
                break
            case let .onDeleteBooks(indexSet):
                state.books.remove(atOffsets: indexSet)
            case .loadCoversButtonTapped:
                for var book in state.books where book.imageData == nil {
                    book.loadImage()
                }
            case .settingsButtonTapped:
                state.destination = .settingsSheet(Spawn(.init()))
            }
        }
        .forEach(\.books, action: \.books) {
            BookListRowFeature()
        }
        .ifLet(\.destination, action: \.destination) {
            Destination.body
        }
        .onEvent(AddBookFeature.AddBookEvent.self) { book, state in
            state.books.append(BookListRowFeature.State(book: book))
            state.destination = nil
        }
    }
}
