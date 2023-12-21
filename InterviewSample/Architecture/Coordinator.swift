import Foundation
import SwiftUI

final class Coordinator: ObservableObject {
    
    @Published var navigationPath = [NavigationRoute]()
    @Published var showSong: Media?
    @Published var showDevelopmentAlert = false
    
    func showMedia(media: Media) {
        if media.wrapperType == .artist {
            navigationPath.append(NavigationRoute.artist(media))
        } else {
            showSong = media
        }
    }
}

enum NavigationRoute: Hashable {
    case artist(Media)
}
