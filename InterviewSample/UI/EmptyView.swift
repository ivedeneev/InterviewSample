import SwiftUI

struct EmptyView: View {
    
    let systemImageName: String
    let text: LocalizedStringKey
    
    var body: some View {
        VStack {
            Image(systemName:systemImageName)
                .resizable()
                .frame(width: 60, height: 60)
            
            Text(text)
                .font(AppFonts.largeTitle)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
        }
        .foregroundColor(AppColors.secondary)
    }
}
