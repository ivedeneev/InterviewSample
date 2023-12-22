import Foundation
@testable import InterviewSample

extension Media {
    init(wrapperType: WrapperType, trackId: Int? = nil) {
        self.init(
            wrapperType: wrapperType,
            trackId: trackId,
            artistId: 0,
            collectionId: nil,
            trackName: nil,
            artistName: "",
            collectionName: nil,
            trackTimeMillis: nil,
            shortDescription: nil,
            longDescription: nil,
            artworkUrl60: nil,
            artworkUrl100: nil,
            kind: nil,
            releaseDate: nil
        )
    }
}
