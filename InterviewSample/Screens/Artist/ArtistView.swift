import SwiftUI

struct ArtistView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel: ArtistViewModel
    private static let headerHeight: CGFloat = 250
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                headerView
                
                if viewModel.state.isLoading {
                    LoadingView()
                        .frame(maxWidth: .infinity)
                } else {
                    albumsCarouselView
                    
                    songsView
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.sendAction(.load)
        }
    }
    
    @MainActor
    private var headerView: some View {
        WebImageView(url: viewModel.state.artistImage)
            .frame(height: Self.headerHeight)
            .frame(maxWidth: .infinity)
            .overlay {
                title
            }
            .clipped()
    }
    
    private var title: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                Text(viewModel.state.artistName)
                    .font(AppFonts.largeTitleBold)
                    .foregroundColor(AppColors.white)
                Spacer()
            }
        }
        .padding()
        .background {
            LinearGradient(colors: [.black, .clear], startPoint: .bottom, endPoint: .center).opacity(0.4)
        }
        .frame(height: Self.headerHeight)
    }
    
    @ViewBuilder
    private var albumsCarouselView: some View {
        ListHeaderView(text: "Artist.Albums")
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.state.albums) { album in
                    Button {
                        coordinator.showDevelopmentAlert.toggle()
                    } label: {
                        AlbumView(album: album)
                    }

                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var songsView: some View {
        ListHeaderView(text: "Artist.Songs")
        
        ForEach(viewModel.state.songs) { media in
            Button {
                coordinator.showMedia(media: media)
            } label: {
                MediaView(media: media)
            }
        }
    }
}
