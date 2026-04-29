import ComposableArchitecture2
import Foundation
import Testing
@testable import TCA2Demo

struct ReadingLogRowFeatureWithTestStore {
    @MainActor @Test
    func basicSetup() {
        let store = testStore()
        #expect(store.id == .sunday)
        #expect(store.weekday == .sunday)
        #expect(store.minutes == 0)
        #expect(store.weekdayTitle == "SUN")
    }

    @MainActor @Test
    func decrementWillNotGoBelowZero() {
        let store = testStore()
        store.send(.decrementButtonTapped)
    }

    @MainActor @Test
    func decrement() {
        let store = testStore(minutes: 1)
        store.send(.decrementButtonTapped) {
            $0.minutes = 0
        }
    }

    @MainActor @Test
    func increment() {
        let store = testStore()
        store.send(.incrementButtonTapped) {
            $0.minutes = 1
        }
    }

    @MainActor @Test
    func reset() {
        let store = testStore(minutes: 42)
        store.send(.resetButtonTapped) {
            $0.minutes = 0
        }
    }

    @MainActor @Test
    func resetTrigger() throws {
        let store = testStore(minutes: 42)
        store.modify {
            $0.reset()
        } changes: {
            $0.minutes = 0
        }
    }

    @MainActor
    private func testStore(minutes: Int = 0) -> TestStore<ReadingLogRowFeature> {
        TestStore(
            initialState: .init(
                weekday: .sunday,
                minutes: minutes
            )
        ) {
            ReadingLogRowFeature()
        }
    }
}
