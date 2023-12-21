import Foundation
import XCTest
@testable import InterviewSample
import Combine

class SearchViewModelTests: XCTestCase {
    
    var service: MockSearchMediaService!
    var viewModel: SearchViewModel!
    
    override func setUp() async throws {
        try await super.setUp()

        service = MockSearchMediaService()
        Dependencies.shared.searchService = { [unowned self] in
            self.service
        }
        viewModel = SearchViewModel()
    }
    
    func testInitState() {
        let expectedState = SearchViewModel.State(searchQuery: "", media: [], hasNextPage: false, isLoading: false)
        XCTAssertEqual(viewModel.state, expectedState)
    }
    
    func test() throws {
        let query = "song"
        let decoder = Dependencies.shared.jsonDecoder()
        let mediaResponse: MediaListResponse = try objectFromJson(path: "search", decoder: decoder)
        MockSearchMediaService.mediaListResponse = mediaResponse
        
        let stateValues = is_awaitSequence(viewModel.$state, completeOnTimeout: true) { [unowned self] in
            viewModel.sendAction(.searchChanged(query: query))
            viewModel.sendAction(.searchDebounced)
        }.compactMap { $0.value }
        
        let expectedValues = [
            SearchViewModel.State(searchQuery: "", media: [], hasNextPage: false, isLoading: false),
            SearchViewModel.State(searchQuery: query, media: [], hasNextPage: false, isLoading: true),
            SearchViewModel.State(searchQuery: query, media: mediaResponse.results, hasNextPage: true, isLoading: false),
        ]
        
        
        XCTAssertEqual(stateValues, expectedValues)
    }
}

