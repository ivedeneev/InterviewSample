import Foundation

protocol SearchMediaService {
    func searchMedia(query: String, limit: Int, offset: Int) async throws -> MediaListResponse
    func albums(artistId: Int) async throws -> [Media]
    func songs(artistId: Int) async throws -> [Media]
}

final class SearchMediaServiceImpl: SearchMediaService {
    
    private let httpClient: HttpClient
    private let decoder: JSONDecoder
    
    init(httpClient: HttpClient, decoder: JSONDecoder) {
        self.httpClient = httpClient
        self.decoder = decoder
    }
    
    func searchMedia(query: String, limit: Int, offset: Int) async throws -> MediaListResponse {
        try await httpClient.send(
            request: NetworkRequest.search(query: query, limit: limit, offset: offset),
            decoder: decoder
        )
    }
    
    func albums(artistId: Int) async throws -> [Media] {
        let response: MediaListResponse = try await httpClient.send(
            request: NetworkRequest.media(artistId: artistId, mediaType: "album", limit: 10, offset: 0),
            decoder: decoder
        )
        
        return response.results.filter { $0.wrapperType == .collection }
    }
    
    func songs(artistId: Int) async throws -> [Media] {
        let response: MediaListResponse = try await httpClient.send(
            request: NetworkRequest.media(artistId: artistId, mediaType: "song", limit: 10, offset: 0),
            decoder: decoder
        )
        
        return response.results.filter { $0.wrapperType == .track }
    }
}
