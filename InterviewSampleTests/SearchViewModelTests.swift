import Foundation
import XCTest
@testable import InterviewSample
import Combine

private typealias State = SearchViewModel.State

/// The main idea behind viewmodel tests is to send action/s to the viewmodel and make sure it will produce a correct sequance of state updates
class SearchViewModelTests: XCTestCase {
    
    var service: MockSearchMediaService!
    var viewModel: SearchViewModel!
    let query = "song"
    let limit = 2
    
    override func setUp() {
        service = MockSearchMediaService()
        Dependencies.shared.searchService = { [unowned self] in
            self.service
        }
        
        super.setUp()
    }
    
    override func tearDown() {
        service = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialStateIsSetCorrectly() {
        let expectedState = State(searchQuery: query, limit: limit * 10)
        viewModel = SearchViewModel(state: expectedState)
        
        XCTAssertEqual(viewModel.state, expectedState)
    }
    
    func test_WhenUpdateSearchString_StateIsUpdated() {
        let initialState = State(limit: limit)
        let mediaResponse: MediaListResponse = mediaListResponse(resultCount: limit)
        
        let expectedStateValues = [
            State(searchQuery: query, media: [], hasNextPage: true, isLoading: true, limit: limit),
            State(searchQuery: query, media: mediaResponse.results, hasNextPage: true, isLoading: false, limit: limit),
        ]

        performStateUpdatesTest(
            initialState: initialState,
            stubServiceResponse: mediaResponse,
            actions: [.searchChanged(query: query), .searchDebounced],
            expectedStateValues: expectedStateValues
        )
    }
    
    func test_WhenLoadingNotLastPage_MediaArrayIsUpdatedAndHasNextPageIsTrue() {
        let initialMedia = mediaArray(count: limit)
        let initialState = State(searchQuery: query, media: initialMedia, hasNextPage: true, limit: limit)
        
        let stubResponse = mediaListResponse(resultCount: limit)
        let expectedMedia = initialMedia + stubResponse.results
        let expectedStateValues = [
            State(searchQuery: query, media: expectedMedia, hasNextPage: true, limit: limit),
        ]
        
        performStateUpdatesTest(
            initialState: initialState,
            stubServiceResponse: stubResponse,
            actions: [.loadNextPage],
            expectedStateValues: expectedStateValues
        )
    }
    
    func test_WhenReachedLastPage_HasNextPageIsFalse() throws {
        let initialMedia = mediaArray(count: limit)
        let initialState = State(searchQuery: query, media: initialMedia, hasNextPage: true, limit: limit)
        
        let lastPageStubResponse = mediaListResponse(resultCount: limit - 1) // response for last page
        let lastPageMedia = lastPageStubResponse.results
        let expectedMedia = initialMedia + lastPageMedia
        
        let expectedStateValues = [
            State(searchQuery: query, media: expectedMedia, hasNextPage: false, limit: limit)
        ]
        
        performStateUpdatesTest(
            initialState: initialState,
            stubServiceResponse: lastPageStubResponse,
            actions: [.loadNextPage],
            expectedStateValues: expectedStateValues
        )
    }
    
    func test_WhenServiceReturnedAnError_StateUpdates() {
        let initialState = State(searchQuery: query, hasNextPage: true, error: nil)
        
        let expectedErrorMessage = Errors.dataIsMissingOrInIncorrectFormat.localizedDescription // mock service will throw an error if stubResponse is nil. Service will throw `Errors.dataIsMissingOrInIncorrectFormat` error
        let expectedStateValues = [
            State(searchQuery: query, hasNextPage: true, error: expectedErrorMessage)
        ]
        
        performStateUpdatesTest(
            initialState: initialState,
            stubServiceResponse: nil,
            actions: [.loadNextPage],
            expectedStateValues: expectedStateValues
        )
    }
    
    func test_WhenReachedLastPage_NoMoreRequestsAreSent() {
        let initialState = State(searchQuery: query, hasNextPage: false)
        performStateUpdatesTest(
            initialState: initialState,
            stubServiceResponse: mediaListResponse(resultCount: 0),
            actions: [.loadNextPage],
            expectedStateValues: []
        )
    }
    
    func test_WhenSearchStringIsEmpty_NoNetworkRequestsAreSent() {
        // a lots of previously loaded media
        let initialState = State(searchQuery: query, media: mediaArray(count: limit * 4), hasNextPage: true)
        
        let expectedStateValues = [
            State(searchQuery: "", media: [], hasNextPage: false)
        ]
        
        performStateUpdatesTest(
            initialState: initialState,
            stubServiceResponse: mediaListResponse(resultCount: 0),
            actions: [.searchChanged(query: ""), .searchDebounced],
            expectedStateValues: expectedStateValues
        )
    }
    
    func test_WhenRefresh_PreviousMediaCleared() {
        let initialMedia = mediaArray(count: limit * 4) // a lots of previously loaded media
        let initialState = State(searchQuery: query, media: initialMedia, hasNextPage: false, limit: limit)
        
        let refreshResponse = mediaListResponse(resultCount: limit)
        let expectedMedia = refreshResponse.results
        
        let expectedStateValues = [
            State(searchQuery: query, media: expectedMedia, hasNextPage: true, limit: limit)
        ]
        
        performStateUpdatesTest(
            initialState: initialState,
            stubServiceResponse: refreshResponse,
            actions: [.refresh],
            expectedStateValues: expectedStateValues
        )
    }
    
    private func performStateUpdatesTest(
        initialState: State,
        stubServiceResponse: MediaListResponse?,
        actions: [SearchViewModel.Action],
        expectedStateValues: [State]
    ) {
        viewModel = SearchViewModel(state: initialState)
        service.stubResponse = stubServiceResponse
        
        let stateValues = valuesFromPublished(viewModel.$state) { [unowned self] in
            actions.forEach { viewModel.sendAction($0) }
        }
        
        XCTAssertEqual(stateValues, expectedStateValues)
    }
    
    private func mediaArray(count: Int) -> [Media] {
        (0..<count).map { i in Media(wrapperType: .track, trackId: i) }
    }
    
    private func mediaListResponse(resultCount: Int) -> MediaListResponse {
        MediaListResponse(resultCount: resultCount, results: mediaArray(count: resultCount))
    }
}
