import ComposableArchitecture2
import SwiftUI

struct ReadingLogRowView: View {
    let store: StoreOf<ReadingLogRowFeature>

    var body: some View {
        HStack {
            Text(store.weekdayTitle)
                .monospaced()

            Text("^[\(store.minutes) minute](inflect: true)")
                .monospacedDigit()
                .frame(maxWidth: .infinity)

            Button("", systemImage: "minus") {
                store.send(.decrementButtonTapped)
            }
            .padding(.vertical)
            .contentShape(.rect)
            .buttonRepeatBehavior(.enabled)

            Button("", systemImage: "arrow.uturn.backward") {
                store.send(.resetButtonTapped)
            }
            .padding(.vertical)
            .contentShape(.rect)

            Button("", systemImage: "plus") {
                store.send(.incrementButtonTapped)
            }
            .padding(.vertical)
            .contentShape(.rect)
            .buttonRepeatBehavior(.enabled)
        }
        .buttonStyle(.plain)
    }
}
