import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var reminderTimes: [Date]
    @State private var reminderFrequency: ReminderFrequency
    @State private var magicNotificationsEnabled: Bool

    init() {
        let settings = DataManager().userData.notificationSettings
        _reminderTimes = State(initialValue: settings.dailyReminderTimes)
        _reminderFrequency = State(initialValue: settings.reminderFrequency)
        _magicNotificationsEnabled = State(initialValue: settings.magicNotificationsEnabled)
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Clean light background
                Color.pageBackground
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Activities Section
                        VStack(alignment: .leading, spacing: 18) {
                            HStack(spacing: 10) {
                                ZStack {
                                    Circle()
                                        .fill(Color.leetCodeOrange.opacity(0.15))
                                        .frame(width: 28, height: 28)
                                    
                                    Image(systemName: "bell.fill")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.leetCodeOrange)
                                }
                                
                                Text("NOTIFICATIONS")
                                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                                    .foregroundColor(.leetCodeTextSecondary)
                                    .tracking(1.5)
                            }

                            VStack(spacing: 0) {
                                ForEach(dataManager.userData.activities) { activity in
                                    ActivityToggleRow(activity: activity)
                                    if activity.id != dataManager.userData.activities.last?.id {
                                        Divider()
                                            .background(Color.subtleGray.opacity(0.5))
                                            .padding(.horizontal, 20)
                                    }
                                }
                            }
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
                        }

                        if dataManager.userData.activities.contains(where: { $0.isEnabled }) {
                            // Magic Notifications Section
                            VStack(alignment: .leading, spacing: 16) {
                                Toggle(isOn: $magicNotificationsEnabled) {
                                    HStack(spacing: 14) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.leetCodePurple.opacity(0.15))
                                                .frame(width: 44, height: 44)
                                            
                                            Image(systemName: "wand.and.stars")
                                                .font(.system(size: 20, weight: .semibold))
                                                .foregroundColor(.leetCodePurple)
                                        }
                                        
                                        Text("Magic Notifications")
                                            .font(.system(size: 17, weight: .bold, design: .rounded))
                                            .foregroundColor(.leetCodeTextPrimary)
                                    }
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .leetCodeOrange))
                                .padding(20)
                                .onChange(of: magicNotificationsEnabled) { _, _ in
                                    updateSettings()
                                }
                                
                                if magicNotificationsEnabled {
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack(spacing: 12) {
                                            Image(systemName: "trophy.fill")
                                                .font(.system(size: 16))
                                                .foregroundColor(.leetCodeYellow)
                                            Text("Weekend contest reminders")
                                                .font(.system(size: 14, weight: .medium, design: .monospaced))
                                                .foregroundColor(.leetCodeTextSecondary)
                                                .tracking(0.3)
                                        }
                                        
                                        HStack(spacing: 12) {
                                            Image(systemName: "chart.line.uptrend.xyaxis")
                                                .font(.system(size: 16))
                                                .foregroundColor(.leetCodeOrange)
                                            Text("Monthly coins + goal progress")
                                                .font(.system(size: 14, weight: .medium, design: .monospaced))
                                                .foregroundColor(.leetCodeTextSecondary)
                                                .tracking(0.3)
                                        }
                                        
                                        HStack(spacing: 12) {
                                            Image(systemName: "lightbulb.fill")
                                                .font(.system(size: 16))
                                                .foregroundColor(.leetCodeYellow)
                                            Text("Tips for earning more Leetcoins")
                                                .font(.system(size: 14, weight: .medium, design: .monospaced))
                                                .foregroundColor(.leetCodeTextSecondary)
                                                .tracking(0.3)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 20)
                                }
                            }
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

                            // Notification Settings Section
                            VStack(alignment: .leading, spacing: 18) {
                                HStack(spacing: 10) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.leetCodeBlue.opacity(0.15))
                                            .frame(width: 28, height: 28)
                                        
                                        Image(systemName: "slider.horizontal.3")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.leetCodeBlue)
                                    }
                                    
                                    Text("PREFERENCES")
                                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                                        .foregroundColor(.leetCodeTextSecondary)
                                        .tracking(1.5)
                                }

                                VStack(spacing: 18) {
                                    // Frequency picker
                                    HStack {
                                        Text("Frequency")
                                            .font(.system(size: 16, weight: .semibold, design: .rounded))
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
                                            ForEach(ReminderFrequency.allCases, id: \.self) { frequency in
                                                Text(frequency.rawValue).tag(frequency)
                                            }
                                        }
                                        .pickerStyle(.menu)
                                        .tint(.leetCodeOrange)
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

                                    // Reminder times
                                    VStack(spacing: 12) {
                                        ForEach(0..<reminderFrequency.count, id: \.self) { index in
                                            HStack {
                                                Text(getReminderLabel(for: index))
                                                    .font(.system(size: 15, weight: .semibold, design: .monospaced))
                                                    .foregroundColor(.leetCodeTextPrimary)
                                                    .tracking(0.3)

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
                                                .tint(.leetCodeOrange)
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
                                        }
                                    }

                                    // Info text
                                    VStack(alignment: .leading, spacing: 10) {
                                        HStack(spacing: 10) {
                                            Image(systemName: "info.circle.fill")
                                                .font(.system(size: 16))
                                                .foregroundColor(.leetCodeBlue)
                                            Text("Check-in & problem reminders: \(reminderFrequency.count) per day each")
                                                .font(.system(size: 13, weight: .medium, design: .monospaced))
                                                .foregroundColor(.leetCodeTextSecondary)
                                                .tracking(0.3)
                                        }

                                        HStack(spacing: 10) {
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 16))
                                                .foregroundColor(.leetCodeYellow)
                                            Text("Weekly Luck: Every Monday at first reminder time")
                                                .font(.system(size: 13, weight: .medium, design: .monospaced))
                                                .foregroundColor(.leetCodeTextSecondary)
                                                .tracking(0.3)
                                        }
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
                                .padding(20)
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
                            }
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
        .preferredColorScheme(.light)
        .onAppear {
            let settings = dataManager.userData.notificationSettings
            reminderTimes = settings.dailyReminderTimes
            reminderFrequency = settings.reminderFrequency
            magicNotificationsEnabled = settings.magicNotificationsEnabled
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
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        Toggle(isOn: binding) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconBackgroundColor)
                        .frame(width: 44, height: 44)

                    Image(systemName: iconName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(iconColor)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(activity.type.rawValue)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.leetCodeTextPrimary)

                    Text(activity.type.description)
                        .font(.system(size: 13, weight: .medium, design: .monospaced))
                        .foregroundColor(.leetCodeTextSecondary)
                        .tracking(0.3)
                }
            }
            .padding(.vertical, 14)
        }
        .toggleStyle(SwitchToggleStyle(tint: .leetCodeOrange))
        .padding(.horizontal, 20)
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
            return Color.leetCodeGreen.opacity(0.12)
        case .dailyProblem:
            return Color.leetCodeOrange.opacity(0.12)
        case .weeklyLuck:
            return Color.leetCodeYellow.opacity(0.12)
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
