import Foundation

enum NetworkError: Error {
    case incorrectRequest
    case incorrectParameters
    case invalidBaseUrl
    case invalidPath
    case invalidResponse
    case missingResposeData
    case backend(Int, Data) // status code, data
    case badResponse
    case decoding(DecodingError)
    case badConnection
}
