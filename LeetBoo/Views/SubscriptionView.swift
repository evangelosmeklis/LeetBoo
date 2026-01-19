import StoreKit
import SwiftUI

struct SubscriptionView: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Color.pageBackground.ignoresSafeArea()

                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("LeetBoo Premium")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.leetCodeTextPrimary)

                        Text("Unlock weekly luck, premium challenges, and deeper insights.")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.leetCodeTextSecondary)
                            .multilineTextAlignment(.center)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        premiumRow("Weekly Luck notifications + coins")
                        premiumRow("Weekly Premium Challenges")
                        premiumRow("Magic notifications + insights")
                        premiumRow("Multiple daily reminders")
                        premiumRow("Time Travel + custom monthly rate")
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.subtleGray.opacity(0.5), lineWidth: 1)
                            )
                    )

                    VStack(spacing: 10) {
                        if let product = subscriptionManager.product {
                            Text("7-day free trial, then \(product.displayPrice)/month")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(.leetCodeTextPrimary)
                        } else if subscriptionManager.productsLoaded {
                            Text(subscriptionManager.lastError ?? "Premium is unavailable right now.")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(.leetCodeTextSecondary)
                                .multilineTextAlignment(.center)
                        } else {
                            SwiftUI.ProgressView()
                                .tint(.leetCodeGreen)
                        }

                        Button(action: {
                            Task { await subscriptionManager.purchase() }
                        }) {
                            Text(subscriptionManager.isSubscribed ? "You're Subscribed" : "Start Premium")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.leetCodeGreen)
                                .cornerRadius(12)
                        }
                        .disabled(subscriptionManager.isSubscribed || subscriptionManager.product == nil)

                        Button("Retry") {
                            Task { await subscriptionManager.loadProducts() }
                        }
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.leetCodeTextSecondary)

                        if let error = subscriptionManager.lastError {
                            Text(error)
                                .font(.system(size: 11, weight: .medium, design: .monospaced))
                                .foregroundColor(.leetCodeTextSecondary)
                                .multilineTextAlignment(.center)
                        }

                        Button("Restore Purchases") {
                            Task { await subscriptionManager.restore() }
                        }
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.leetCodeTextSecondary)
                    }

                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.leetCodeTextPrimary)
                }
            }
        }
        .navigationViewStyle(.stack)
        .preferredColorScheme(.dark)
        .task {
            if subscriptionManager.product == nil {
                await subscriptionManager.loadProducts()
            }
        }
    }

    private func premiumRow(_ text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.seal.fill")
                .foregroundColor(.leetCodeGreen)

            Text(text)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.leetCodeTextPrimary)

            Spacer()
        }
    }
}

#Preview {
    SubscriptionView()
        .environmentObject(SubscriptionManager())
}
