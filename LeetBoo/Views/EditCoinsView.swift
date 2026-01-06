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
                Color.backgroundGradient.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("ENTER NEW VALUE")
                            .font(.system(.caption, design: .rounded))
                            .fontWeight(.bold)
                            .tracking(1.5)
                            .foregroundColor(.leetCodeTextSecondary)
                        
                         TextField("Coins", text: $inputValue)
                            .keyboardType(.numberPad)
                            .font(.system(size: 32, design: .rounded))
                            .padding()
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1)))
                            .foregroundColor(.white)
                    }
                    .padding(24)
                    .background(.ultraThinMaterial)
                    .cornerRadius(24)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Current Value")
                                .foregroundColor(.leetCodeTextSecondary)
                            Spacer()
                            Text("\(coins)")
                                .font(.title3)
                                .foregroundColor(.leetCodeTextPrimary)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(24)
                    .background(.ultraThinMaterial)
                    .cornerRadius(24)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let value = Int(inputValue) {
                            onSave(value)
                            dismiss()
                        }
                    }
                    .fontWeight(.bold)
                    .foregroundColor(inputValue.isEmpty ? .gray : .leetCodeOrange)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
