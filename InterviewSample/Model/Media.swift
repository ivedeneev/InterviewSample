import Foundation

/// Same track might occur multiple time in the search feed so we cannot rely on any of id's presented in the model
/// to uniqely identify object in the array.
///
/// However, we must be able to do it to use this model in `ForEach` loop. One of the possible solutions is:
/// - accept duplications (its a demo after all :) )
/// - create unique `id`  property like `UUID().uuidString`
/// - override `==` function to be able to compare two `Media` objects. This is needed in unit tests in our case (see `SearchMediaServiceTests.swift`)
///
/// Ideally backend should not return duplicate objects and each object should have `id` property
struct Media: Decodable, Identifiable, Hashable {

    let id = UUID().uuidString
    let wrapperType: WrapperType
    var trackId: Int?
    var artistId: Int
    var collectionId: Int?
    let trackName: String?
    let artistName: String
    let collectionName: String?
    let trackTimeMillis: Int?
    let shortDescription: String?
    let longDescription: String?
    let artworkUrl60: URL?
    let artworkUrl100: URL?
    let kind: Kind?
    let releaseDate: Date?
    var lengthInSeconds: Int {
        (trackTimeMillis ?? 0) / 1000
    }
    
    var localized: String {
        switch wrapperType {
        case .track:
            guard let kind else { return "" }
            switch kind {
            case .album:
                return "Album"
            case .song:
                return "Song"
            case .artist:
                return "Artist"
            case .musicVideo:
                return "Video"
            }
        case .artist:
            return "Artist"
        case .collection:
            return "Collection"
        }
    }

}

//MARK: - Equitable
extension Media {
    static func == (lhs: Media, rhs: Media) -> Bool {
        if let left = lhs.trackId, let right = rhs.trackId {
            return left == right
        }
        
        if let left = lhs.collectionId, let right = rhs.collectionId {
            return left == right
        }
        
        return lhs.artistId == rhs.artistId
    }
}

//MARK: - Nested types
extension Media {
    enum Kind: String, Decodable {
        case album
        case song
        case artist
        case musicVideo = "music-video"
    }
    
    enum WrapperType: String, Decodable {
        case track
        case collection
        case artist
    }
}
