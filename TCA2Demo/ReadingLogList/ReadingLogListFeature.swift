import ComposableArchitecture2
import Foundation

@Feature struct ReadingLogListFeature {
    @Feature enum Destination {
        case alert(Alert)

        @Feature struct Alert: Prompt {
            struct State {
                var title = "Are you sure you want to reset every day?"
            }

            enum Action {
                case cancel
                case resetAll
            }
        }
    }

    struct State {
        var destination: Destination.State?
        var note = "..."
        var readingLogNote: ReadingLogNoteFeature.State?
        var readingLogs: [Spawn<ReadingLogRowFeature>] = Locale.Weekday.allCases.map { .init(.init(weekday: $0)) }
        var readingGoalReached = false

        fileprivate var totalMinutes = 0
    }

    enum Action {
        case destination(Destination.Action)
        case readingLogNote(ReadingLogNoteFeature.Action)
        case resetAllButtonTapped
        case updateNoteButtonTapped
    }

    @FeatureLocal private var totalMinutes = 0

    var body: some Feature {
        Update { state, action in
            switch action {
            case let .destination(action):
                switch action {
                case let .alert(action):
                    switch action {
                    case .cancel:
                        break
                    case .resetAll:
                        for index in state.readingLogs.indices {
                            state.readingLogs[index].reset()
                        }
                    }
                }
            case .readingLogNote:
                break
            case .resetAllButtonTapped:
                state.destination = .alert(.init())
            case .updateNoteButtonTapped:
                state.readingLogNote = .init(note: state.note)
            }
        }
        .forEach(\.readingLogs) {
            ReadingLogRowFeature()
        }
        .ifLet(\.destination, action: \.destination) {
            Destination.body
        }
        .ifLet(\.readingLogNote, action: \.readingLogNote) {
            ReadingLogNoteFeature(
                onSave: { note in
                    try store.modify {
                        $0.note = note
                        $0.readingLogNote = nil
                    }
                }
            )
        }
        .onPreferenceChange(TotalMinutesPreference.self) { newValue, state in
            totalMinutes = newValue
            state.totalMinutes = newValue
            state.readingGoalReached = newValue >= 30
        }
    }
}

extension ReadingLogListFeature {
    enum TotalMinutesPreference: FeaturePreferenceKey {
        static let defaultValue = 0

        static func reduce(value: inout Value, nextValue: () -> Value) {
            value += nextValue()
        }
    }
}

extension Locale.Weekday {
    static let allCases: [Self] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
}
