import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingEditCoins = false
    @State private var showingEditTarget = false
    @State private var showingAddCoins = false
    @State private var showingEditMonthlyRate = false
    @State private var showingCoinInfo = false
    @State private var showFireworks = false

    // Animation states
    @State private var appearAnimation = false
    @State private var shimmerRotation: Double = 0

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
                        VStack(spacing: 24) {
                            // Header with tech aesthetic
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    let dayOfMonth = Calendar.current.component(.day, from: Date())

                                    HStack(spacing: 8) {
                                        Text("DAY")
                                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                                            .foregroundColor(.leetCodeTextSecondary)
                                            .tracking(2)
                                        Text("\(dayOfMonth)")
                                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                                            .foregroundColor(.leetCodeOrange)
                                    }

                                    Text("Welcome back,")
                                        .font(.system(size: 15, weight: .medium, design: .rounded))
                                        .foregroundColor(.leetCodeTextSecondary)
                                    
                                    HStack(spacing: 8) {
                                        Text("LeetCoder")
                                            .font(.system(size: 32, weight: .bold, design: .rounded))
                                            .foregroundStyle(Color.leetCodeGradient)
                                        
                                        // Tech indicator
                                        Circle()
                                            .fill(Color.leetCodeGreen)
                                            .frame(width: 8, height: 8)
                                            .shadow(color: Color.leetCodeGreen.opacity(0.8), radius: 4, x: 0, y: 0)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.bottom, 8)

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
                    HStack(spacing: 12) {
                        Button(action: { showingCoinInfo = true }) {
                            ZStack {
                                Circle()
                                    .fill(Color.leetCodeTextSecondary.opacity(0.1))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "questionmark.circle.fill")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(Color.leetCodeTextSecondary)
                            }
                        }
                        .buttonStyle(TechButtonStyle())

                        Button(action: { showingAddCoins = true }) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.leetCodeOrange, Color.leetCodeOrangeBright],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 40, height: 40)
                                    .shadow(color: Color.leetCodeOrange.opacity(0.4), radius: 8, x: 0, y: 4)
                                
                                Image(systemName: "plus")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                        }
                        .buttonStyle(TechButtonStyle())
                    }
                }
            }
            .sheet(isPresented: $showingAddCoins) {
                AddCoinsSheet()
            }
            .sheet(isPresented: $showingEditMonthlyRate) {
                EditMonthlyRateView()
            }
            .sheet(isPresented: $showingCoinInfo) {
                CoinInfoView()
            }
        }
        .preferredColorScheme(.light)
        .overlay(
            FireworksView(isActive: showFireworks)
                .allowsHitTesting(false)
        )
        .onChange(of: dataManager.userData.currentCoins) { newCoins in
            if newCoins >= dataManager.userData.targetCoins && !showFireworks {
                showFireworks = true
                
                // Stop fireworks after 4 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    showFireworks = false
                }
            }
        }
        .onAppear {
            appearAnimation = true
            dataManager.checkAndResetDailyActivities()
            dataManager.checkAndShowBannersOnAppOpen()
            
            // Start continuous shimmer animation
            withAnimation(
                Animation.linear(duration: 2.0)
                    .repeatForever(autoreverses: false)
            ) {
                shimmerRotation = 360
            }
        }
    }

    private var progressCard: some View {
        VStack(spacing: 28) {
            // Progress ring with loading bar animation
            ZStack {
                // Background circle
                Circle()
                    .stroke(
                        Color.subtleGray.opacity(0.5),
                        lineWidth: 22
                    )
                    .frame(width: 220, height: 220)

                // Progress circle with subtle orange-yellow (matching Leetcoder gradient)
                Circle()
                    .trim(from: 0, to: progressPercentage)
                    .stroke(
                        Color(hex: "F89F1B").opacity(0.75),
                        style: StrokeStyle(lineWidth: 22, lineCap: .round, lineJoin: .round)
                    )
                    .frame(width: 220, height: 220)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.8, dampingFraction: 0.7), value: progressPercentage)
                    .shadow(color: Color(hex: "F89F1B").opacity(0.12), radius: 8, x: 0, y: 4)
                
                // Loading bar shimmer effect - rotating highlight (subtle)
                if progressPercentage > 0 {
                    Circle()
                        .trim(from: max(0, progressPercentage - 0.1), to: progressPercentage)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.2),
                                    Color.white.opacity(0.5),
                                    Color.white.opacity(0.2)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 22, lineCap: .round)
                        )
                        .frame(width: 220, height: 220)
                        .rotationEffect(.degrees(-90 + shimmerRotation))
                }

                // Center content with monospace font
                VStack(spacing: 10) {
                    Text("\(dataManager.userData.currentCoins)")
                        .font(.system(size: 52, weight: .bold, design: .monospaced))
                        .foregroundStyle(Color.leetCodeGradient.opacity(0.9))
                        .shadow(color: Color(hex: "F89F1B").opacity(0.12), radius: 4, x: 0, y: 2)

                    Text("of \(dataManager.userData.targetCoins)")
                        .font(.system(size: 15, weight: .medium, design: .monospaced))
                        .foregroundColor(.leetCodeTextSecondary)
                        .tracking(0.5)

                    Text("\(Int(progressPercentage * 100))%")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color(hex: "F89F1B").opacity(0.75))
                                .shadow(color: Color(hex: "F89F1B").opacity(0.15), radius: 8, x: 0, y: 4)
                        )
                }
            }
            .padding(.top, 12)

            // Edit buttons with glassmorphism
            HStack(spacing: 14) {
                Button(action: { showingEditCoins = true }) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(Color.leetCodeOrange.opacity(0.15))
                                .frame(width: 36, height: 36)
                            
                            Image(systemName: "bitcoinsign.circle.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.leetCodeOrange)
                        }
                        
                        Text("Edit Current")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(.leetCodeTextPrimary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.glassBackground)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.leetCodeOrange.opacity(0.05))
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.glassBorder, lineWidth: 1.5)
                    )
                    .shadow(color: Color.leetCodeOrange.opacity(0.1), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(TechButtonStyle())

                Button(action: { showingEditTarget = true }) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(Color.leetCodeGreen.opacity(0.15))
                                .frame(width: 36, height: 36)
                            
                            Image(systemName: "target")
                                .font(.system(size: 18))
                                .foregroundColor(.leetCodeGreen)
                        }
                        
                        Text("Edit Target")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(.leetCodeTextPrimary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.glassBackground)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.leetCodeGreen.opacity(0.05))
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.glassBorder, lineWidth: 1.5)
                    )
                    .shadow(color: Color.leetCodeGreen.opacity(0.1), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(TechButtonStyle())
            }
        }
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(Color.glassBackground)
                .background(
                    RoundedRectangle(cornerRadius: 32)
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
            RoundedRectangle(cornerRadius: 32)
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.6), Color.white.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: Color.black.opacity(0.1), radius: 30, x: 0, y: 15)
        .shadow(color: Color.leetCodeOrange.opacity(0.1), radius: 20, x: 0, y: 8)
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
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Color.leetCodeOrange.opacity(0.15))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "clock.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.leetCodeOrange)
                }
                
                Text("ESTIMATED TIME")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.leetCodeTextSecondary)
                    .tracking(1.5)
            }

            if dataManager.userData.estimatedMonthlyCoins > 0 {
                HStack(spacing: 32) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(String(format: "%.1f", dataManager.userData.monthsToTarget))")
                            .font(.system(size: 36, weight: .bold, design: .monospaced))
                            .foregroundStyle(Color.leetCodeGradient)
                            .shadow(color: Color.leetCodeOrange.opacity(0.2), radius: 4, x: 0, y: 2)
                        Text("Months")
                            .font(.system(size: 13, weight: .medium, design: .monospaced))
                            .foregroundColor(.leetCodeTextSecondary)
                            .tracking(0.5)
                    }

                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.clear, Color.subtleGray, Color.clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 1.5, height: 60)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("~\(dataManager.userData.daysToTarget)")
                            .font(.system(size: 36, weight: .bold, design: .monospaced))
                            .foregroundStyle(Color.greenGradient)
                            .shadow(color: Color.leetCodeGreen.opacity(0.2), radius: 4, x: 0, y: 2)
                        Text("Days")
                            .font(.system(size: 13, weight: .medium, design: .monospaced))
                            .foregroundColor(.leetCodeTextSecondary)
                            .tracking(0.5)
                    }

                    Spacer()
                }

                // Progress details with glass effect
                VStack(spacing: 12) {
                    HStack {
                        Text("Remaining")
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                            .foregroundColor(.leetCodeTextSecondary)
                        Spacer()
                        Text("\(max(0, dataManager.userData.targetCoins - dataManager.userData.currentCoins))")
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(.leetCodeTextPrimary)
                        Text("coins")
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                            .foregroundColor(.leetCodeTextSecondary)
                    }

                    Divider()
                        .background(Color.subtleGray.opacity(0.5))

                    HStack {
                        Text("Monthly rate")
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                            .foregroundColor(.leetCodeTextSecondary)
                        Spacer()
                        Button(action: { showingEditMonthlyRate = true }) {
                            HStack(spacing: 6) {
                                Text("\(dataManager.userData.estimatedMonthlyCoins)")
                                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                                Text("coins/mo")
                                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                                Image(systemName: "pencil")
                                    .font(.system(size: 12, weight: .semibold))
                            }
                            .foregroundColor(.leetCodeOrange)
                        }
                    }
                }
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.glassBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.glassBorder, lineWidth: 1)
                )
            } else {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.leetCodeTextSecondary.opacity(0.1))
                            .frame(width: 36, height: 36)
                        
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.leetCodeTextSecondary)
                    }

                    Text("Enable Daily or Weekly Luck in Settings to see estimation")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.leetCodeTextSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.glassBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.glassBorder, lineWidth: 1)
                )
            }
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
        .shadow(color: Color.black.opacity(0.08), radius: 25, x: 0, y: 12)
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

struct TechButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct AddCoinsSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    @State private var showingTimeTravel = false
    @State private var customAmount = ""
    @FocusState private var isCustomAmountFocused: Bool
    
    let sections: [CoinSection] = [
        CoinSection(title: "Check-in Missions", options: [
            CoinOption(title: "Daily Check-in", description: "Log in each day", coins: 1, icon: "checkmark.circle.fill", color: .leetCodeGreen, activityType: .dailyCheckIn),
            CoinOption(title: "30 Day Check-in Streak", description: "Check in 30 days straight", coins: 30, icon: "flame.fill", color: .leetCodeOrange),
            CoinOption(title: "Complete Daily Challenge", description: "Finish the daily challenge", coins: 10, icon: "brain.head.profile.fill", color: .leetCodeOrange, activityType: .dailyProblem),
            CoinOption(title: "Weekly Premium Challenges", description: "Complete weekly premium challenges", coins: 35, icon: "star.circle.fill", color: .leetCodeYellow, weeklyKey: "weeklyPremium"),
            CoinOption(title: "Lucky Monday", description: "Claim on contest page", coins: 10, icon: "clover.fill", color: .leetCodeGreen, activityType: .weeklyLuck)
        ]),
        CoinSection(title: "Contribution Missions", options: [
            CoinOption(title: "Contribute a Testcase", description: "Submit a new testcase", coins: 100, icon: "doc.text.fill", color: .leetCodeGreen),
            CoinOption(title: "Contribute a Question", description: "Submit a new question", coins: 1000, icon: "questionmark.circle.fill", color: .leetCodeOrange),
            CoinOption(title: "File Content Issue", description: "Report a feedback repo issue", coins: 100, icon: "exclamationmark.bubble.fill", color: .leetCodeYellow),
            CoinOption(title: "Report Contest Violation", description: "Report a contest violation", coins: 100, icon: "flag.fill", color: .leetCodeOrange)
        ]),
        CoinSection(title: "Contest Missions", options: [
            CoinOption(title: "Join a Contest", description: "Join weekly or biweekly", coins: 5, icon: "trophy.fill", color: .leetCodeYellow),
            CoinOption(title: "Join Weekly + Biweekly", description: "Join both contests in a week", coins: 35, icon: "trophy.circle.fill", color: .leetCodeOrange),
            CoinOption(title: "1st Place Contest", description: "Finish first in a contest", coins: 5000, icon: "crown.fill", color: .leetCodeYellow),
            CoinOption(title: "2nd Place Contest", description: "Finish second in a contest", coins: 2500, icon: "medal.fill", color: .leetCodeOrange),
            CoinOption(title: "3rd Place Contest", description: "Finish third in a contest", coins: 1000, icon: "medal", color: .leetCodeOrange),
            CoinOption(title: "Top 50 Contest", description: "Place in the top 50", coins: 300, icon: "star.circle.fill", color: .leetCodeYellow),
            CoinOption(title: "Top 100 Contest", description: "Place in the top 100", coins: 100, icon: "star.fill", color: .leetCodeYellow),
            CoinOption(title: "Top 200 Contest", description: "Place in the top 200", coins: 50, icon: "star.lefthalf.fill", color: .leetCodeYellow),
            CoinOption(title: "First Contest Submission", description: "Submit to your first contest", coins: 200, icon: "paperplane.fill", color: .leetCodeGreen, oneTimeKey: "firstContestSubmission")
        ]),
        CoinSection(title: "Profile Missions", options: [
            CoinOption(title: "Connect LinkedIn", description: "One-time LinkedIn connect", coins: 10, icon: "link.circle.fill", color: .leetCodeGreen, oneTimeKey: "connectLinkedIn"),
            CoinOption(title: "Connect Google", description: "One-time Google connect", coins: 10, icon: "globe", color: .leetCodeGreen, oneTimeKey: "connectGoogle"),
            CoinOption(title: "Connect GitHub", description: "One-time GitHub connect", coins: 10, icon: "chevron.left.slash.chevron.right", color: .leetCodeGreen, oneTimeKey: "connectGitHub"),
            CoinOption(title: "Connect Facebook", description: "One-time Facebook connect", coins: 10, icon: "person.crop.circle.badge.checkmark", color: .leetCodeGreen, oneTimeKey: "connectFacebook")
        ])
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Color.pageBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // Time Travel Button
                        Button(action: { showingTimeTravel = true }) {
                            HStack(spacing: 12) {
                                Image(systemName: "clock.arrow.circlepath")
                                    .font(.system(size: 20))
                                    .foregroundColor(.leetCodeOrange)
                                
                                Text("Forgot to log something? Time Travel")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(.leetCodeTextPrimary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.leetCodeTextSecondary)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.cardBackground)
                                    .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // Horizontal Options
                        VStack(alignment: .leading, spacing: 24) {
                            ForEach(sections) { section in
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(section.title)
                                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                                        .foregroundColor(.leetCodeTextSecondary)
                                        .textCase(.uppercase)
                                        .tracking(0.5)

                                    VStack(spacing: 12) {
                                        ForEach(section.options) { option in
                                            let isCompleted = option.oneTimeKey.map { dataManager.isOneTimeMissionCompleted($0) } ?? false
                                            let isActivityCompleted = option.activityType.map { dataManager.isActivityCompletedToday($0) } ?? false
                                            let isWeeklyCompleted = option.weeklyKey.map { dataManager.isWeeklyMissionCompleted($0) } ?? false
                                            let isOptionCompleted = isCompleted || isActivityCompleted || isWeeklyCompleted

                                            Button(action: {
                                                if isOptionCompleted {
                                                    return
                                                }

                                                if let activityType = option.activityType {
                                                    dataManager.confirmCheckIn(for: activityType)
                                                } else if let weeklyKey = option.weeklyKey {
                                                    dataManager.addCoins(option.coins)
                                                    dataManager.completeWeeklyMission(weeklyKey)
                                                } else {
                                                    dataManager.addCoins(option.coins)
                                                }

                                                if let key = option.oneTimeKey {
                                                    dataManager.completeOneTimeMission(key)
                                                }

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

                                                    VStack(alignment: .leading, spacing: 2) {
                                                        Text(option.title)
                                                            .font(.system(size: 16, weight: .medium, design: .rounded))
                                                            .foregroundColor(.leetCodeTextPrimary)

                                                        Text(option.description)
                                                            .font(.system(size: 12, weight: .regular, design: .rounded))
                                                            .foregroundColor(.leetCodeTextSecondary)
                                                            .lineLimit(1)
                                                    }

                                                    Spacer()

                                                    if isOptionCompleted {
                                                        Text("Completed")
                                                            .font(.system(size: 14, weight: .bold, design: .rounded))
                                                            .foregroundColor(.leetCodeGreen)
                                                    } else {
                                                        Text("+\(option.coins)")
                                                            .font(.system(size: 18, weight: .bold, design: .rounded))
                                                            .foregroundColor(option.color)
                                                    }
                                                }
                                                .padding(16)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 24)
                                                        .fill(Color.cardBackground)
                                                        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
                                                )
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 24)
                                                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                                )
                                            }
                                            .disabled(isOptionCompleted)
                                            .opacity(isOptionCompleted ? 0.6 : 1)
                                            .buttonStyle(ScaleButtonStyle())
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.horizontal, 20)
                            
                            // Custom Amount
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Custom Entry")
                                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                                    .foregroundColor(.leetCodeTextSecondary)
                                    .textCase(.uppercase)
                                    .tracking(0.5)
                                    .padding(.horizontal, 20)
                                
                                HStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.gray.opacity(0.12))
                                            .frame(width: 44, height: 44)
                                        
                                        Image(systemName: "pencil")
                                            .font(.system(size: 20))
                                            .foregroundColor(.leetCodeTextSecondary)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Custom Amount")
                                            .font(.system(size: 16, weight: .medium, design: .rounded))
                                            .foregroundColor(.leetCodeTextPrimary)
                                        
                                        TextField("Enter coins...", text: $customAmount)
                                            .keyboardType(.numberPad)
                                            .font(.system(size: 14, design: .rounded))
                                            .focused($isCustomAmountFocused)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        if let amount = Int(customAmount), amount > 0 {
                                            dataManager.addCoins(amount)
                                            customAmount = ""
                                            isCustomAmountFocused = false
                                            dismiss()
                                        }
                                    }) {
                                        Image(systemName: "plus")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(width: 32, height: 32)
                                            .background(
                                                Circle()
                                                    .fill(Int(customAmount) ?? 0 > 0 ? Color.leetCodeOrange : Color.gray.opacity(0.3))
                                            )
                                    }
                                    .disabled((Int(customAmount) ?? 0) <= 0)
                                    .animation(.easeInOut, value: customAmount)
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(Color.cardBackground)
                                        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                )
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
        .sheet(isPresented: $showingTimeTravel) {
            TimeTravelView()
        }
    }
}

struct CoinSection: Identifiable {
    let id = UUID()
    let title: String
    let options: [CoinOption]
}

struct CoinOption: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let coins: Int
    let icon: String
    let color: Color
    let oneTimeKey: String?
    let activityType: ActivityType?
    let weeklyKey: String?

    init(
        title: String,
        description: String,
        coins: Int,
        icon: String,
        color: Color,
        oneTimeKey: String? = nil,
        activityType: ActivityType? = nil,
        weeklyKey: String? = nil
    ) {
        self.title = title
        self.description = description
        self.coins = coins
        self.icon = icon
        self.color = color
        self.oneTimeKey = oneTimeKey
        self.activityType = activityType
        self.weeklyKey = weeklyKey
    }
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
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .padding(24)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.cardBackground)
                                    .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                            )
                            
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
                                .background(
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(Color.cardBackground)
                                        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(showCustomInput ? Color.leetCodeOrange : Color.white.opacity(0.5), lineWidth: showCustomInput ? 2 : 1)
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
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.cardBackground)
                                .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                        )

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
        .preferredColorScheme(.light)
    }
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
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.cardBackground)
                    .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(isSelected ? Color.leetCodeOrange : Color.white.opacity(0.5), lineWidth: isSelected ? 2 : 1)
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
