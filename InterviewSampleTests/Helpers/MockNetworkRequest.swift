import Foundation
@testable import InterviewSample

struct MockNetworkRequest: NetworkRequestType {
    var baseURL: String = "https://agima.ru"
    var path: String = "path"
    var parameters: RequestParameters = [:]
    var headers: [String : String] = [:]
    var method:HTTPMethod = .get
}
