import SwiftUI

struct EditCoinsView: View {
    let title: String
    let coins: Int
    let onSave: (Int) -> Void

    @Environment(\.dismiss) var dismiss
    @State private var inputValue: String

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

                VStack(spacing: 20) {
                    // Input field
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(Color.leetCodeOrange.opacity(0.15))
                                    .frame(width: 28, height: 28)
                                
                                Image(systemName: "pencil")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.leetCodeOrange)
                            }
                            
                            Text("ENTER NEW VALUE")
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(.leetCodeTextSecondary)
                                .tracking(1.5)
                        }

                        TextField("Coins", text: $inputValue)
                            .keyboardType(.numberPad)
                            .font(.system(size: 42, weight: .bold, design: .monospaced))
                            .padding(28)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.glassBackground)
                                    .background(
                                        RoundedRectangle(cornerRadius: 24)
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color.white.opacity(0.9), Color.white.opacity(0.7)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.white.opacity(0.6), Color.white.opacity(0.2)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.5
                                    )
                            )
                            .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 8)
                            .shadow(color: Color.leetCodeOrange.opacity(0.1), radius: 15, x: 0, y: 4)
                            .foregroundStyle(Color.leetCodeGradient)
                    }

                    // Current value display
                    HStack {
                        Text("Current Value")
                            .font(.system(size: 15, weight: .semibold, design: .monospaced))
                            .foregroundColor(.leetCodeTextSecondary)
                            .tracking(0.3)
                        Spacer()
                        Text("\(coins)")
                            .font(.system(size: 24, weight: .bold, design: .monospaced))
                            .foregroundStyle(Color.leetCodeGradient)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.glassBackground)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.white.opacity(0.9), Color.white.opacity(0.7)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.6), Color.white.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 8)

                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.leetCodeTextSecondary)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let value = Int(inputValue) {
                            onSave(value)
                            dismiss()
                        }
                    }
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(inputValue.isEmpty ? .gray : .leetCodeOrange)
                    .disabled(inputValue.isEmpty)
                }
            }
        }
        .preferredColorScheme(.light)
    }
}
