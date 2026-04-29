import ComposableArchitecture1

@Reducer struct ChildSettingsReducer {
    @ObservableState struct State: Equatable {
        var count = 0
    }

    enum Action {
        case incrementButtonTapped
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .incrementButtonTapped:
                state.count += 1
                return .none
            }
        }
    }
}
