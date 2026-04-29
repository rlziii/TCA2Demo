struct SearchResponse: Decodable {
    let start: Int
    let numFound: Int
    let docs: [Book]
}
