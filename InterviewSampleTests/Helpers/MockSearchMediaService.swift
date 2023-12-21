import Foundation
@testable import InterviewSample

final class MockSearchMediaService: SearchMediaService {
    
    static var mediaListResponse: MediaListResponse?
    
    func searchMedia(query: String, limit: Int, offset: Int) async throws -> MediaListResponse {
        guard let response = Self.mediaListResponse else {
            throw Errors.dataIsMissingOrInIncorrectFormat
        }
        
        return response
    }
    
    func albums(artistId: Int) async throws -> [Media] {
        fatalError("Not implemented")
    }
    
    func songs(artistId: Int) async throws -> [Media] {
        fatalError("Not implemented")
    }
}
