import Foundation

// Naive implementation of Di container
final class Dependencies {
    
    static let shared = Dependencies()
    private init() {}
    
    var searchService: (() -> SearchMediaService)!
    var jsonDecoder: (() -> JSONDecoder)!
    var httpClient: (() -> HttpClient)!
}
