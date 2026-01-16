import SwiftUI

extension Color {
    // WHOOP-inspired dark theme colors
    static let whoopDark = Color(hex: "0D1117")
    static let whoopDarkCard = Color(hex: "161B22")
    static let whoopDarkElevated = Color(hex: "21262D")
    static let whoopDarkBorder = Color(hex: "30363D")
    
    // Accent colors - teal/cyan like WHOOP
    static let whoopTeal = Color(hex: "00D9C0")
    static let whoopTealBright = Color(hex: "00FFE0")
    static let whoopGreen = Color(hex: "2DD881")
    static let whoopGreenBright = Color(hex: "56FFA4")
    static let whoopBlue = Color(hex: "58A6FF")
    static let whoopBlueBright = Color(hex: "79C0FF")
    
    // Legacy colors for compatibility
    static let leetCodeDark = Color(hex: "0D1117")
    static let leetCodeDarkLighter = Color(hex: "161B22")
    static let leetCodeOrange = Color(hex: "FF6B35")
    static let leetCodeOrangeBright = Color(hex: "FF8C42")
    static let leetCodeGreen = Color(hex: "00D9C0")
    static let leetCodeGreenBright = Color(hex: "00FFE0")
    static let leetCodeYellow = Color(hex: "FFD93D")
    static let leetCodeYellowBright = Color(hex: "FFE66D")
    static let leetCodeRed = Color(hex: "FF4757")
    static let leetCodeBlue = Color(hex: "58A6FF")
    static let leetCodePurple = Color(hex: "A78BFA")

    // Text colors for dark theme
    static let leetCodeTextPrimary = Color(hex: "F0F6FC")
    static let leetCodeTextSecondary = Color(hex: "8B949E")
    static let leetCodeTextTertiary = Color(hex: "6E7681")

    // Background colors - now dark
    static let cardBackground = Color(hex: "161B22")
    static let pageBackground = Color(hex: "0D1117")
    static let subtleGray = Color(hex: "30363D")
    
    // Glass effect colors for dark theme
    static let glassBackground = Color(hex: "161B22").opacity(0.9)
    static let glassBorder = Color(hex: "30363D").opacity(0.5)

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
        gradient: Gradient(colors: [Color(hex: "00D9C0"), Color(hex: "00FFE0")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let tealGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "00D9C0"), Color(hex: "2DD881")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let blueGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "58A6FF"), Color(hex: "79C0FF")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "0D1117"), Color(hex: "161B22")]),
        startPoint: .top,
        endPoint: .bottom
    )

    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "161B22"), Color(hex: "21262D")]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    // Glow colors for dark theme
    static let neonOrange = Color(hex: "FF6B35").opacity(0.4)
    static let neonGreen = Color(hex: "00D9C0").opacity(0.4)
    static let neonYellow = Color(hex: "FFD93D").opacity(0.4)
    static let neonTeal = Color(hex: "00D9C0").opacity(0.4)
    
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
