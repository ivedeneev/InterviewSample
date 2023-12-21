import Combine
import Foundation

final class PlayerViewModel: ViewModelType {
    
    @Published private(set) var state: State
    
    private let player: AudioPlayer
    private let media: Media
    
    init(media: Media, player: AudioPlayer = FakePlayer()) {
        self.player = player
        self.media = media
        
        self.state = State(
            isPlaying: false,
            volume: player.volume,
            progress: 0,
            progressLeft: 0.toFormattedTime(),
            progressRight: media.lengthInSeconds.toFormattedTime(),
            trackName: media.trackName ?? "",
            artistName: media.artistName,
            albumImageUrl: media.artworkUrl100,
            backgroundImageUrl: media.artworkUrl60
        )
        
        player.delegate = self
    }
    
    func sendAction(_ action: Action) {
        switch action {
        case .togglePlayPause:
            state.isPlaying.toggle()
            if state.isPlaying {
                player.play()
            } else {
                player.pause()
            }
        case .setVolume(let volume):
            state.volume = volume
            player.setVolume(volume)
        case .goForward:
            player.forward()
        case .goBackward:
            player.backward()
        case .updateProgress(let seconds):
            state.bulkUpdate { state in
                state.progressLeft = seconds.toFormattedTime()
                state.progressRight = (media.lengthInSeconds - seconds).toFormattedTime()
                state.progress = Double(seconds) / Double(media.lengthInSeconds)
            }
        case .updateProgressManually(let progress):
            let seconds = Int(Double(media.lengthInSeconds) * progress)
            player.setPlayback(value: seconds)
            sendAction(.updateProgress(seconds))
        case .appear:
            player.setTrack(track: media)
        case .finishPlayingTrack:
            state.isPlaying = false
        }
    }
}

extension PlayerViewModel: AudioPlayerDelegate {
    func didChangePlabackProgress(player: AudioPlayer, progress: Int) {
        sendAction(.updateProgress(progress))
    }
    
    func didFinishPlayingTrack(player: AudioPlayer) {
        sendAction(.finishPlayingTrack)
    }
}

extension PlayerViewModel {
    enum Action {
        case appear
        case setVolume(Double)
        case togglePlayPause
        case goForward
        case goBackward
        case updateProgress(Int)
        case updateProgressManually(Double)
        case finishPlayingTrack
    }
    
    struct State: StateType {
        var isPlaying: Bool
        var volume: Double
        var progress: Double
        var progressLeft: String
        var progressRight: String
        var trackName: String
        var artistName: String
        var albumImageUrl: URL?
        var backgroundImageUrl: URL?
    }
}
