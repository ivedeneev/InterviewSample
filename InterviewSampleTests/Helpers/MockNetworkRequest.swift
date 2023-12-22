import Foundation
@testable import InterviewSample

struct MockNetworkRequest: NetworkRequestType {
    var baseURL: String = "https://github.com"
    var path: String = "path"
    var parameters: RequestParameters = [:]
    var headers: [String : String] = [:]
    var method:HTTPMethod = .get
}
