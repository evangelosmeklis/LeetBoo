import SwiftUI

extension Color {
    // Tech-inspired colors with more vibrancy
    static let leetCodeDark = Color(hex: "0A0E27")
    static let leetCodeDarkLighter = Color(hex: "1A1F3A")
    static let leetCodeOrange = Color(hex: "FF6B35")
    static let leetCodeOrangeBright = Color(hex: "FF8C42")
    static let leetCodeGreen = Color(hex: "00D9A5")
    static let leetCodeGreenBright = Color(hex: "00FFB8")
    static let leetCodeYellow = Color(hex: "FFD93D")
    static let leetCodeYellowBright = Color(hex: "FFE66D")
    static let leetCodeRed = Color(hex: "FF4757")
    static let leetCodeBlue = Color(hex: "4ECDC4")
    static let leetCodePurple = Color(hex: "A78BFA")

    // Text colors with better contrast
    static let leetCodeTextPrimary = Color(hex: "1A1F3A")
    static let leetCodeTextSecondary = Color(hex: "6B7280")

    // Modern background colors
    static let cardBackground = Color(hex: "FFFFFF")
    static let pageBackground = Color(hex: "F0F4F8")
    static let subtleGray = Color(hex: "E5E7EB")
    
    // Glass effect colors
    static let glassBackground = Color.white.opacity(0.7)
    static let glassBorder = Color.white.opacity(0.3)

    // Tech gradients
    static let leetCodeGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "FF6B35"), Color(hex: "FFD93D")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let leetCodeGradientBright = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "FF8C42"), Color(hex: "FFE66D")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let greenGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "00D9A5"), Color(hex: "00FFB8")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let blueGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "4ECDC4"), Color(hex: "6EE7E0")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "F0F4F8"), Color(hex: "E8F0F5")]),
        startPoint: .top,
        endPoint: .bottom
    )

    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [Color.white, Color(hex: "FAFBFC")]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    // Neon glow colors
    static let neonOrange = Color(hex: "FF6B35").opacity(0.6)
    static let neonGreen = Color(hex: "00D9A5").opacity(0.6)
    static let neonYellow = Color(hex: "FFD93D").opacity(0.6)
    
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
