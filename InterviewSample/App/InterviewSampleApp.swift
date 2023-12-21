import SwiftUI

@main
struct InterviewSampleApp: App {
    
    init() {
        UITextField.appearance().clearButtonMode = .always
        registerDependencies()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    func registerDependencies() {
        let deps = Dependencies.shared
        
        deps.httpClient = {
            HttpClientImpl()
        }
        
        deps.jsonDecoder = {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return decoder
        }
        
        deps.searchService = {
            let decoder = deps.jsonDecoder()
            let client = deps.httpClient()
            return SearchMediaServiceImpl(httpClient: client, decoder: decoder)
        }
        
        assert(deps.httpClient != nil)
        assert(deps.jsonDecoder != nil)
        assert(deps.searchService != nil)
    }
}
