import Foundation
@testable import InterviewSample

final class MockSearchMediaService: SearchMediaService {
    
    var stubResponse: MediaListResponse?
    
    func searchMedia(query: String, limit: Int, offset: Int) async throws -> MediaListResponse {
        try returnStubResponse()
    }
    
    func albums(artistId: Int) async throws -> [Media] {
        try returnStubResponse().results
    }
    
    func songs(artistId: Int) async throws -> [Media] {
        try returnStubResponse().results
    }
    
    private func returnStubResponse() throws -> MediaListResponse {
        guard let response = stubResponse else {
            throw Errors.dataIsMissingOrInIncorrectFormat
        }
        
        return response
    }
}
