import ComposableArchitecture2
import SwiftUI

struct BookListView: View {
    @Bindable var store: StoreOf<BookListFeature>

    var body: some View {
        List {
            if store.showLoadCoversButton {
                Section {
                    Button("Load Covers") {
                        store.send(.loadCoversButtonTapped)
                    }
                    .disabled(!store.loadCoversButtonEnabled)
                }
            }
            Section {
                ForEach(store.scope(state: \.books, action: \.books)) { store in
                    BookListRowView(store: store)
                }
                .onDelete { indexSet in
                    store.send(.onDeleteBooks(indexSet))
                }
            }
        }
        .sheet(item: $store.scope(state: \.destination, action: \.destination).addBookSheet) { addBookStore in
            NavigationStack {
                AddBookView(store: addBookStore)
                    .navigationTitle("Search Books")
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(role: .close) {
                                store.send(.closeAddBookSheetButtonTapped)
                            }
                        }
                    }
            }
        }
        .sheet(item: $store.scope(state: \.destination, action: \.destination).readingLogListSheet) { readingLogListStore in
            NavigationStack {
                ReadingLogListView(store: readingLogListStore)
                    .navigationTitle("Reading Log")
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(role: .close) {
                                store.send(.closeReadingLogListSheetButtonTapped)
                            }
                        }
                    }
            }
        }
        .sheet(item: $store.scope(state: \.destination, action: \.destination).settingsSheet) { settingsStore in
            NavigationStack {
                SettingsView(store: settingsStore)
                    .navigationTitle("Settings")
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(role: .close) {
                                store.send(.closeSettingsSheetButtonTapped)
                            }
                        }
                    }
            }
        }
        .overlay {
            if store.books.isEmpty {
                ContentUnavailableView(
                    "No Books",
                    systemImage: "book.fill",
                    description: Text("New books you save will appear here.")
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button("Reading Log", systemImage: "list.bullet.rectangle.portrait") {
                        store.send(.readingLogListButtonTapped)
                    }

                    Button("Settings", systemImage: "gearshape") {
                        store.send(.settingsButtonTapped)
                    }
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Book", systemImage: "plus") {
                    store.send(.addBookButtonTapped)
                }
            }
        }
    }
}
