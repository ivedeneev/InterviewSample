import Foundation

protocol HttpClient {
    func send<T: Decodable>(request: NetworkRequestType, decoder: JSONDecoder) async throws -> HttpResponseWithHeaders<T>
}

extension HttpClient {
    func send<T: Decodable>(request: NetworkRequestType) async throws -> HttpResponseWithHeaders<T> {
        try await send(request: request, decoder: JSONDecoder())
    }
    
    func send<T: Decodable>(request: NetworkRequestType, decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        try await send(request: request, decoder: decoder).0
    }
}
