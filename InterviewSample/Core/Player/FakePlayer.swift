import Foundation

final class FakePlayer: AudioPlayer {
    weak var delegate: AudioPlayerDelegate?
    
    var volume: Double = 0.3
    
    private var timer: Timer?
    private var currentTrack: Media?
    private var playback: Int = 0
    
    init() {}
    
    deinit {
        pause()
    }
    
    func setTrack(track: Media) {
        currentTrack = track
    }
    
    func play() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self, let currentTrack = self.currentTrack else { return }
            self.playback += 1
            self.delegate?.didChangePlabackProgress(player: self, progress: self.playback)
            
            if self.playback == currentTrack.lengthInSeconds {
                self.pause()
                self.delegate?.didFinishPlayingTrack(player: self)
            }
        }
    }
    
    func pause() {
        timer?.invalidate()
        timer = nil
        printFakeLog("Did stop playing")
    }
    
    func setVolume(_ volume: Double) {
        self.volume = volume
        printFakeLog("Set volume to \(volume)")
    }
    
    func forward() {
        printFakeLog("Forward")
    }
    
    func backward() {
        printFakeLog("Backward")
    }
    
    func setPlayback(value: Int) {
        self.playback = value
    }
    
    private func printFakeLog(_ msg: String) {
        print("[Audio player]", msg)
    }
}
