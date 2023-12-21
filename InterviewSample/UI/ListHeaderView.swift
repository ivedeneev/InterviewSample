import SwiftUI

struct ListHeaderView: View {
    
    let text: LocalizedStringKey
    
    var body: some View {
        Text(text)
            .font(AppFonts.header)
            .padding(.top, 20)
            .padding(.bottom, 8)
            .padding(.horizontal)
    }
}
