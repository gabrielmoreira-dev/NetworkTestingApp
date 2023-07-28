struct Movie: Decodable, Equatable, Identifiable {
    let id: Int
    let title: String
    let imageURL: String
}
