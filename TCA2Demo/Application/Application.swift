import ComposableArchitecture2
import SwiftUI

@main
struct Application: App {
    static let store: StoreOf<BookListFeature> = .init(initialState: .init()) {
        BookListFeature()
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                BookListView(store: Self.store)
                    .navigationTitle("Books")
            }
        }
    }
}
