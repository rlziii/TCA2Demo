import ComposableArchitecture1
import SwiftUI

struct ChildSettingsView: View {
    let store: StoreOf<ChildSettingsReducer>

    var body: some View {
        Form {
            HStack {
                Text(String(store.count))
                    .monospacedDigit()

                Spacer()

                Button("", systemImage: "plus") {
                    store.send(.incrementButtonTapped)
                }
            }
        }
    }
}
