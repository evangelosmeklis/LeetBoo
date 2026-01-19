import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var reminderTimes: [Date]
    @State private var reminderFrequency: ReminderFrequency
    @State private var magicNotificationsEnabled: Bool
    @State private var showingSubscription = false
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var contentMaxWidth: CGFloat? {
        horizontalSizeClass == .regular ? 640 : nil
    }

    init() {
        let settings = DataManager().userData.notificationSettings
        _reminderTimes = State(initialValue: settings.dailyReminderTimes)
        _reminderFrequency = State(initialValue: settings.reminderFrequency)
        _magicNotificationsEnabled = State(initialValue: settings.magicNotificationsEnabled)
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Dark background
                Color.pageBackground
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Header Section
                        VStack(spacing: 8) {
                            Text("Customize your")
                                .font(.system(size: 28, weight: .semibold, design: .rounded))
                                .foregroundColor(.leetCodeTextPrimary)
                            
                            Text("experience")
                                .font(.system(size: 28, weight: .semibold, design: .rounded))
                                .foregroundColor(.leetCodeTextPrimary)
                        }
                        .padding(.top, 20)
                        
                        // Activities Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 10) {
                                ZStack {
                                    Circle()
                                        .fill(Color.leetCodeOrange.opacity(0.15))
                                        .frame(width: 28, height: 28)
                                    
                                    Image(systemName: "bell.fill")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.leetCodeOrange)
                                }
                                
                                Text("NOTIFICATIONS")
                                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                                    .foregroundColor(.leetCodeTextSecondary)
                                    .tracking(1.5)
                            }
                            .padding(.horizontal, 20)

                            VStack(spacing: 0) {
                                ForEach(dataManager.userData.activities) { activity in
                                    ActivityToggleRow(
                                        activity: activity,
                                        isPremiumLocked: activity.type == .weeklyLuck && !subscriptionManager.isSubscribed,
                                        onPremiumTap: { showingSubscription = true }
                                    )
                                    if activity.id != dataManager.userData.activities.last?.id {
                                        Divider()
                                            .background(Color.subtleGray.opacity(0.5))
                                            .padding(.horizontal, 20)
                                    }
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.subtleGray.opacity(0.5), lineWidth: 1)
                                    )
                            )

                            if !subscriptionManager.isSubscribed {
                                Button(action: { showingSubscription = true }) {
                                    HStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.leetCodeGreen.opacity(0.15))
                                                .frame(width: 40, height: 40)

                                            Image(systemName: "crown.fill")
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundColor(.leetCodeGreen)
                                        }

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Upgrade to Pro")
                                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                                .foregroundColor(.leetCodeTextPrimary)

                                            Text("Unlock weekly luck + premium perks")
                                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                                .foregroundColor(.leetCodeTextSecondary)
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.leetCodeTextSecondary)
                                    }
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.subtleGray.opacity(0.5), lineWidth: 1)
                                            )
                                    )
                                }
                                .buttonStyle(.plain)
                            }

                        }
                        .padding(.horizontal, 20)

                        if dataManager.userData.activities.contains(where: { $0.isEnabled }) {
                            let isMagicLocked = !subscriptionManager.isSubscribed

                            // Magic Notifications Section
                            VStack(alignment: .leading, spacing: 0) {
                                Toggle(isOn: $magicNotificationsEnabled) {
                                    HStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.leetCodePurple.opacity(0.15))
                                                .frame(width: 40, height: 40)
                                            
                                            Image(systemName: "wand.and.stars")
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundColor(.leetCodePurple)
                                        }
                                        
                                        Text("Magic Notifications")
                                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                                            .foregroundColor(.leetCodeTextPrimary)

                                        Spacer()

                                        if isMagicLocked {
                                            Label("Premium", systemImage: "lock.fill")
                                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                                .foregroundColor(.leetCodeYellow)
                                        }
                                    }
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .leetCodeGreen))
                                .padding(16)
                                .disabled(isMagicLocked)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if isMagicLocked {
                                        showingSubscription = true
                                    }
                                }
                                .onChange(of: magicNotificationsEnabled) { _, _ in
                                    updateSettings()
                                }
                                
                                if magicNotificationsEnabled {
                                    Divider()
                                        .background(Color.subtleGray.opacity(0.5))
                                        .padding(.horizontal, 16)
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        HStack(spacing: 10) {
                                            Image(systemName: "trophy.fill")
                                                .font(.system(size: 14))
                                                .foregroundColor(.leetCodeYellow)
                                            Text("Weekend contest reminders")
                                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                                .foregroundColor(.leetCodeTextSecondary)
                                        }
                                        
                                        HStack(spacing: 10) {
                                            Image(systemName: "chart.line.uptrend.xyaxis")
                                                .font(.system(size: 14))
                                                .foregroundColor(.leetCodeOrange)
                                            Text("Monthly coins + goal progress")
                                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                                .foregroundColor(.leetCodeTextSecondary)
                                        }
                                        
                                        HStack(spacing: 10) {
                                            Image(systemName: "lightbulb.fill")
                                                .font(.system(size: 14))
                                                .foregroundColor(.leetCodeYellow)
                                            Text("Tips for earning more Leetcoins")
                                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                                .foregroundColor(.leetCodeTextSecondary)
                                        }
                                    }
                                    .padding(16)
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.subtleGray.opacity(0.5), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, 20)

                            // Notification Settings Section
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 10) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.leetCodeBlue.opacity(0.15))
                                            .frame(width: 28, height: 28)
                                        
                                        Image(systemName: "slider.horizontal.3")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.leetCodeBlue)
                                    }
                                    
                                    Text("PREFERENCES")
                                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                                        .foregroundColor(.leetCodeTextSecondary)
                                        .tracking(1.5)
                                }
                                .padding(.horizontal, 20)

                                VStack(spacing: 12) {
                                    // Frequency picker
                                    let availableFrequencies = subscriptionManager.isSubscribed ? ReminderFrequency.allCases : [.once]

                                    HStack {
                                        Text("Frequency")
                                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                                            .foregroundColor(.leetCodeTextPrimary)
                                        Spacer()
                                        Picker("Frequency", selection: Binding(
                                            get: { reminderFrequency },
                                            set: { val in
                                                reminderFrequency = val
                                                adjustTimesForFrequency()
                                                updateSettings()
                                            }
                                        )) {
                                            ForEach(availableFrequencies, id: \.self) { frequency in
                                                Text(frequency.rawValue).tag(frequency)
                                            }
                                        }
                                        .pickerStyle(.menu)
                                        .tint(.leetCodeGreen)
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

                                    if !subscriptionManager.isSubscribed {
                                        HStack(spacing: 8) {
                                            Image(systemName: "lock.fill")
                                                .font(.system(size: 12))
                                                .foregroundColor(.leetCodeYellow)
                                            Text("Premium unlocks multiple reminders per day")
                                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                                .foregroundColor(.leetCodeTextSecondary)
                                        }
                                        .padding(.horizontal, 12)
                                    }

                                    // Reminder times
                                    VStack(spacing: 8) {
                                        ForEach(0..<reminderFrequency.count, id: \.self) { index in
                                            HStack {
                                                Text(getReminderLabel(for: index))
                                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                                    .foregroundColor(.leetCodeTextPrimary)

                                                Spacer()

                                                DatePicker(
                                                    "",
                                                    selection: Binding(
                                                        get: { reminderTimes.indices.contains(index) ? reminderTimes[index] : Date() },
                                                        set: { val in
                                                            if reminderTimes.indices.contains(index) {
                                                                reminderTimes[index] = val
                                                                updateSettings()
                                                            }
                                                        }
                                                    ),
                                                    displayedComponents: .hourAndMinute
                                                )
                                                .labelsHidden()
                                                .tint(.leetCodeGreen)
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
                                        }
                                    }

                                    // Info text
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "info.circle.fill")
                                                .font(.system(size: 14))
                                                .foregroundColor(.leetCodeBlue)
                                            Text("Check-in & problem reminders: \(reminderFrequency.count) per day each")
                                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                                .foregroundColor(.leetCodeTextSecondary)
                                        }

                                        HStack(spacing: 8) {
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 14))
                                                .foregroundColor(.leetCodeYellow)
                                            Text("Weekly Luck: Every Monday at first reminder time")
                                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                                .foregroundColor(.leetCodeTextSecondary)
                                        }
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
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.subtleGray.opacity(0.5), lineWidth: 1)
                                        )
                                )
                            }
                            .padding(.horizontal, 20)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.bottom, 32)
                    .frame(maxWidth: contentMaxWidth)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
        .preferredColorScheme(.dark)
        .onAppear {
            let settings = dataManager.userData.notificationSettings
            reminderTimes = settings.dailyReminderTimes
            reminderFrequency = settings.reminderFrequency
            magicNotificationsEnabled = settings.magicNotificationsEnabled
            enforcePremiumLimits()
        }
        .onChange(of: subscriptionManager.isSubscribed) { _, _ in
            enforcePremiumLimits()
        }
        .sheet(isPresented: $showingSubscription) {
            SubscriptionView()
        }
    }

    private func updateSettings() {
        let anyActivityEnabled = dataManager.userData.activities.contains { $0.isEnabled }

        let newSettings = NotificationSettings(
            enableNotifications: anyActivityEnabled,
            dailyReminderTimes: reminderTimes,
            reminderFrequency: reminderFrequency,
            magicNotificationsEnabled: magicNotificationsEnabled
        )
        dataManager.updateNotificationSettings(newSettings)

        NotificationManager.shared.scheduleNotifications(userData: dataManager.userData)
    }

    private func enforcePremiumLimits() {
        guard !subscriptionManager.isSubscribed else { return }

        if reminderFrequency != .once {
            reminderFrequency = .once
            adjustTimesForFrequency()
        }

        if magicNotificationsEnabled {
            magicNotificationsEnabled = false
        }

        updateSettings()
    }

    private func adjustTimesForFrequency() {
        let count = reminderFrequency.count

        if reminderTimes.count < count {
            let lastTime = reminderTimes.last ?? Date()
            let calendar = Calendar.current
            while reminderTimes.count < count {
                let newTime = calendar.date(byAdding: .hour, value: 4, to: reminderTimes.last ?? lastTime) ?? lastTime
                reminderTimes.append(newTime)
            }
        } else if reminderTimes.count > count {
            reminderTimes = Array(reminderTimes.prefix(count))
        }
    }

    private func getReminderLabel(for index: Int) -> String {
        switch index {
        case 0: return "1st Reminder"
        case 1: return "2nd Reminder"
        case 2: return "3rd Reminder"
        default: return "\(index + 1)th Reminder"
        }
    }
}

struct ActivityToggleRow: View {
    let activity: Activity
    let isPremiumLocked: Bool
    let onPremiumTap: () -> Void
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        Toggle(isOn: binding) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(iconBackgroundColor)
                        .frame(width: 40, height: 40)

                    Image(systemName: iconName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(iconColor)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(activity.type.rawValue)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.leetCodeTextPrimary)

                    Text(activity.type.description)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.leetCodeTextSecondary)
                }

                Spacer()

                if isPremiumLocked {
                    Label("Premium", systemImage: "lock.fill")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.leetCodeYellow)
                }
            }
            .padding(.vertical, 10)
        }
        .toggleStyle(SwitchToggleStyle(tint: .leetCodeGreen))
        .disabled(isPremiumLocked)
        .opacity(isPremiumLocked ? 0.6 : 1)
        .contentShape(Rectangle())
        .onTapGesture {
            if isPremiumLocked {
                onPremiumTap()
            }
        }
        .padding(.horizontal, 16)
    }


    private var iconName: String {
        switch activity.type {
        case .dailyCheckIn:
            return "checkmark.circle.fill"
        case .dailyProblem:
            return "brain.head.profile.fill"
        case .weeklyLuck:
            return "star.fill"
        }
    }

    private var iconColor: Color {
        switch activity.type {
        case .dailyCheckIn:
            return .leetCodeGreen
        case .dailyProblem:
            return .leetCodeOrange
        case .weeklyLuck:
            return .leetCodeYellow
        }
    }

    private var iconBackgroundColor: Color {
        switch activity.type {
        case .dailyCheckIn:
            return Color.leetCodeGreen.opacity(0.15)
        case .dailyProblem:
            return Color.leetCodeOrange.opacity(0.15)
        case .weeklyLuck:
            return Color.leetCodeYellow.opacity(0.15)
        }
    }

    private var binding: Binding<Bool> {
        Binding(
            get: { activity.isEnabled },
            set: { _ in
                dataManager.toggleActivity(activity.type)

                let anyActivityEnabled = dataManager.userData.activities.contains { $0.isEnabled }
                let updatedSettings = NotificationSettings(
                    enableNotifications: anyActivityEnabled,
                    dailyReminderTimes: dataManager.userData.notificationSettings.dailyReminderTimes,
                    reminderFrequency: dataManager.userData.notificationSettings.reminderFrequency,
                    magicNotificationsEnabled: dataManager.userData.notificationSettings.magicNotificationsEnabled
                )
                dataManager.updateNotificationSettings(updatedSettings)

                NotificationManager.shared.scheduleNotifications(userData: dataManager.userData)
            }
        )
    }
}
