import SwiftUI

struct AppColors {
    
    /// Primary text color
    static let primary = Color.primary
    
    /// Secondary text color
    static let secondary = Color.secondary
    
    /// Always white color
    static let white = Color.white
    
    /// Color for player elements such as progress tracks and timer labels
    static let playerSecondaryElements = AppColors.white.opacity(0.66)
    
    /// Color for image view placeholder
    static let placeholder = Color(.tertiarySystemFill)
    
    /// System background color
    static let systemBackground = Color(.systemBackground)
    
    /// Color for the pressed state for list elements background
    static let selectedListBackground = Color(white: 0.75)
    
    /// Transparent black color for dimmming images
    static let dim = Color.black.opacity(0.33)
    
    ///
    static let transparentWhite = AppColors.white.opacity(0.2)
}
