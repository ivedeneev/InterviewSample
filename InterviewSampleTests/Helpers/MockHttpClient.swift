import Foundation
@testable import InterviewSample

final class MockHttpClient: HttpClient {
    
    var stubResponse: Any?
    
    func send<T>(
        request: NetworkRequestType,
        decoder: JSONDecoder
    ) async throws -> HttpResponseWithHeaders<T> where T : Decodable
    {
        guard let response = stubResponse as? T else {
            throw Errors.dataIsMissingOrInIncorrectFormat
        }
        
        return (data: response, headers: [:])
    }
}
