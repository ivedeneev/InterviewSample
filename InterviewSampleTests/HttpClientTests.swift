import Foundation
import XCTest
@testable import Core

class HttpClientTests: XCTestCase {
    
    var httpClient: HttpClientImpl!
    var session: URLSession!
    var requestBuilder: RequestBuilderImpl!
    var decoder: JSONDecoder!
    
    override func setUp() async throws {
        try await super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        requestBuilder = RequestBuilderImpl()
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.dateFormatterForTests)
        httpClient = HttpClientImpl(session: session, requestBuilder: requestBuilder)
    }
    
    func testClientWithCustomDecoderReutnrsObjectAndHeadersOnSuccess() async throws {
        let expectedResponse = DummyDecodableResponse.instance()
        let expectedResponseData = try expectedResponse.encoded()
        let expectedHeaders = ["a": "b"]
        
        MockURLProtocol.requestHandler = { request in
            try (HTTPURLResponse(url: request.url, statusCode: 200, headers: expectedHeaders), expectedResponseData)
        }
        
        let result: HttpResponseWithHeaders<DummyDecodableResponse> =
                try await httpClient.send(request: MockNetworkRequest(), decoder: decoder)

        XCTAssertEqual(result.data, expectedResponse)
        XCTAssertEqual(result.headers, expectedHeaders)
    }
    
    func testClientReturnsVoidObjectOnSuccess() async throws {
        let expectedResponseData = "{}".data(using: .utf8)
        MockURLProtocol.requestHandler = { request in
            try (HTTPURLResponse(url: request.url, statusCode: 200, headers: [:]), expectedResponseData)
        }
        
        let _: VoidResponse = try await httpClient.send(request: MockNetworkRequest())
    }
    
    func testClientReturnsBackendError() async throws {
        let expectedResponseData = "{\"error\":\"unexpected error\"}".data(using: .utf8)
        let expectedStatusCode = 400
        MockURLProtocol.requestHandler = { request in
            try (HTTPURLResponse(url: request.url, statusCode: expectedStatusCode, headers: [:]), expectedResponseData)
        }
        
        do {
            let _: VoidResponse = try await httpClient.send(request: MockNetworkRequest())
        } catch NetworkError.backend(let code, let data) {
            XCTAssertEqual(expectedStatusCode, code)
            XCTAssertEqual(data, expectedResponseData)
        } catch {
            XCTFail("Expected to have NetworkError.backend error, got \(error)")
        }
    }
    
    func testClientReturnsErrorOnURLSessionError() async throws {
        MockURLProtocol.requestHandler = { _ in
            throw Errors.badConnection
        }
        
        do {
            let _: VoidResponse = try await httpClient.send(request: MockNetworkRequest()).data
            XCTFail("Expected to fail")
        } catch {
            print(error)
        }
    }
}
