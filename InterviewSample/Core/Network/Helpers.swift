import Foundation

typealias Headers = [String : String]
typealias RequestParameters = [String : String]
typealias HttpResponseWithHeaders<T: Decodable> = (data: T, headers: Headers)

struct VoidResponse: Decodable, Equatable {}
