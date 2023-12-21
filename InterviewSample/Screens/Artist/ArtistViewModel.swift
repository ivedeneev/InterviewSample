import Foundation

final class ArtistViewModel: ViewModelType {
    
    @Published var state: State
    
    private let artist: Media
    private let service: SearchMediaService
    
    init(artist: Media, service: SearchMediaService = Dependencies.shared.searchService()) {
        self.service = service
        self.artist = artist
        self.state = State(artistImage: nil, artistName: artist.artistName)
    }

    func sendAction(_ action: Action) {
        switch action {
        case .load:
            Task { await loadAlbumsAndSongs() }
        }
    }
    
    @MainActor
    private func loadAlbumsAndSongs() async  {
        defer { state.isLoading = false }
        
        state.isLoading = true
        do {
            let albums = try await service.albums(artistId: artist.artistId)
            let songs = try await service.songs(artistId: artist.artistId)
            
            state.bulkUpdate { state in
                state.albums = albums
                state.songs = songs
                state.artistImage = albums.first?.artworkUrl100 // iTunes doesnt provide image for artist, so image from 1st album is being used as an artist's backgroung image
            }
        } catch {
            print(error)
        }
    }
}

extension ArtistViewModel {
    enum Action {
        case load
    }
    
    struct State: StateType {
        var artistImage: URL?
        var artistName: String
        var albums: [Media] = []
        var songs: [Media] = []
        var isLoading = false
    }
}
