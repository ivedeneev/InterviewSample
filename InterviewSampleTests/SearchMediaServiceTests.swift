import Foundation
import XCTest
@testable import InterviewSample

class SearchMediaServiceTests: XCTestCase {
    
    var httpClient: HttpClientImpl!
    var session: URLSession!
    var requestBuilder: RequestBuilderImpl!
    var decoder: JSONDecoder!
    
    var service: SearchMediaServiceImpl!
    
    override func setUp() async throws {
        try await super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        httpClient = HttpClientImpl(session: session)
        decoder = Dependencies.shared.jsonDecoder()
        
        service = SearchMediaServiceImpl(httpClient: httpClient, decoder: decoder)
    }
    
    func testSearchMethodSendsCorrectArgumentsAndReturns() async throws {
        let expectedData = try dataFromJsonFile(path: "search")
        var requestUrl: URL?
        MockURLProtocol.requestHandler = { request in
            requestUrl = request.url
            return try (HTTPURLResponse(url: request.url, statusCode: 200, headers: [:]), expectedData)
        }
        
        let query = "cream soda"
        let limit = 10
        let offset = 0
        let result = try await service.searchMedia(query: query, limit: limit, offset: offset)
        let expectedResponse = try decoder.decode(MediaListResponse.self, from: expectedData)

        // check if all the arguments are indeed respected in the request
        guard let requestUrl,
              let queryItems = URLComponents(url: requestUrl, resolvingAgainstBaseURL: true)?.queryItems
        else {
            throw Errors.urlQueryMissing
        }
        let termComp = queryItems.first(where: { $0.value == query })
        let limitComp = queryItems.first(where: { $0.name == "limit" && $0.value == "\(limit)" })
        let offsetComp = queryItems.first(where: { $0.name == "offset" && $0.value == "\(offset)" })
        
        XCTAssertNotNil(termComp)
        XCTAssertNotNil(limitComp)
        XCTAssertNotNil(offsetComp)
        
        // compare expected and actualResponse
        XCTAssertEqual(result, expectedResponse)
    }
}
