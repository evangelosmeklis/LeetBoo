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
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Enter New Value")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(.leetCodeTextSecondary)
                            .textCase(.uppercase)
                            .tracking(0.5)

                        TextField("Coins", text: $inputValue)
                            .keyboardType(.numberPad)
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .padding(20)
                            .background(Color.cardBackground)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
                            .foregroundColor(.leetCodeTextPrimary)
                    }

                    // Current value display
                    HStack {
                        Text("Current Value")
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundColor(.leetCodeTextSecondary)
                        Spacer()
                        Text("\(coins)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.leetCodeTextPrimary)
                    }
                    .padding(20)
                    .background(Color.cardBackground)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)

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
