import Combine
import Foundation

final class SearchViewModel: ViewModelType {
    
    @Published private(set) var state: State = .init()
    private let searchService: SearchMediaService
    private var searchTask: Task<Void, Never>?
    
    init(searchService: SearchMediaService = Dependencies.shared.searchService()) {
        self.searchService = searchService
    }
    
    func sendAction(_ action: Action) {
        switch action {
        case .searchChanged(let query):
            cancelSearchTask()
            state.bulkUpdate { state in
                state.searchQuery = query
                guard !query.isEmpty else {
                    state.media = []
                    return
                }
                state.isLoading = true
            }
        case .loadNextPage:
            guard !state.isLoading else { return }
            searchTask = Task { await search(refresh: false) }
        case .refresh, .searchDebounced:
            searchTask = Task { await search(refresh: true) }
        }
    }
    
    @MainActor
    private func search(refresh: Bool) async {
        defer {
            cancelSearchTask()
        }
        
        do {
            let limit = 10
            let offset = refresh ? 0 : state.media.count
            let response = try await searchService.searchMedia(query: state.searchQuery, limit: limit, offset: offset)
            
            state.bulkUpdate { state in
                state.hasNextPage = response.resultCount == limit
                
                if refresh {
                    state.media = response.results
                } else {
                    state.media.append(contentsOf: response.results)
                }
                
                state.isLoading = false
            }
        } catch NetworkError.badConnection {
            // ignore
        } catch {
            state.bulkUpdate { state in
                state.error = error.localizedDescription
                state.isLoading = false
            }
        }
    }
    
    private func cancelSearchTask() {
        searchTask?.cancel()
        searchTask = nil
    }
}

extension SearchViewModel {
    enum Action {
        case searchChanged(query: String)
        case searchDebounced
        case loadNextPage
        case refresh
    }
    
    struct State: StateType {
        var searchQuery: String = ""
        var media: [Media] = []
        var hasNextPage: Bool = false
        var isLoading = false
        var error: String?
    }
}
