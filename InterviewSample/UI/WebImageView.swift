import SwiftUI
import NukeUI

struct WebImageView: View {
    
    let url: URL?
    
    var body: some View {
        LazyImage(url: url) { state in
            if let image = state.image {
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                AppColors.placeholder
            }
        }
        .onDisappear(.cancel) // Cancel image loading on disappear
    }
}
