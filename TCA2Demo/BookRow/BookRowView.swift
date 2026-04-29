import SwiftUI

struct BookRowView: View {
    let book: Book

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(book.title)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(book.year)
                    .foregroundStyle(.secondary)
            }
            Text(book.author)
                .foregroundStyle(.secondary)
        }
    }

    init(_ book: Book) {
        self.book = book
    }
}
