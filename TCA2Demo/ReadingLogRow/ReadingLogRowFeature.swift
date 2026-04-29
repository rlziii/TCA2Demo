import ComposableArchitecture2
import Foundation

@Feature struct ReadingLogRowFeature {
    struct State: Identifiable {
        var id: Locale.Weekday { weekday }
        let weekday: Locale.Weekday
        var minutes = 0
        @Trigger var reset

        var weekdayTitle: String {
            weekday.rawValue.uppercased()
        }
    }

    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case resetButtonTapped
    }

    var body: some Feature {
        Update { state, action in
            switch action {
            case .decrementButtonTapped:
                guard state.minutes > 0 else { return }
                state.minutes -= 1
            case .incrementButtonTapped:
                state.minutes += 1
            case .resetButtonTapped:
                state.minutes = 0
            }
        }
        .preference(key: ReadingLogListFeature.TotalMinutesPreference.self, value: store.minutes)
        .onTrigger(store.reset) { state in
            state.minutes = 0
        }
    }
}
