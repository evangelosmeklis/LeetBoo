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

    var progressPercentage: Double {
        min(1.0, Double(dataManager.userData.currentCoins) / Double(max(1, dataManager.userData.targetCoins)))
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Dark background
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
                            // Header Section
                            VStack(spacing: 8) {
                                Text("Understand your")
                                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                                    .foregroundColor(.leetCodeTextPrimary)
                                
                                Text("Progress")
                                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                                    .foregroundColor(.leetCodeTextPrimary)
                            }
                            .padding(.top, 20)

                            // Main Progress Card
                            VStack(spacing: 0) {
                                // Card Header
                                HStack {
                                    Button(action: {}) {
                                        Image(systemName: "chevron.left")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.leetCodeTextPrimary)
                                    }
                                    .opacity(0) // Hidden for now
                                    
                                    Spacer()
                                    
                                    Text("TODAY")
                                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                                        .foregroundColor(.leetCodeTextPrimary)
                                        .tracking(1.5)
                                    
                                    Spacer()
                                    
                                    Button(action: { showingCoinInfo = true }) {
                                        ZStack {
                                            Circle()
                                                .stroke(Color.subtleGray, lineWidth: 1.5)
                                                .frame(width: 28, height: 28)
                                            
                                            Text("i")
                                                .font(.system(size: 14, weight: .semibold, design: .serif))
                                                .italic()
                                                .foregroundColor(.leetCodeTextSecondary)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                                .padding(.bottom, 16)
                                
                                // Large Circular Progress Indicator
                                ZStack {
                                    // Background track
                                    Circle()
                                        .stroke(
                                            Color.subtleGray.opacity(0.3),
                                            lineWidth: 16
                                        )
                                        .frame(width: 200, height: 200)
                                    
                                    // Gray segment at top (small gap)
                                    Circle()
                                        .trim(from: 0.92, to: 1.0)
                                        .stroke(
                                            Color.subtleGray.opacity(0.5),
                                            style: StrokeStyle(lineWidth: 16, lineCap: .round)
                                        )
                                        .frame(width: 200, height: 200)
                                        .rotationEffect(.degrees(-90))
                                    
                                    // Progress circle
                                    Circle()
                                        .trim(from: 0, to: min(progressPercentage, 0.92))
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.leetCodeGreen, Color.leetCodeGreenBright],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ),
                                            style: StrokeStyle(lineWidth: 16, lineCap: .round)
                                        )
                                        .frame(width: 200, height: 200)
                                        .rotationEffect(.degrees(-90))
                                        .animation(.spring(response: 0.8, dampingFraction: 0.7), value: progressPercentage)
                                    
                                    // Center content
                                    VStack(spacing: 4) {
                                        Text("LEETBOO")
                                            .font(.system(size: 11, weight: .medium, design: .monospaced))
                                            .foregroundColor(.leetCodeTextSecondary)
                                            .tracking(2)
                                        
                                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                                            Text("\(dataManager.userData.currentCoins)")
                                                .font(.system(size: 52, weight: .bold, design: .rounded))
                                                .foregroundColor(.leetCodeTextPrimary)
                                        }
                                        
                                        Text("COINS")
                                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                                            .foregroundColor(.leetCodeGreen)
                                            .tracking(1.5)
                                    }
                                }
                                .padding(.vertical, 20)
                                
                                // Stats rows
                                VStack(spacing: 0) {
                                    Divider()
                                        .background(Color.subtleGray.opacity(0.5))
                                    
                                    // Target row
                                    HStack {
                                        HStack(spacing: 10) {
                                            Image(systemName: "target")
                                                .font(.system(size: 16))
                                                .foregroundColor(.leetCodeTextSecondary)
                                            
                                            Text("TARGET")
                                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                                .foregroundColor(.leetCodeTextSecondary)
                                                .tracking(1)
                                        }
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 6) {
                                            Text("\(dataManager.userData.targetCoins)")
                                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                                                .foregroundColor(.leetCodeGreen)
                                            
                                            Image(systemName: "chevron.up")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(.leetCodeGreen)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 14)
                                    
                                    Divider()
                                        .background(Color.subtleGray.opacity(0.5))
                                    
                                    // Progress row
                                    HStack {
                                        HStack(spacing: 10) {
                                            Image(systemName: "chart.line.uptrend.xyaxis")
                                                .font(.system(size: 16))
                                                .foregroundColor(.leetCodeTextSecondary)
                                            
                                            Text("PROGRESS")
                                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                                .foregroundColor(.leetCodeTextSecondary)
                                                .tracking(1)
                                        }
                                        
                                        Spacer()
                                        
                                        Text("\(Int(progressPercentage * 100))%")
                                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                                            .foregroundColor(.leetCodeGreen)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 14)
                                    
                                    Divider()
                                        .background(Color.subtleGray.opacity(0.5))
                                    
                                    // Remaining row
                                    HStack {
                                        HStack(spacing: 10) {
                                            Image(systemName: "hourglass")
                                                .font(.system(size: 16))
                                                .foregroundColor(.leetCodeTextSecondary)
                                            
                                            Text("REMAINING")
                                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                                .foregroundColor(.leetCodeTextSecondary)
                                                .tracking(1)
                                        }
                                        
                                        Spacer()
                                        
                                        Text("\(max(0, dataManager.userData.targetCoins - dataManager.userData.currentCoins))")
                                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                                            .foregroundColor(.leetCodeTextSecondary)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 14)
                                }
                                
                                // Today vs goal indicator
                                HStack(spacing: 8) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "triangle.fill")
                                            .font(.system(size: 8))
                                            .foregroundColor(.leetCodeGreen)
                                        Image(systemName: "triangle.fill")
                                            .font(.system(size: 8))
                                            .foregroundColor(.leetCodeOrange)
                                            .rotationEffect(.degrees(180))
                                    }
                                    
                                    Text("Today vs. goal")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .foregroundColor(.leetCodeTextSecondary)
                                }
                                .padding(.vertical, 12)
                                
                                // Summary message
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(getSummaryMessage())
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(.leetCodeTextSecondary)
                                        .lineSpacing(4)
                                    
                                    Button(action: { showingCoinInfo = true }) {
                                        HStack(spacing: 6) {
                                            Text("EXPLORE MY PROGRESS")
                                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                                .tracking(0.5)
                                            
                                            Image(systemName: "arrow.right")
                                                .font(.system(size: 12, weight: .bold))
                                        }
                                        .foregroundColor(.leetCodeGreen)
                                    }
                                    .padding(.top, 4)
                                }
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.leetCodeGreen.opacity(0.3), lineWidth: 1)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.leetCodeGreen.opacity(0.05))
                                        )
                                )
                                .padding(.horizontal, 16)
                                .padding(.bottom, 20)
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
                            .offset(y: appearAnimation ? 0 : 30)
                            .opacity(appearAnimation ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: appearAnimation)

                            // Quick Actions
                            HStack(spacing: 12) {
                                Button(action: { showingEditCoins = true }) {
                                    VStack(spacing: 10) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.leetCodeOrange.opacity(0.15))
                                                .frame(width: 44, height: 44)
                                            
                                            Image(systemName: "pencil")
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundColor(.leetCodeOrange)
                                        }
                                        
                                        Text("Edit Current")
                                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                                            .foregroundColor(.leetCodeTextPrimary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(Color.subtleGray.opacity(0.5), lineWidth: 1)
                                            )
                                    )
                                }
                                .buttonStyle(TechButtonStyle())
                                
                                Button(action: { showingEditTarget = true }) {
                                    VStack(spacing: 10) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.leetCodeGreen.opacity(0.15))
                                                .frame(width: 44, height: 44)
                                            
                                            Image(systemName: "target")
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundColor(.leetCodeGreen)
                                        }
                                        
                                        Text("Edit Target")
                                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                                            .foregroundColor(.leetCodeTextPrimary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(Color.subtleGray.opacity(0.5), lineWidth: 1)
                                            )
                                    )
                                }
                                .buttonStyle(TechButtonStyle())
                            }
                            .padding(.horizontal, 20)
                            .offset(y: appearAnimation ? 0 : 30)
                            .opacity(appearAnimation ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: appearAnimation)

                            // Estimation Card
                            estimationCard
                                .offset(y: appearAnimation ? 0 : 30)
                                .opacity(appearAnimation ? 1 : 0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: appearAnimation)
                        }
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
                                    .stroke(Color.subtleGray, lineWidth: 1.5)
                                    .frame(width: 40, height: 40)
                                
                                Text("i")
                                    .font(.system(size: 18, weight: .semibold, design: .serif))
                                    .italic()
                                    .foregroundColor(.leetCodeTextSecondary)
                            }
                        }
                        .buttonStyle(TechButtonStyle())

                        Button(action: { showingAddCoins = true }) {
                            ZStack {
                                Circle()
                                    .fill(Color.leetCodeGreen)
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "plus")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(.black)
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
        .preferredColorScheme(.dark)
        .overlay(
            FireworksView(isActive: showFireworks)
                .allowsHitTesting(false)
        )
        .onChange(of: dataManager.userData.currentCoins) { _, newCoins in
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
        }
    }
    
    private func getSummaryMessage() -> String {
        if progressPercentage >= 1.0 {
            return "Congratulations! You've reached your goal. Time to set a new target!"
        } else if progressPercentage >= 0.8 {
            return "You're almost there! Just \(max(0, dataManager.userData.targetCoins - dataManager.userData.currentCoins)) coins away from your goal."
        } else if progressPercentage >= 0.5 {
            return "Great progress! You're past the halfway mark. Keep the momentum going."
        } else {
            return "Your journey has begun! Complete daily missions to earn more coins."
        }
    }

    private var estimationCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                HStack(spacing: 10) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.leetCodeBlue)
                    
                    Text("ESTIMATED TIME")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.leetCodeTextSecondary)
                        .tracking(1)
                }
                
                Spacer()
                
                Button(action: { showingCoinInfo = true }) {
                    ZStack {
                        Circle()
                            .stroke(Color.subtleGray, lineWidth: 1.5)
                            .frame(width: 24, height: 24)
                        
                        Text("i")
                            .font(.system(size: 12, weight: .semibold, design: .serif))
                            .italic()
                            .foregroundColor(.leetCodeTextSecondary)
                    }
                }
            }

            if dataManager.userData.estimatedMonthlyCoins > 0 {
                HStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(String(format: "%.1f", dataManager.userData.monthsToTarget))")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.leetCodeTextPrimary)
                        Text("Months")
                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                            .foregroundColor(.leetCodeTextSecondary)
                            .tracking(0.5)
                    }

                    Rectangle()
                        .fill(Color.subtleGray.opacity(0.5))
                        .frame(width: 1, height: 50)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("~\(dataManager.userData.daysToTarget)")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.leetCodeBlue)
                        Text("Days")
                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                            .foregroundColor(.leetCodeTextSecondary)
                            .tracking(0.5)
                    }

                    Spacer()
                }

                // Monthly rate row
                HStack {
                    Text("Monthly rate")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.leetCodeTextSecondary)
                    Spacer()
                    Button(action: { showingEditMonthlyRate = true }) {
                        HStack(spacing: 6) {
                            Text("\(dataManager.userData.estimatedMonthlyCoins)")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                            Text("coins/mo")
                                .font(.system(size: 12, weight: .medium, design: .monospaced))
                            Image(systemName: "pencil")
                                .font(.system(size: 11, weight: .semibold))
                        }
                        .foregroundColor(.leetCodeBlue)
                    }
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.whoopDarkElevated)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.subtleGray.opacity(0.5), lineWidth: 1)
                        )
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
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.leetCodeTextSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.whoopDarkElevated)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.subtleGray.opacity(0.5), lineWidth: 1)
                        )
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.subtleGray.opacity(0.5), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
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

                VStack(spacing: 0) {
                    // Navigation bar
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.leetCodeTextPrimary)
                        }
                        
                        Spacer()
                        
                        Text("ADD COINS")
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundColor(.leetCodeTextPrimary)
                            .tracking(1.5)
                        
                        Spacer()
                        
                        Button(action: { dismiss() }) {
                            ZStack {
                                Circle()
                                    .fill(Color.subtleGray.opacity(0.3))
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: "xmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.leetCodeTextSecondary)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            // Header Section
                            VStack(spacing: 8) {
                                Text("Add coins to")
                                    .font(.system(size: 26, weight: .semibold, design: .rounded))
                                    .foregroundColor(.leetCodeTextPrimary)
                                
                                Text("your progress")
                                    .font(.system(size: 26, weight: .semibold, design: .rounded))
                                    .foregroundColor(.leetCodeTextPrimary)
                            }
                            .padding(.top, 8)
                        
                        // Time Travel Button
                        Button(action: { showingTimeTravel = true }) {
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(Color.leetCodeOrange.opacity(0.15))
                                        .frame(width: 44, height: 44)
                                    
                                    Image(systemName: "clock.arrow.circlepath")
                                        .font(.system(size: 20))
                                        .foregroundColor(.leetCodeOrange)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Forgot to log something?")
                                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                                        .foregroundColor(.leetCodeTextPrimary)
                                    
                                    Text("Time Travel")
                                        .font(.system(size: 13, weight: .medium, design: .rounded))
                                        .foregroundColor(.leetCodeTextSecondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.leetCodeTextSecondary)
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
                        }
                        .padding(.horizontal, 20)
                        
                        // Sections
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(sections) { section in
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(section.title.uppercased())
                                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                                        .foregroundColor(.leetCodeTextSecondary)
                                        .tracking(1.5)
                                        .padding(.horizontal, 20)

                                    VStack(spacing: 8) {
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
                                                HStack(spacing: 14) {
                                                    ZStack {
                                                        Circle()
                                                            .fill(option.color.opacity(0.15))
                                                            .frame(width: 40, height: 40)

                                                        Image(systemName: option.icon)
                                                            .font(.system(size: 18))
                                                            .foregroundColor(option.color)
                                                    }

                                                    VStack(alignment: .leading, spacing: 2) {
                                                        Text(option.title)
                                                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                                                            .foregroundColor(.leetCodeTextPrimary)

                                                        Text(option.description)
                                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                                            .foregroundColor(.leetCodeTextSecondary)
                                                            .lineLimit(1)
                                                    }

                                                    Spacer()

                                                    if isOptionCompleted {
                                                        Text("Done")
                                                            .font(.system(size: 13, weight: .bold, design: .rounded))
                                                            .foregroundColor(.leetCodeGreen)
                                                    } else {
                                                        Text("+\(option.coins)")
                                                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                                                            .foregroundColor(option.color)
                                                    }
                                                }
                                                .padding(14)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 14)
                                                        .fill(Color.cardBackground)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 14)
                                                                .stroke(Color.subtleGray.opacity(0.5), lineWidth: 1)
                                                        )
                                                )
                                            }
                                            .disabled(isOptionCompleted)
                                            .opacity(isOptionCompleted ? 0.5 : 1)
                                            .buttonStyle(ScaleButtonStyle())
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                            
                        // Custom Amount
                        VStack(alignment: .leading, spacing: 12) {
                            Text("CUSTOM ENTRY")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(.leetCodeTextSecondary)
                                .tracking(1.5)
                                .padding(.horizontal, 20)
                            
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(Color.subtleGray.opacity(0.3))
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: "pencil")
                                        .font(.system(size: 18))
                                        .foregroundColor(.leetCodeTextSecondary)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Custom Amount")
                                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                                        .foregroundColor(.leetCodeTextPrimary)
                                    
                                    TextField("Enter coins...", text: $customAmount)
                                        .keyboardType(.numberPad)
                                        .font(.system(size: 13, design: .rounded))
                                        .foregroundColor(.leetCodeTextSecondary)
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
                                    ZStack {
                                        Circle()
                                            .fill(Int(customAmount) ?? 0 > 0 ? Color.leetCodeGreen : Color.subtleGray.opacity(0.3))
                                            .frame(width: 36, height: 36)
                                        
                                        Image(systemName: "plus")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(Int(customAmount) ?? 0 > 0 ? .black : .leetCodeTextSecondary)
                                    }
                                }
                                .disabled((Int(customAmount) ?? 0) <= 0)
                            }
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.subtleGray.opacity(0.5), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, 20)
                        }

                        // Current Status
                        VStack(alignment: .leading, spacing: 12) {
                            Text("CURRENT STATUS")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(.leetCodeTextSecondary)
                                .tracking(1.5)
                                .padding(.horizontal, 20)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Total Coins")
                                        .font(.system(size: 13, weight: .medium, design: .rounded))
                                        .foregroundColor(.leetCodeTextSecondary)
                                    Text("\(dataManager.userData.currentCoins)")
                                        .font(.system(size: 32, weight: .bold, design: .rounded))
                                        .foregroundColor(.leetCodeGreen)
                                }
                                Spacer()
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.leetCodeGreen.opacity(0.3), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.bottom, 32)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
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
                
                VStack(spacing: 0) {
                    // Navigation bar
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.leetCodeTextPrimary)
                        }
                        
                        Spacer()
                        
                        Text("EDIT RATE")
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundColor(.leetCodeTextPrimary)
                            .tracking(1.5)
                        
                        Spacer()
                        
                        Button(action: {
                            if let rate = Int(rateText), rate > 0 {
                                dataManager.updateCustomMonthlyRate(rate)
                                dismiss()
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(rateText.isEmpty ? Color.subtleGray.opacity(0.3) : Color.leetCodeGreen.opacity(0.15))
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(rateText.isEmpty ? .leetCodeTextSecondary : .leetCodeGreen)
                            }
                        }
                        .disabled(rateText.isEmpty)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            // Header
                            VStack(spacing: 8) {
                                Text("Set your")
                                    .font(.system(size: 26, weight: .semibold, design: .rounded))
                                    .foregroundColor(.leetCodeTextPrimary)
                                
                                Text("Monthly Rate")
                                    .font(.system(size: 26, weight: .semibold, design: .rounded))
                                    .foregroundColor(.leetCodeTextPrimary)
                            }
                            .padding(.top, 8)
                            
                            // Input card
                            VStack(spacing: 20) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("COINS PER MONTH")
                                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                                        .foregroundColor(.leetCodeTextSecondary)
                                        .tracking(1.5)
                                    
                                    TextField("Enter rate", text: $rateText)
                                        .keyboardType(.numberPad)
                                        .font(.system(size: 36, weight: .bold, design: .rounded))
                                        .foregroundColor(.leetCodeTextPrimary)
                                        .padding(20)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(Color.whoopDarkElevated)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .stroke(Color.subtleGray.opacity(0.5), lineWidth: 1)
                                                )
                                        )
                                }
                                
                                Text("This value determines the estimated time to reach your target.")
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundColor(.leetCodeTextSecondary)
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.subtleGray.opacity(0.5), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, 20)
                            
                            if dataManager.userData.customMonthlyRate != nil {
                                Button(action: {
                                    dataManager.updateCustomMonthlyRate(nil)
                                    dismiss()
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "arrow.counterclockwise")
                                            .font(.system(size: 14, weight: .semibold))
                                        
                                        Text("Reset to Automatic")
                                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                                    }
                                    .foregroundColor(.leetCodeOrange)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Color.leetCodeOrange.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 14)
                                                    .stroke(Color.leetCodeOrange.opacity(0.3), lineWidth: 1)
                                            )
                                    )
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 32)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
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

                VStack(spacing: 0) {
                    // Navigation bar
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.leetCodeTextPrimary)
                        }
                        
                        Spacer()
                        
                        Text("SET TARGET")
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundColor(.leetCodeTextPrimary)
                            .tracking(1.5)
                        
                        Spacer()
                        
                        Button(action: {
                            if let reward = selectedReward {
                                onSave(reward.coins)
                                dismiss()
                            } else if let amount = Int(customAmount), amount > 0 {
                                onSave(amount)
                                dismiss()
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(canSave ? Color.leetCodeGreen.opacity(0.15) : Color.subtleGray.opacity(0.3))
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(canSave ? .leetCodeGreen : .leetCodeTextSecondary)
                            }
                        }
                        .disabled(!canSave)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            // Header
                            VStack(spacing: 8) {
                                Text("Set your")
                                    .font(.system(size: 26, weight: .semibold, design: .rounded))
                                    .foregroundColor(.leetCodeTextPrimary)
                                
                                Text("Target Coins")
                                    .font(.system(size: 26, weight: .semibold, design: .rounded))
                                    .foregroundColor(.leetCodeTextPrimary)
                            }
                            .padding(.top, 8)
                            
                            VStack(spacing: 20) {
                                // Preset rewards
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("LEETCODE REWARDS")
                                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                                        .foregroundColor(.leetCodeTextSecondary)
                                        .tracking(1.5)

                                    VStack(spacing: 8) {
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
                                    Text("CUSTOM TARGET")
                                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                                        .foregroundColor(.leetCodeTextSecondary)
                                        .tracking(1.5)

                                    Button(action: {
                                        showCustomInput = true
                                        selectedReward = nil
                                    }) {
                                        HStack(spacing: 12) {
                                            ZStack {
                                                Circle()
                                                    .fill(Color.leetCodeYellow.opacity(0.15))
                                                    .frame(width: 40, height: 40)

                                                Image(systemName: "pencil.circle.fill")
                                                    .font(.system(size: 18))
                                                    .foregroundColor(.leetCodeYellow)
                                            }

                                            VStack(alignment: .leading, spacing: 2) {
                                                Text("Custom Amount")
                                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                                                    .foregroundColor(.leetCodeTextPrimary)
                                                Text("Enter your own target")
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                    .foregroundColor(.leetCodeTextSecondary)
                                            }

                                            Spacer()

                                            if showCustomInput {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .font(.system(size: 22))
                                                    .foregroundColor(.leetCodeGreen)
                                            }
                                        }
                                        .padding(14)
                                        .background(
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(Color.cardBackground)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 14)
                                                        .stroke(showCustomInput ? Color.leetCodeGreen : Color.subtleGray.opacity(0.5), lineWidth: showCustomInput ? 2 : 1)
                                                )
                                        )
                                    }
                                    .buttonStyle(ScaleButtonStyle())

                                    if showCustomInput {
                                        TextField("Target coins", text: $customAmount)
                                            .keyboardType(.numberPad)
                                            .font(.system(size: 28, weight: .bold, design: .rounded))
                                            .foregroundColor(.leetCodeTextPrimary)
                                            .padding(18)
                                            .background(
                                                RoundedRectangle(cornerRadius: 14)
                                                    .fill(Color.whoopDarkElevated)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 14)
                                                            .stroke(Color.subtleGray.opacity(0.5), lineWidth: 1)
                                                    )
                                            )
                                    }
                                }

                                // Current target display
                                HStack {
                                    Text("Current Target")
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(.leetCodeTextSecondary)
                                    Spacer()
                                    Text("\(currentTarget)")
                                        .font(.system(size: 18, weight: .bold, design: .monospaced))
                                        .foregroundColor(.leetCodeGreen)
                                }
                                .padding(18)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(Color.leetCodeGreen.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 32)
                        }
                        .padding(.top, 8)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
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
            HStack(spacing: 12) {
                Text(reward.emoji)
                    .font(.system(size: 24))
                    .frame(width: 40, height: 40)
                    .background(Color.whoopDarkElevated)
                    .cornerRadius(10)

                VStack(alignment: .leading, spacing: 2) {
                    Text(reward.name)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.leetCodeTextPrimary)
                    Text("\(reward.coins) coins")
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundColor(.leetCodeTextSecondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.leetCodeGreen)
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(isSelected ? Color.leetCodeGreen : Color.subtleGray.opacity(0.5), lineWidth: isSelected ? 2 : 1)
                    )
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
