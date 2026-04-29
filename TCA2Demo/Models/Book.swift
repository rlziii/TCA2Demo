struct Book: Decodable, Identifiable {
    let id: String
    let author: String
    let coverID: String
    let title: String
    let year: String

    enum CodingKeys: CodingKey {
        case author_name
        case cover_edition_key
        case first_publish_year
        case key
        case title
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .key)
        self.author = try container.decodeIfPresent([String].self, forKey: .author_name)?.first ?? "---"
        self.coverID = try container.decodeIfPresent(String.self, forKey: .cover_edition_key) ?? "---"
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? "---"
        self.year = String(try container.decodeIfPresent(Int.self, forKey: .first_publish_year) ?? 0)
    }

    init(id: String, author: String, coverID: String, title: String, year: String) {
        self.id = id
        self.author = author
        self.coverID = coverID
        self.title = title
        self.year = year
    }
}
