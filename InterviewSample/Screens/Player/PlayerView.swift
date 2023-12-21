import SwiftUI

struct PlayerView: View {
    
    @StateObject var viewModel: PlayerViewModel
    
    var body: some View {
        ZStack {
            blurredArtworkView
        
            GeometryReader { proxy in
                let safeArea = proxy.safeAreaInsets
                VStack(spacing: 32) {
                    artworkView
                    titleView
                    progressView
                    controlsView
                    soundControlView
                    if safeArea.bottom > 0 {
                        Spacer()
                    }
                }
            }
            .padding(32)
        }
        .ignoresSafeArea()
        .overlay(alignment: .top) {
            RoundedRectangle(cornerRadius: 2)
                .fill(AppColors.playerSecondaryElements)
                .frame(width: 40, height: 4)
                .padding(.vertical, 10)
        }
        .onAppear {
            viewModel.sendAction(.appear)
        }
    }
    
    @MainActor
    private var blurredArtworkView: some View {
        GeometryReader { proxy in
            WebImageView(url: viewModel.state.backgroundImageUrl)
                .blur(radius: 50)
                .overlay(AppColors.dim)
                .clipped()
        }
    }
    
    @MainActor
    private var artworkView: some View {
        GeometryReader { proxy in
            WebImageView(url: viewModel.state.albumImageUrl)
                .frame(width: proxy.size.width, height: proxy.size.width)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 16, y: 16)
                .scaleEffect(viewModel.state.isPlaying ? 1 : 0.8)
                .animation(.spring(dampingFraction: 0.6), value: viewModel.state.isPlaying)
        }
    }
    
    private var titleView: some View {
        HStack {
            VStack(alignment: .leading) {
                if let name = viewModel.state.trackName {
                    Text(name)
                        .foregroundColor(AppColors.white)
                        .font(AppFonts.header)
                }
                
                Text(viewModel.state.artistName)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.playerSecondaryElements)
            }
            .lineLimit(1)
            
            Spacer(minLength: 20)
        }
    }
    
    private var progressView: some View {
        VStack {
            DraggableProgressView(
                progress: viewModel.binding(get: \.progress, action: { .updateProgressManually($0) })
            )
            
            HStack {
                Text(viewModel.state.progressLeft)
                Spacer()
                Text(viewModel.state.progressRight)
                    .multilineTextAlignment(.trailing)
            }
        }
        .font(AppFonts.playerSecondaryElements)
        .foregroundColor(AppColors.playerSecondaryElements)
    }
    
    private var controlsView: some View {
        HStack {
            Button {
                viewModel.sendAction(.goBackward)
            } label: {
                Image(systemName: "backward.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(height: 22)
            
            Spacer().frame(width: 64)
            
            Button {
                viewModel.sendAction(.togglePlayPause)
            } label: {
                Image(systemName: viewModel.state.isPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(width: 40, height: 36)
            
            Spacer().frame(width: 64)
            
            Button {
                viewModel.sendAction(.goForward)
            } label: {
                Image(systemName: "forward.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(height: 22)
        }
        .foregroundColor(AppColors.white)
    }
    
    private var soundControlView: some View {
        HStack(spacing: 16) {
            Image(systemName: "speaker.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 14)
            
            
            DraggableProgressView(
                progress: viewModel.binding(get: \.volume, action: { .setVolume($0) })
            )
            
            Image(systemName: "speaker.wave.3.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 14)
        }
        .foregroundColor(AppColors.playerSecondaryElements)
    }
}
