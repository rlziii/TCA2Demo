import ComposableArchitecture2
import SwiftUI

struct ReadingLogNoteView: View {
    @Bindable var store: StoreOf<ReadingLogNoteFeature>
    @FocusState private var focused

    var body: some View {
        Form {
            Section {
                TextField("Note", text: $store.note)
                    .focused($focused)
            }

            Section {
                Button("Save") {
                    store.send(.saveButtonTapped)
                }
            }
        }
        .onAppear {
            focused = true
        }
    }
}
