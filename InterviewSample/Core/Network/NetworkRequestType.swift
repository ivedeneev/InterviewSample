import Foundation

protocol NetworkRequestType {
    var baseURL: String { get }
    var path: String { get }
    var parameters: RequestParameters { get }
    var headers: [String : String] { get }
    var method: HTTPMethod { get }
}
