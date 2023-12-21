import SwiftUI

struct AppFonts {
    /// Fonts for primary texts
    static let body = Font.body
    
    /// Font for secondaty text such as subtitles
    static let subtitle = Font.subheadline
    
    /// Font for header elements such as section header in list or track name in player
    static let header = Font.title2.bold()
    
    /// Font for player secondary elements such as timer labels
    static let playerSecondaryElements = Font.caption
    
    /// Font for large titles such as empty view in the search screen
    static let largeTitle = Font.largeTitle
    
    /// Font for screen title for artist screen
    static let largeTitleBold = Font.largeTitle.bold()
}
