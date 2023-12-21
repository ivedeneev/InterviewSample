import SwiftUI

struct AlbumView: View {
    
    let album: Media
    private static let imageSide: CGFloat = 160
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            WebImageView(url: album.artworkUrl100)
                .frame(width: Self.imageSide, height: Self.imageSide)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            if let name = album.collectionName {
                Text(name)
                    .foregroundColor(AppColors.primary)
                    .lineLimit(1)
            }
            
            if let releaseDate = album.releaseDate {
                Text(DateFormatter.yearDateFormatter.string(from: releaseDate))
                    .foregroundColor(AppColors.secondary)
                    .font(AppFonts.subtitle)
            }
        }
        .frame(width: Self.imageSide)
    }
}
