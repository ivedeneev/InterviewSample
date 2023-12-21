import Foundation

extension Int {
    
    /// Creates formatted time string from given `Date` object
    /// - Returns: String with minutes and seconds (Example: `03:43`)
    func toFormattedTime() -> String {
        let minutes = self / 60
        let secodnds = self % 60
        return String(format: "%01i:%02i", minutes, secodnds)
    }
}
