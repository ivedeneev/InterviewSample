import Combine
import Foundation

protocol AudioPlayer: AnyObject {
    func play()
    func pause()
    func forward()
    func backward()
    func setVolume(_ volume: Double)
    func setPlayback(value: Int)
    func setTrack(track: Media) 
    
    var volume: Double { get }
    var delegate: AudioPlayerDelegate? { get set }
}

protocol AudioPlayerDelegate: AnyObject {
    func didChangePlabackProgress(player: AudioPlayer, progress: Int)
    func didFinishPlayingTrack(player: AudioPlayer)
}
