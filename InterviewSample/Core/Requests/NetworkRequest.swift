import Foundation

enum NetworkRequest: NetworkRequestType {
    
    case search(query: String, limit: Int, offset: Int)
    case media(artistId: Int, mediaType: String, limit: Int, offset: Int)
    
    var baseURL: String {
        "https://itunes.apple.com"
    }
    
    var path: String {
        switch self {
        case .search:
            return "search"
        case .media:
            return "lookup"
        }
    }
    
    var parameters: RequestParameters {
        switch self {
        case .search(let query, let limit, let offset):
            return [
                "term": query,
                "offset": String(offset),
                "limit": String(limit),
                "media": "music",
                "entity": "musicArtist,musicTrack,song"
            ]
        case .media(let artistId, let mediaType, let limit, let offset):
            return [
                "id" : String(artistId),
                "entity": mediaType,
                "offset": String(offset),
                "limit": String(limit),
            ]
        }
    }
    
    var headers: [String : String] { [:] }
    
    var method: HTTPMethod { .get }
}
