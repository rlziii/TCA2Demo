import ComposableArchitecture2
import SwiftNavigation
import SwiftUI

struct AddBookView: View {
    @Bindable var store: StoreOf<AddBookFeature>
    @FocusState private var searchFocused

    var body: some View {
        List {
            ForEach(store.books) { book in
                Button {
                    store.send(.bookTapped(book))
                } label: {
                    BookRowView(book)
                }
            }
        }
        .searchable(text: $store.searchTerm)
        .searchFocused($searchFocused)
        .searchPresentationToolbarBehavior(.avoidHidingContent)
        .bind($store.searchFocused, to: $searchFocused)
        .overlay {
            if store.bookRequest.isRunning {
                LoadingView()
            } else if store.books.isEmpty {
                ContentUnavailableView.search
            }
        }
    }
}

private extension AddBookView {
    struct LoadingView: View {
        var body: some View {
            ProgressView()
                .padding()
                .background(.background)
                .clipShape(.rect(cornerRadius: 8))
                .shadow(radius: 4)
        }
    }
}
