import SwiftUI

extension Color {
    // Light mode colors
    static let leetCodeDark = Color(hex: "1A1A1A")
    static let leetCodeDarkLighter = Color(hex: "282828")
    static let leetCodeOrange = Color(hex: "F89F1B")
    static let leetCodeGreen = Color(hex: "00B894")
    static let leetCodeYellow = Color(hex: "FDCB6E")
    static let leetCodeRed = Color(hex: "E17055")

    // Light mode text colors
    static let leetCodeTextPrimary = Color(hex: "2D3436")
    static let leetCodeTextSecondary = Color(hex: "636E72")

    // Light mode background colors
    static let cardBackground = Color(hex: "FFFFFF")
    static let pageBackground = Color(hex: "F8F9FA")
    static let subtleGray = Color(hex: "DFE6E9")

    // Gradients
    static let leetCodeGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "F89F1B"), Color(hex: "FDCB6E")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "F8F9FA"), Color(hex: "FFFFFF")]),
        startPoint: .top,
        endPoint: .bottom
    )

    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [Color.white, Color(hex: "F8F9FA")]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
