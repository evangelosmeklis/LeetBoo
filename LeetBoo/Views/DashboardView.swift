import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingEditCoins = false
    @State private var showingEditTarget = false
    @State private var showingAddCoins = false
    @State private var showingEditMonthlyRate = false

    // Animation states
    @State private var appearAnimation = false

    var progressPercentage: Double {
        min(1.0, Double(dataManager.userData.currentCoins) / Double(max(1, dataManager.userData.targetCoins)))
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Clean light background
                Color.pageBackground
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Banners at the top
                    VStack(spacing: 8) {
                        if dataManager.showDailyCheckInBanner {
                            CheckInBannerView(
                                activityType: .dailyCheckIn,
                                onConfirm: {
                                    withAnimation {
                                        dataManager.confirmCheckIn(for: .dailyCheckIn)
                                    }
                                },
                                onDismiss: {
                                    withAnimation {
                                        dataManager.dismissBanner(for: .dailyCheckIn)
                                    }
                                }
                            )
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }

                        if dataManager.showDailyProblemBanner {
                            CheckInBannerView(
                                activityType: .dailyProblem,
                                onConfirm: {
                                    withAnimation {
                                        dataManager.confirmCheckIn(for: .dailyProblem)
                                    }
                                },
                                onDismiss: {
                                    withAnimation {
                                        dataManager.dismissBanner(for: .dailyProblem)
                                    }
                                }
                            )
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }

                        if dataManager.showWeeklyLuckBanner {
                            CheckInBannerView(
                                activityType: .weeklyLuck,
                                onConfirm: {
                                    withAnimation {
                                        dataManager.confirmCheckIn(for: .weeklyLuck)
                                    }
                                },
                                onDismiss: {
                                    withAnimation {
                                        dataManager.dismissBanner(for: .weeklyLuck)
                                    }
                                }
                            )
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                    .zIndex(1)

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            // Header
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Welcome")
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(.leetCodeTextSecondary)
                                    Text("LeetCoder")
                                        .font(.system(size: 28, weight: .bold, design: .rounded))
                                        .foregroundStyle(Color.leetCodeGradient)
                                }
                                Spacer()
                            }
                            .padding(.bottom, 4)

                            // Main progress card
                            progressCard
                                .offset(y: appearAnimation ? 0 : 30)
                                .opacity(appearAnimation ? 1 : 0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: appearAnimation)

                            // Estimation card
                            estimationCard
                                .offset(y: appearAnimation ? 0 : 30)
                                .opacity(appearAnimation ? 1 : 0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: appearAnimation)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 32)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EmptyView()
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddCoins = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(Color.leetCodeOrange)
                    }
                }
            }
            .sheet(isPresented: $showingAddCoins) {
                AddCoinsSheet()
            }
            .sheet(isPresented: $showingEditMonthlyRate) {
                EditMonthlyRateView()
            }
        }
        .preferredColorScheme(.light)
        .onAppear {
            appearAnimation = true
            dataManager.checkAndResetDailyActivities()
            dataManager.checkAndShowBannersOnAppOpen()
        }
    }

    private var progressCard: some View {
        VStack(spacing: 24) {
            // Progress ring
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color.subtleGray, lineWidth: 16)
                    .frame(width: 200, height: 200)

                // Progress circle
                Circle()
                    .trim(from: 0, to: progressPercentage)
                    .stroke(
                        LinearGradient(
                            colors: [Color.leetCodeOrange, Color.leetCodeYellow],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 16, lineCap: .round)
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.8, dampingFraction: 0.7), value: progressPercentage)

                // Center content
                VStack(spacing: 6) {
                    Text("\(dataManager.userData.currentCoins)")
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .foregroundColor(.leetCodeTextPrimary)

                    Text("of \(dataManager.userData.targetCoins)")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.leetCodeTextSecondary)

                    Text("\(Int(progressPercentage * 100))%")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.leetCodeOrange)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.leetCodeOrange.opacity(0.1))
                        .cornerRadius(12)
                }
            }
            .padding(.top, 8)

            // Edit buttons
            HStack(spacing: 12) {
                Button(action: { showingEditCoins = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "bitcoinsign.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.leetCodeOrange)
                        Text("Edit Current")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.leetCodeTextPrimary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.pageBackground)
                    .cornerRadius(14)
                }

                Button(action: { showingEditTarget = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "target")
                            .font(.system(size: 18))
                            .foregroundColor(.leetCodeGreen)
                        Text("Edit Target")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.leetCodeTextPrimary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.pageBackground)
                    .cornerRadius(14)
                }
            }
        }
        .padding(24)
        .background(Color.cardBackground)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.06), radius: 20, x: 0, y: 8)
        .sheet(isPresented: $showingEditCoins) {
            EditCoinsView(title: "Edit Current Coins", coins: dataManager.userData.currentCoins) { newValue in
                dataManager.updateCurrentCoins(newValue)
            }
        }
        .sheet(isPresented: $showingEditTarget) {
            TargetCoinsPickerView(currentTarget: dataManager.userData.targetCoins) { newValue in
                dataManager.updateTargetCoins(newValue)
            }
        }
    }



    private var estimationCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "clock.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.leetCodeOrange)
                Text("Estimated Time")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.leetCodeTextSecondary)
                    .textCase(.uppercase)
                    .tracking(0.5)
            }

            if dataManager.userData.estimatedMonthlyCoins > 0 {
                HStack(spacing: 32) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(String(format: "%.1f", dataManager.userData.monthsToTarget))")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.leetCodeTextPrimary)
                        Text("Months")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.leetCodeTextSecondary)
                    }

                    Rectangle()
                        .fill(Color.subtleGray)
                        .frame(width: 1, height: 50)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("~\(dataManager.userData.daysToTarget)")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.leetCodeTextPrimary)
                        Text("Days")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.leetCodeTextSecondary)
                    }

                    Spacer()
                }

                // Progress details
                VStack(spacing: 8) {
                    HStack {
                        Text("Remaining")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.leetCodeTextSecondary)
                        Spacer()
                        Text("\(max(0, dataManager.userData.targetCoins - dataManager.userData.currentCoins)) coins")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.leetCodeTextPrimary)
                    }

                    HStack {
                        Text("Monthly rate")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.leetCodeTextSecondary)
                        Spacer()
                        Button(action: { showingEditMonthlyRate = true }) {
                            HStack(spacing: 4) {
                                Text("\(dataManager.userData.estimatedMonthlyCoins) coins/mo")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                Image(systemName: "pencil")
                                    .font(.system(size: 12))
                            }
                            .foregroundColor(.leetCodeOrange)
                        }
                    }
                }
                .padding(16)
                .background(Color.pageBackground)
                .cornerRadius(14)
            } else {
                HStack(spacing: 12) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.leetCodeTextSecondary)

                    Text("Enable Daily or Weekly Luck in Settings to see estimation")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.leetCodeTextSecondary)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.pageBackground)
                .cornerRadius(14)
            }
        }
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.06), radius: 20, x: 0, y: 8)
    }
}

struct QuickActionButton: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.12))
                        .frame(width: 48, height: 48)

                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(color)
                }

                Text(label)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.leetCodeTextSecondary)

                Text(value)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(color)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.pageBackground)
            .cornerRadius(16)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct AddCoinsSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    let options: [CoinOption] = [
        CoinOption(title: "Daily Check-in", coins: 1, icon: "checkmark.circle.fill", color: .leetCodeGreen),
        CoinOption(title: "Daily Problem", coins: 10, icon: "brain.head.profile.fill", color: .leetCodeOrange),
        CoinOption(title: "Weekly Luck", coins: 10, icon: "clover.fill", color: .leetCodeGreen),
        CoinOption(title: "Weekly Contest", coins: 5, icon: "trophy.fill", color: .leetCodeYellow),
        CoinOption(title: "Bi-Weekly Contest", coins: 5, icon: "trophy", color: .leetCodeYellow),
        CoinOption(title: "Both Contests", coins: 35, icon: "trophy.circle.fill", color: .leetCodeOrange),
        CoinOption(title: "30 Day Streak", coins: 30, icon: "flame.fill", color: .leetCodeOrange),
        CoinOption(title: "25 Challenges", coins: 25, icon: "star.circle.fill", color: .leetCodeYellow),
        CoinOption(title: "Month Complete", coins: 50, icon: "crown.fill", color: .leetCodeYellow)
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Color.pageBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // Horizontal Options
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Quick Add")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.leetCodeTextSecondary)
                                .textCase(.uppercase)
                                .tracking(0.5)
                                .padding(.horizontal, 20)

                            VStack(spacing: 12) {
                                ForEach(options) { option in
                                    Button(action: {
                                        dataManager.addCoins(option.coins)
                                        dismiss()
                                    }) {
                                        HStack(spacing: 16) {
                                            ZStack {
                                                Circle()
                                                    .fill(option.color.opacity(0.12))
                                                    .frame(width: 44, height: 44)
                                                
                                                Image(systemName: option.icon)
                                                    .font(.system(size: 20))
                                                    .foregroundColor(option.color)
                                            }
                                            
                                            Text(option.title)
                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                                .foregroundColor(.leetCodeTextPrimary)
                                            
                                            Spacer()
                                            
                                            Text("+\(option.coins)")
                                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                                .foregroundColor(option.color)
                                        }
                                        .padding(12)
                                        .background(Color.cardBackground)
                                        .cornerRadius(16)
                                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
                                    }
                                    .buttonStyle(ScaleButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                        }

                        // Summary
                        VStack(alignment: .leading, spacing: 16) {
                             Text("Current Status")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.leetCodeTextSecondary)
                                .textCase(.uppercase)
                                .tracking(0.5)
                                .padding(.horizontal, 20)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Total Coins")
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(.leetCodeTextSecondary)
                                    Text("\(dataManager.userData.currentCoins)")
                                        .font(.system(size: 32, weight: .bold, design: .rounded))
                                        .foregroundColor(.leetCodeTextPrimary)
                                }
                                Spacer()
                            }
                            .padding(20)
                            .background(Color.cardBackground)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.06), radius: 20, x: 0, y: 8)
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.vertical, 24)
                }
            }
            .navigationTitle("Add Coins")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.leetCodeOrange)
                }
            }
        }
        .preferredColorScheme(.light)
    }
}

struct CoinOption: Identifiable {
    let id = UUID()
    let title: String
    let coins: Int
    let icon: String
    let color: Color
}

struct EditMonthlyRateView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @State private var rateText: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.pageBackground.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Monthly Rate")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(.leetCodeTextSecondary)
                            .textCase(.uppercase)
                            .tracking(0.5)
                        
                        TextField("Coins per month", text: $rateText)
                            .keyboardType(.numberPad)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .padding(20)
                            .background(Color.cardBackground)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
                            
                        Text("This value determines the estimated time to reach your target.")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(.leetCodeTextSecondary)
                            .padding(.top, 8)
                    }
                    
                    if dataManager.userData.customMonthlyRate != nil {
                        Button(action: {
                            dataManager.updateCustomMonthlyRate(nil)
                            dismiss()
                        }) {
                            Text("Reset to Automatic Calculation")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.leetCodeOrange)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.leetCodeOrange.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                    
                    Spacer()
                }
                .padding(24)
            }
            .navigationTitle("Edit Rate")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.leetCodeTextSecondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let rate = Int(rateText), rate > 0 {
                            dataManager.updateCustomMonthlyRate(rate)
                            dismiss()
                        }
                    }
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(rateText.isEmpty ? .gray : .leetCodeOrange)
                    .disabled(rateText.isEmpty)
                }
            }
        }
        .onAppear {
            if let currentRate = dataManager.userData.customMonthlyRate {
                rateText = "\(currentRate)"
            } else {
                rateText = "\(dataManager.userData.estimatedMonthlyCoins)"
            }
        }
    }
}

struct TargetCoinsPickerView: View {
    let currentTarget: Int
    let onSave: (Int) -> Void

    @Environment(\.dismiss) var dismiss
    @State private var selectedReward: LeetCodeReward?
    @State private var customAmount: String = ""
    @State private var showCustomInput = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.pageBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Preset rewards
                        VStack(alignment: .leading, spacing: 12) {
                            Text("LeetCode Rewards")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.leetCodeTextSecondary)
                                .textCase(.uppercase)
                                .tracking(0.5)

                            VStack(spacing: 10) {
                                ForEach(LeetCodeReward.allRewards) { reward in
                                    RewardOptionRow(
                                        reward: reward,
                                        isSelected: selectedReward?.id == reward.id,
                                        action: {
                                            selectedReward = reward
                                            showCustomInput = false
                                        }
                                    )
                                }
                            }
                        }

                        // Custom amount option
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Custom Target")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.leetCodeTextSecondary)
                                .textCase(.uppercase)
                                .tracking(0.5)

                            Button(action: {
                                showCustomInput = true
                                selectedReward = nil
                            }) {
                                HStack(spacing: 14) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.leetCodeYellow.opacity(0.12))
                                            .frame(width: 44, height: 44)

                                        Image(systemName: "pencil.circle.fill")
                                            .font(.system(size: 22))
                                            .foregroundColor(.leetCodeYellow)
                                    }

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Custom Amount")
                                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                                            .foregroundColor(.leetCodeTextPrimary)
                                        Text("Enter your own target")
                                            .font(.system(size: 13, weight: .medium, design: .rounded))
                                            .foregroundColor(.leetCodeTextSecondary)
                                    }

                                    Spacer()

                                    if showCustomInput {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(.leetCodeOrange)
                                    }
                                }
                                .padding(16)
                                .background(Color.cardBackground)
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(showCustomInput ? Color.leetCodeOrange : Color.clear, lineWidth: 2)
                                )
                            }
                            .buttonStyle(ScaleButtonStyle())

                            if showCustomInput {
                                TextField("Target coins", text: $customAmount)
                                    .keyboardType(.numberPad)
                                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                                    .padding(20)
                                    .background(Color.cardBackground)
                                    .cornerRadius(16)
                                    .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
                                    .foregroundColor(.leetCodeTextPrimary)
                            }
                        }

                        // Current target display
                        HStack {
                            Text("Current Target")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(.leetCodeTextSecondary)
                            Spacer()
                            Text("\(currentTarget)")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.leetCodeTextPrimary)
                        }
                        .padding(20)
                        .background(Color.cardBackground)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)

                        Spacer(minLength: 40)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Select Target")
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
                        if let reward = selectedReward {
                            onSave(reward.coins)
                            dismiss()
                        } else if let amount = Int(customAmount), amount > 0 {
                            onSave(amount)
                            dismiss()
                        }
                    }
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(canSave ? .leetCodeOrange : .gray)
                    .disabled(!canSave)
                }
            }
        }
        .preferredColorScheme(.light)
    }

    private var canSave: Bool {
        selectedReward != nil || (!customAmount.isEmpty && Int(customAmount) ?? 0 > 0)
    }
}

struct RewardOptionRow: View {
    let reward: LeetCodeReward
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Text(reward.emoji)
                    .font(.system(size: 28))
                    .frame(width: 44, height: 44)
                    .background(Color.pageBackground)
                    .cornerRadius(12)

                VStack(alignment: .leading, spacing: 2) {
                    Text(reward.name)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.leetCodeTextPrimary)
                    Text("\(reward.coins) coins")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.leetCodeTextSecondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.leetCodeOrange)
                }
            }
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.leetCodeOrange : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct LeetCodeReward: Identifiable {
    let id = UUID()
    let name: String
    let coins: Int
    let emoji: String

    static let allRewards = [
        LeetCodeReward(name: "LeetCode Cap", coins: 6500, emoji: "🧢"),
        LeetCodeReward(name: "LeetCode T-shirt", coins: 7200, emoji: "👕"),
        LeetCodeReward(name: "LeetCode Kit", coins: 9400, emoji: "📦"),
        LeetCodeReward(name: "LeetCode Laptop Sleeve", coins: 9600, emoji: "💼"),
        LeetCodeReward(name: "LeetCode Big O Notebook", coins: 12000, emoji: "📓"),
        LeetCodeReward(name: "LeetCode Hoodie", coins: 16000, emoji: "🧥")
    ]
}
