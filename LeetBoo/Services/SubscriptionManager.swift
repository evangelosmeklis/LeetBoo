import StoreKit
import SwiftUI

@MainActor
class SubscriptionManager: ObservableObject {
    @Published private(set) var isSubscribed = false
    @Published private(set) var products: [Product] = []
    @Published private(set) var statusLoaded = false
    @Published private(set) var productsLoaded = false
    @Published var isLoading = false
    @Published var lastError: String?

    private let productIDs = ["com.leetboo.premium.monthly"]
    private var updatesTask: Task<Void, Never>?

    init() {
        updatesTask = Task { await observeTransactions() }
        Task {
            await loadProducts()
            await refreshSubscriptionStatus()
        }
    }

    var product: Product? {
        products.first
    }

    func loadProducts() async {
        productsLoaded = false
        lastError = nil

        do {
            products = try await Product.products(for: productIDs)
            if products.isEmpty {
                lastError = "Premium is unavailable right now."
            }
        } catch {
            lastError = error.localizedDescription
        }

        productsLoaded = true
    }

    func refreshSubscriptionStatus() async {
        var subscribed = false
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            guard productIDs.contains(transaction.productID) else { continue }
            guard transaction.revocationDate == nil else { continue }

            if let expirationDate = transaction.expirationDate {
                if expirationDate > Date() {
                    subscribed = true
                    break
                }
            } else {
                subscribed = true
                break
            }
        }

        isSubscribed = subscribed
        statusLoaded = true
    }

    func purchase() async {
        guard let product = product else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    await transaction.finish()
                    await refreshSubscriptionStatus()
                }
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            lastError = error.localizedDescription
        }
    }

    func restore() async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await AppStore.sync()
            await refreshSubscriptionStatus()
        } catch {
            lastError = error.localizedDescription
        }
    }


    private func observeTransactions() async {
        for await update in Transaction.updates {
            if case .verified(let transaction) = update {
                await transaction.finish()
                await refreshSubscriptionStatus()
            }
        }
    }

    deinit {
        updatesTask?.cancel()
    }
}
