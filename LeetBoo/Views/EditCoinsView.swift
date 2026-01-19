import SwiftUI

struct EditCoinsView: View {
    let title: String
    let coins: Int
    let onSave: (Int) -> Void

    @Environment(\.dismiss) var dismiss
    @State private var inputValue: String
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var contentMaxWidth: CGFloat? {
        horizontalSizeClass == .regular ? 640 : nil
    }

    init(title: String, coins: Int, onSave: @escaping (Int) -> Void) {
        self.title = title
        self.coins = coins
        self.onSave = onSave
        _inputValue = State(initialValue: String(coins))
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.pageBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Navigation bar
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.leetCodeTextPrimary)
                        }
                        
                        Spacer()
                        
                        Text("EDIT COINS")
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundColor(.leetCodeTextPrimary)
                            .tracking(1.5)
                        
                        Spacer()
                        
                        Button(action: {
                            if let value = Int(inputValue) {
                                onSave(value)
                                dismiss()
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(inputValue.isEmpty || Int(inputValue) == nil ? Color.subtleGray.opacity(0.3) : Color.leetCodeGreen.opacity(0.15))
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(inputValue.isEmpty || Int(inputValue) == nil ? .leetCodeTextSecondary : .leetCodeGreen)
                            }
                        }
                        .disabled(inputValue.isEmpty || Int(inputValue) == nil)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            // Header
                            VStack(spacing: 8) {
                                Text("Edit your")
                                    .font(.system(size: 26, weight: .semibold, design: .rounded))
                                    .foregroundColor(.leetCodeTextPrimary)
                                
                                Text("Current Coins")
                                    .font(.system(size: 26, weight: .semibold, design: .rounded))
                                    .foregroundColor(.leetCodeTextPrimary)
                            }
                            .padding(.top, 8)
                            
                            // Main card
                            VStack(spacing: 0) {
                                // Current value display
                                VStack(spacing: 8) {
                                    Text("CURRENT VALUE")
                                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                                        .foregroundColor(.leetCodeTextSecondary)
                                        .tracking(1.5)
                                    
                                    Text("\(coins)")
                                        .font(.system(size: 56, weight: .bold, design: .rounded))
                                        .foregroundColor(.leetCodeTextPrimary)
                                }
                                .padding(.vertical, 32)
                                
                                Divider()
                                    .background(Color.subtleGray.opacity(0.5))
                                
                                // Input field
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("NEW VALUE")
                                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                                        .foregroundColor(.leetCodeTextSecondary)
                                        .tracking(1.5)
                                    
                                    TextField("Enter coins", text: $inputValue)
                                        .keyboardType(.numberPad)
                                        .font(.system(size: 42, weight: .bold, design: .rounded))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.leetCodeGreen)
                                        .padding(.vertical, 20)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(Color.whoopDarkElevated)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .stroke(Color.leetCodeGreen.opacity(0.3), lineWidth: 1)
                                                )
                                        )
                                }
                                .padding(24)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(Color.subtleGray.opacity(0.5), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, 20)
                            
                            Spacer(minLength: 40)
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 32)
                        .frame(maxWidth: contentMaxWidth)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
        .preferredColorScheme(.dark)
    }
}
