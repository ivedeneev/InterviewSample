import SwiftUI

struct DraggableProgressView: View {
    
    @Binding var progress: Double
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(AppColors.playerSecondaryElements)
                
                Rectangle()
                    .fill(AppColors.white)
                    .frame(width: proxy.size.width * progress)
            }
            .gesture(
                DragGesture()
                    .onChanged { g in
                        let volume = max(0, min(1, g.location.x / proxy.size.width))
                        progress = volume
                    }
                )
        }
        .frame(height: 6)
        .frame(maxWidth: .infinity)
        .cornerRadius(3)
    }
}
