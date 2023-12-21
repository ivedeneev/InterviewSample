import Foundation

final class RequestBuilderImpl: RequestBuilder {
    
    init() {}
    
    func urlRequest(with request: NetworkRequestType) throws -> URLRequest {
        guard let baseURL = URL(string: request.baseURL) else {
            throw NetworkError.invalidBaseUrl
        }

        guard
            var url = URL(string: request.path, relativeTo: baseURL),
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else {
            throw NetworkError.invalidPath
        }
        
        //TODO: implement JSON body encoding for POST/PUT requests
        let queryItems = request.parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents.queryItems = queryItems
        guard let newURL = urlComponents.url else {
            throw NetworkError.incorrectParameters
        }
        url = newURL
        
        let mutableURLRequest = NSMutableURLRequest(url: url)
        mutableURLRequest.httpMethod = request.method.stringValue
        mutableURLRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        mutableURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.headers.forEach { mutableURLRequest.addValue($1, forHTTPHeaderField: $0) }
        
        return mutableURLRequest as URLRequest
    }
}
