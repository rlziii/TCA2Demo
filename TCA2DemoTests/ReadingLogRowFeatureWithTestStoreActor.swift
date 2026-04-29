import ComposableArchitecture2
import Foundation
import Testing
@testable import TCA2Demo

struct ReadingLogRowFeatureWithTestStoreActor {
    @Test
    func basicSetup() async {
        let store = await testStore()
        await #expect(store.id == .sunday)
        await #expect(store.weekday == .sunday)
        await #expect(store.minutes == 0)
        await #expect(store.weekdayTitle == "SUN")
    }

    @Test
    func decrementWillNotGoBelowZero() async {
        let store = await testStore()
        await store.send(.decrementButtonTapped)
    }

    @Test
    func decrement() async {
        let store = await testStore(minutes: 1)
        await store.send(.decrementButtonTapped) {
            $0.minutes = 0
        }
    }

    @Test
    func increment() async {
        let store = await testStore()
        await store.send(.incrementButtonTapped) {
            $0.minutes = 1
        }
    }

    @Test
    func reset() async {
        let store = await testStore(minutes: 42)
        await store.send(.resetButtonTapped) {
            $0.minutes = 0
        }
    }

    @Test
    func resetTrigger() async throws {
        let store = await testStore(minutes: 42)
        await store.modify {
            $0.reset()
        } changes: {
            $0.minutes = 0
        }
    }

    private func testStore(minutes: Int = 0) async -> TestStoreActor<ReadingLogRowFeature> {
        await TestStoreActor(
            initialState: .init(
                weekday: .sunday,
                minutes: minutes
            )
        ) {
            ReadingLogRowFeature()
        }
    }
}
