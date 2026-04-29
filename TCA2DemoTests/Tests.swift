import ComposableArchitecture2
import Foundation
import Testing
@testable import TCA2Demo

struct Tests {
    @MainActor @Test
    func addBookFeatureBookTapped() {
        let store = TestStore(initialState: .init()) {
            AddBookFeature()
        }

        let book = Book(id: "", author: "", coverID: "", title: "", year: "")
        store.send(.bookTapped(book))
        // How to test event?
    }

    @MainActor @Test
    func someFeatureIncrement() {
        let store = withDependencies {
            $0.continuousClock = .immediate
        } operation: {
            TestStore(initialState: .init()) {
                SomeFeature()
            }
        }

        store.send(.increment) {
            $0.count = 2
        }
    }

    @MainActor @Test
    func someFeatureIncrementWithTestClock() async {
        let testClock = TestClock()
        let store = withDependencies {
            $0.continuousClock = testClock
        } operation: {
            TestStore(initialState: .init()) {
                SomeFeature()
            }
        }

        store.send(.increment) {
            $0.count = 1
        }
        await testClock.advance(by: .seconds(1))
        store.expect {
            $0.count = 2
        }
    }
}

@Feature struct SomeFeature {
    struct State {
        var count = 0
    }

    enum Action {
        case increment
    }

    var body: some Feature {
        Update { state, action in
            switch action {
            case .increment:
                state.count += 1
                store.addTask {
                    @Dependency(\.continuousClock) var clock
                    try await clock.sleep(for: .seconds(1))
                    try store.modify {
                        $0.count += 1
                    }
                }
            }
        }
    }
}
