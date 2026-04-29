import ComposableArchitecture2
import SwiftUINavigation
import SwiftUI

struct ReadingLogListView: View {
    @Bindable var store: StoreOf<ReadingLogListFeature>

    var body: some View {
        List {
            Section("Note") {
                Text(store.note)
                Button("Update Note") {
                    store.send(.updateNoteButtonTapped)
                }
            }

            Section("Info") {
                LabeledContent {
                    Image(systemName: "star")
                        .symbolVariant(store.readingGoalReached ? .fill : .none)
                        .foregroundStyle(.yellow)
                } label: {
                    Text("Reading Goal (30 minutes)")
                }

                Button("Reset All") {
                    store.send(.resetAllButtonTapped)
                }
            }

            Section("Weekdays") {
                ForEach(store.spawn(\.readingLogs)) { store in
                    ReadingLogRowView(store: store)
                        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                }
            }
        }
        .alert(item: $store.scope(state: \.destination, action: \.destination).alert) {
            Text($0.title)
        } actions: { $store in
            Button("Reset All", role: .destructive) {
                withAnimation {
                    _ = store.send(.resetAll)
                }
            }

            Button("Cancel", role: .cancel) {
                store.send(.cancel)
            }
        }
        .navigationDestination(item: $store.scope(state: \.readingLogNote, action: \.readingLogNote)) { store in
            ReadingLogNoteView(store: store)
                .navigationTitle("Reading Log Note")
        }
    }
}
