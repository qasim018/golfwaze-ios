import SwiftUI

struct AppButton: View {
    enum Variant {
        case primary
        case secondary
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return ThemeManager.shared.primaryColor
            case .secondary:
                return Color(hex: "#F2F2F2")
            }
        }
        
        var textColor: Color {
            switch self {
            case .primary:
                return Color(hex: "#F5F7F9")
            case .secondary:
                return ThemeManager.shared.primaryColor
            }
        }
    }
    
    private let title: String
    private let variant: Variant
    private let action: () -> Void

    init(_ title: String, _ variant: Variant, action: @escaping () -> Void) {
        self.title = title
        self.variant = variant
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Font.customFont(.robotoSemiBold, .pt16))
                .foregroundColor(variant.textColor)
                .frame(maxWidth: .infinity)
                .frame(height: 58)
                .background(variant.backgroundColor)
                .cornerRadius(12)
        }
    }
}

struct AppButton_Previews: PreviewProvider {
    static var previews: some View {
        AppButton("Getting Started", .secondary) {
            print("Button tapped")
        }
    }
}
