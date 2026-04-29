import ComposableArchitecture2
import Foundation

@Feature struct BookListRowFeature {
    struct State: Identifiable {
        var id: Book.ID { book.id }
        let book: Book
        var imageData: Data?
        @Trigger var loadImage
    }

    enum Action {
        case removeImageButtonTapped
    }

    var body: some Feature {
        Update { state, action in
            switch action {
            case .removeImageButtonTapped:
                state.imageData = nil
            }
        }
        .onTrigger(store.loadImage) { _ in
            store.addTask {
                @Dependency(\.openLibrary) var openLibrary
                let imageData = try await openLibrary.cover(id: store.book.coverID)
                try store.modify {
                    $0.imageData = imageData
                }
            }
        }
    }
}
