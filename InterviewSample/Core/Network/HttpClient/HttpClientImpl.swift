import Foundation

final class HttpClientImpl: HttpClient {

    private let session: URLSession
    private let requestBuilder: RequestBuilder
    
    init(
        session: URLSession = URLSession(configuration: .ephemeral),
        requestBuilder: RequestBuilder = RequestBuilderImpl()
    ) {
        self.session = session
        self.requestBuilder = requestBuilder
    }
    
    func send<T: Decodable>(request: NetworkRequestType, decoder: JSONDecoder) async throws -> HttpResponseWithHeaders<T> {
        let request = try requestBuilder.urlRequest(with: request)

        do {
            let (data, response) = try await session.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.badResponse
            }
            
            switch response.statusCode {
            case 200...300:
                let headers: [String : String] = response.allHeaderFields as? [String : String] ?? [:]
                return (try decoder.decode(T.self, from: data), headers)
            default:
                throw NetworkError.backend(response.statusCode, data)
            }
        } catch let error as DecodingError {
            throw NetworkError.decoding(error)
        } catch where (error as NSError).domain == NSURLErrorDomain {
            throw NetworkError.badConnection
        }
    }
}
