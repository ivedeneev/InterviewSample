import Foundation

extension HTTPURLResponse {
    convenience init(url: URL?, statusCode: Int, headers: [String : String]? = nil) throws {
        guard let url else { throw Errors.urlMissing }
        self.init(url: url, statusCode: statusCode, httpVersion: nil, headerFields: headers)!
    }
}
