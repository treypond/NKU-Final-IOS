import Foundation

struct MarvelCharacterDataWrapper: Decodable {
    let data: MarvelCharacterContainer?
}

struct MarvelCharacterContainer: Decodable {
    let count: Int?
    let offset: Int?
    let total: Int?
    let results: [MarvelCharacter]?
}

struct MarvelCharacter: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: MarvelThumbnail?
}

struct MarvelThumbnail: Decodable {
    let path: String?
    let extensionType: String?

    enum CodingKeys: String, CodingKey {
        case path
        case extensionType = "extension"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.path = try container.decode(String.self, forKey: .path)
        self.extensionType = try container.decode(String.self, forKey: .extensionType)
    }
}

extension MarvelThumbnail {
    func getImageURL() -> URL? {
        guard let url = URL(string: "\(self.path!).\(self.extensionType!)") else {
            return nil
        }
        
        return url
    }
}


// Used for SwiftUI Preview data 
extension MarvelCharacter {
    
    static let ironMan = MarvelCharacter(id: 0, name: "Iron Man", description: "Tony Stark", thumbnail: nil)
    static let spiderMan = MarvelCharacter(id: 1, name: "Spider-Man", description: "Peter Park", thumbnail: nil)
    static let thor = MarvelCharacter(id: 2, name: "Thor", description: "God of Thunder", thumbnail: nil)
    static let characters = [MarvelCharacter.ironMan, MarvelCharacter.spiderMan, MarvelCharacter.thor]
}
