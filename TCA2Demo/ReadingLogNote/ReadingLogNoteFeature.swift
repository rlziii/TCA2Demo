import ComposableArchitecture2

@Feature struct ReadingLogNoteFeature {
    struct State {
        var note = ""
    }

    enum Action {
        case saveButtonTapped
    }

    let onSave: (String) throws -> Void

    var body: some Feature {
        Update { state, action in
            switch action {
            case .saveButtonTapped:
                store.addTask {
                    try onSave(store.note)
                }
            }
        }
    }
}
