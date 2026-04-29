import ComposableArchitecture1
import SwiftUI

struct SettingsView: View {
    @Bindable var store: StoreOf<SettingsReducer>

    var body: some View {
        Form {
            Section("Toggle") {
                Toggle("Toggle", isOn: $store.toggle)
            }

            Section("Async Value Update") {
                Text(store.value)

                HStack {
                    Button("Update Value") {
                        store.send(.updateValueButtonTapped)
                    }
                    .disabled(store.isLoading)

                    if store.isLoading {
                        ProgressView()
                    }
                }
            }

            Section("Child Settings") {
                Button("Go To Child Settings") {
                    store.send(.goToChildSettingsButtonTapped)
                }
            }
        }
        .navigationDestination(
            item: $store.scope(state: \.$destination, action: \.destination).childSettings
        ) { store in
            ChildSettingsView(store: store)
                .navigationTitle("Child Settings")
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}
