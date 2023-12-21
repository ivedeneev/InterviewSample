import SwiftUI

struct MediaView: View {
    let media: Media
    private static let imageWidth: CGFloat = 60
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                artworkView
                titleAndDescriptionView
                Spacer()
                
                if media.wrapperType == .artist {
                    disclosureIndicatorView
                }
            }
            .padding(.trailing)
            
            Divider()
                .padding(.leading, Self.imageWidth + 8)
        }
        .padding(.leading)
        .padding(.top, 8)
    }
    
    @MainActor
    private var artworkView: some View {
        WebImageView(url: media.artworkUrl60)
            .frame(width: Self.imageWidth, height: Self.imageWidth)
            .clipShape(RoundedRectangle(cornerRadius: media.wrapperType == .artist ? 30 : 8))
            .overlay {
                if media.wrapperType == .artist {
                    Image(systemName: "music.mic")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(AppColors.secondary)
                }
            }
    }
    
    private var titleAndDescriptionView: some View {
        VStack(alignment: .leading) {
            Text(media.trackName ?? media.artistName)
                .foregroundColor(AppColors.primary)
                .font(AppFonts.body)
                .lineLimit(1)
            
            Text("\(media.localized) • \(media.artistName)")
                .foregroundColor(AppColors.secondary)
                .font(AppFonts.subtitle)
                .lineLimit(2)
        }
        .multilineTextAlignment(.leading)
    }
    
    private var disclosureIndicatorView: some View {
        Image(systemName: "chevron.right")
            .foregroundColor(AppColors.secondary)
    }
}
