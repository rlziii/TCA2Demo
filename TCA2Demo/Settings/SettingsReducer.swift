import ComposableArchitecture1
import Foundation

@Reducer struct SettingsReducer {
    @Reducer enum Destination {
        case childSettings(ChildSettingsReducer)
    }

    @ObservableState struct State: Equatable {
        @Presents var destination: Destination.State?
        var isLoading = false
        var toggle = false
        var value = ""
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case didFinishUpdateValue
        case goToChildSettingsButtonTapped
        case onAppear
        case updateValueButtonTapped
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .destination:
                return .none
            case .didFinishUpdateValue:
                state.isLoading = false
                state.value = String(UUID().uuidString.prefix(8))
                return .none
            case .goToChildSettingsButtonTapped:
                state.destination = .childSettings(.init())
                return .none
            case .onAppear:
                state.value = String(UUID().uuidString.prefix(8))
                return .none
            case .updateValueButtonTapped:
                state.isLoading = true
                return .run { send in
                    try await Task.sleep(for: .seconds(1))
                    await send(.didFinishUpdateValue)
                }
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension SettingsReducer.Destination.State: Equatable { }
