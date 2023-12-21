import SwiftUI

struct ListButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? AppColors.selectedListBackground : AppColors.systemBackground)
    }
}
