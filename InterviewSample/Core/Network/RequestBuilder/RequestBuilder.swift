import Foundation

protocol RequestBuilder {
    func urlRequest(with request: NetworkRequestType) throws -> URLRequest
}
