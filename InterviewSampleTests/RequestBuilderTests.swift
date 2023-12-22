import Foundation
import XCTest
@testable import InterviewSample

class RequestBuilderTests: XCTestCase {
    
    var requestBuilder: RequestBuilderImpl!
    
    override func setUp() {
        super.setUp()
        
        requestBuilder = RequestBuilderImpl()
    }
    
    func testURLIsBuiltCorrectly() throws {
        let baseURL = "https://github.ru"
        let path = "path"
        let request = MockNetworkRequest(baseURL: baseURL, path: path)
        
        let urlRequest = try requestBuilder.urlRequest(with: request)
        
        guard let url = urlRequest.url else {
            throw Errors.urlMissing
        }
        
        XCTAssertEqual(url.absoluteString, "\(baseURL)/\(path)")
    }
    
    func testGetParametersAreEncodedCorrectly() throws {
        let request = MockNetworkRequest(
            parameters: ["a": "b", "c": "d"],
            method: .get
        )
        
        let urlRequest = try requestBuilder.urlRequest(with: request)
        
        guard let url = urlRequest.url else {
            throw Errors.urlMissing
        }
        
        guard let queryString = url.query else {
            throw Errors.urlQueryMissing
        }
        
        XCTAssertTrue(url.absoluteString.contains("\(request.baseURL)/\(request.path)?"))
        
        let params = Set(queryString.components(separatedBy: "&"))
        XCTAssertTrue(params == ["a=b", "c=d"])
        XCTAssertTrue(queryString.filter { $0 == "&" }.count == 1)
    }
    
    func testHttpMethodIsSetCorrectly() throws {
        let getRequest = MockNetworkRequest(method: .get)
        let postRequest = MockNetworkRequest(method: .post)
        let putRequest = MockNetworkRequest(method: .put)
        let deleteRequest = MockNetworkRequest(method: .delete)
        
        XCTAssertEqual(try requestBuilder.urlRequest(with: getRequest).httpMethod, "GET")
        XCTAssertEqual(try requestBuilder.urlRequest(with: postRequest).httpMethod, "POST")
        XCTAssertEqual(try requestBuilder.urlRequest(with: putRequest).httpMethod, "PUT")
        XCTAssertEqual(try requestBuilder.urlRequest(with: deleteRequest).httpMethod, "DELETE")
    }
    
    func testHTTPBodyIsEncodedCorrectly() throws {
        let paramaters = ["a": "b", "c": "d"]
        let request = MockNetworkRequest(
            baseURL: "https://github.com",
            path: "some",
            parameters: paramaters,
            headers: [:],
            method: .post
        )
        
        let urlRequest = try requestBuilder.urlRequest(with: request)
        guard let body = urlRequest.httpBody else {
            XCTFail("Expected a body in URLRequest, got nil instead")
            return
        }
        
        let decodedBody = try JSONSerialization.jsonObject(with: body) as? [String : String]
        XCTAssertEqual(paramaters, decodedBody)
        XCTAssertEqual(urlRequest.url?.absoluteString, "\(request.baseURL)/\(request.path)")
    }
}
