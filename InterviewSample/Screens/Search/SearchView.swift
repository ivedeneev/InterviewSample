import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel: SearchViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.state.media) { media in
                    Button {
                        coordinator.showMedia(media: media)
                    } label: {
                        MediaView(media: media)
                    }
                    .buttonStyle(ListButtonStyle())
                }
                
                if viewModel.state.hasNextPage {
                    lastRowView
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .overlay { emptyOrProgressView }
        .refreshable {
            viewModel.sendAction(.refresh)
        }
        .searchable(
            text: viewModel.binding(get: \.searchQuery, action: { .searchChanged(query: $0) })
        )
        .task(id: viewModel.state.searchQuery) {
            do {
                try await Task.sleep(for: .milliseconds(300))
                viewModel.sendAction(.searchDebounced)
            } catch {}
        }
        .navigationTitle("Search.Title")
    }
    
    @ViewBuilder
    private var lastRowView: some View {
        if viewModel.state.hasNextPage {
            LoadingView()
                .frame(maxWidth: .infinity)
                .onAppear {
                    viewModel.sendAction(.loadNextPage)
                }
        }
    }
    
    @ViewBuilder
    private var emptyOrProgressView: some View {
        if viewModel.state.media.isEmpty {
            if viewModel.state.isLoading {
                LoadingView()
            } else {
                emptyView
            }
        }
    }
    
    private var emptyView: some View {
        let image: String
        let text: LocalizedStringKey
        
        if let error = viewModel.state.error {
            image = "xmark.octagon"
            text = LocalizedStringKey(error)
        } else if viewModel.state.searchQuery.isEmpty {
            image = "magnifyingglass"
            text = "Search.StartNewSearch"
        } else {
            image = "bubble.left"
            text = "Search.NotFound"
        }
        
        return EmptyView(
            systemImageName: image,
            text: text
        )
    }
}
