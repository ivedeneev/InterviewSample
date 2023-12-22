import Foundation
import XCTest
@testable import InterviewSample

class SearchMediaServiceTests: XCTestCase {
    
    var httpClient: MockHttpClient!
    var session: URLSession!
    var requestBuilder: RequestBuilderImpl!
    var decoder: JSONDecoder!
    
    var service: SearchMediaServiceImpl!
    
    override func setUp() {
        httpClient = MockHttpClient()
        decoder = Dependencies.shared.jsonDecoder()
        service = SearchMediaServiceImpl(httpClient: httpClient, decoder: decoder)
        super.setUp()
    }
    
    override func tearDown() {
        httpClient = nil
        decoder = nil
        service = nil
        super.tearDown()
   }
    
    func testSearch() async throws {
        // Mocking response data for albums method
        let mockResponse = MediaListResponse(
            resultCount: 2,
            results: [
                Media(wrapperType: .collection),
                Media(wrapperType: .track)
            ]
        )
        httpClient.stubResponse = mockResponse
        
        do {
            let result = try await service.searchMedia(query: "song", limit: 10, offset: 0)
            XCTAssertEqual(mockResponse, result)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testAlbums() async throws {
        // Mocking response data for albums method
        let mockResponse = MediaListResponse(
            resultCount: 2,
            results: [
                Media(wrapperType: .collection),
                Media(wrapperType: .track) // This shouldn't be included in the returned array
            ]
        )
        httpClient.stubResponse = mockResponse
        
        do {
            let result = try await service.albums(artistId: 123)
            XCTAssertEqual(result.count, 1, "Should return only items with wrapperType .collection")
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testSongs() async throws {
        // Mocking response data for songs method
        let mockResponse = MediaListResponse(
            resultCount: 2,
            results: [
                Media(wrapperType: .collection), // This shouldn't be included in the returned array
                Media(wrapperType: .track)
            ]
        )
        httpClient.stubResponse = mockResponse
        
        do {
            let result = try await service.songs(artistId: 123)
            XCTAssertEqual(result.count, 1, "Should return only items with wrapperType .track")
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
}
