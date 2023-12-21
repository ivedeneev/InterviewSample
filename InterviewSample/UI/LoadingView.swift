import SwiftUI

struct LoadingView: View {
    
    @State private var angle = 0.0
    @State private var isRotating = false
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.75)
            .stroke(AppColors.secondary, lineWidth: 2)
            .frame(width: 24, height: 24)
            .rotationEffect(.degrees(angle))
            .onAppear {
                angle = 0
                withAnimation(
                    .linear(duration: 1).repeatForever(autoreverses: false)
                ) {
                    angle = 360.0
                }
             }
            .padding()
    }
}
