import Foundation

struct MediaListResponse: Decodable, Equatable {
    let resultCount: Int
    let results: [Media]
}
