import ComposableArchitecture2
import SwiftUI

struct BookListRowView: View {
    @Bindable var store: StoreOf<BookListRowFeature>

    var body: some View {
        HStack {
            ImageView(data: store.imageData) {
                store.send(.removeImageButtonTapped)
            }

            BookRowView(store.book)
        }
    }
}

private extension BookListRowView {
    struct ImageView: View {
        let data: Data?
        let action: () -> Void

        var body: some View {
            if let data, let image = UIImage(data: data) {
                Button(action: action) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 100)
                        .overlay(alignment: .bottomTrailing) {
                            Image(systemName: "xmark.circle.fill")
                                .padding(2)
                                .foregroundStyle(.red)
                                .background {
                                    Color.black
                                        .clipShape(.rect(cornerRadii: .init(topLeading: 4)))
                                }
                        }
                        .clipShape(.rect(cornerRadius: 4))
                }
                .buttonStyle(.plain)
            }
        }
    }
}
