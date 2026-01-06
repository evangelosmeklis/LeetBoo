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
            Form {
                Section {
                    TextField("Coins", text: $inputValue)
                        .keyboardType(.numberPad)
                        .font(.title)
                }

                Section {
                    HStack {
                        Text("Current Value:")
                        Spacer()
                        Text("\(coins)")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let value = Int(inputValue) {
                            onSave(value)
                            dismiss()
                        }
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}
