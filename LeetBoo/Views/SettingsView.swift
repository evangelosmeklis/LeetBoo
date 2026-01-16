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
                    VStack(spacing: 20) {
                        // Activities Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Notifications")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.leetCodeTextSecondary)
                                .textCase(.uppercase)
                                .tracking(0.5)

                            VStack(spacing: 0) {
                                ForEach(dataManager.userData.activities) { activity in
                                    ActivityToggleRow(activity: activity)
                                    if activity.id != dataManager.userData.activities.last?.id {
                                        Divider()
                                            .padding(.horizontal, 16)
                                    }
                                }
                            }
                            .background(Color.cardBackground)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
                        }

                        if dataManager.userData.activities.contains(where: { $0.isEnabled }) {
                            // Magic Notifications Section
                            VStack(alignment: .leading, spacing: 12) {
                                Toggle(isOn: $magicNotificationsEnabled) {
                                    HStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.purple.opacity(0.12))
                                                .frame(width: 40, height: 40)
                                            
                                            Image(systemName: "wand.and.stars")
                                                .font(.system(size: 18))
                                                .foregroundColor(.purple)
                                        }
                                        
                                        Text("Magic Notifications")
                                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                                            .foregroundColor(.leetCodeTextPrimary)
                                    }
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .leetCodeOrange))
                                .padding(16)
                                .onChange(of: magicNotificationsEnabled) { _, _ in
                                    updateSettings()
                                }
                                
                                if magicNotificationsEnabled {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "trophy.fill")
                                                .font(.system(size: 14))
                                                .foregroundColor(.leetCodeYellow)
                                            Text("Weekend contest reminders")
                                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                                .foregroundColor(.leetCodeTextSecondary)
                                        }
                                        
                                        HStack(spacing: 8) {
                                            Image(systemName: "chart.line.uptrend.xyaxis")
                                                .font(.system(size: 14))
                                                .foregroundColor(.leetCodeOrange)
                                            Text("Monthly coins + goal progress")
                                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                                .foregroundColor(.leetCodeTextSecondary)
                                        }
                                        
                                        HStack(spacing: 8) {
                                            Image(systemName: "lightbulb.fill")
                                                .font(.system(size: 14))
                                                .foregroundColor(.leetCodeYellow)
                                            Text("Tips for earning more Leetcoins")
                                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                                .foregroundColor(.leetCodeTextSecondary)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 16)
                                }
                            }
                            .background(Color.cardBackground)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)

                            // Notification Settings Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Preferences")
                                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                                    .foregroundColor(.leetCodeTextSecondary)
                                    .textCase(.uppercase)
                                    .tracking(0.5)

                                VStack(spacing: 16) {
                                    // Frequency picker
                                    HStack {
                                        Text("Frequency")
                                            .font(.system(size: 16, weight: .medium, design: .rounded))
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
                                    .padding(16)
                                    .background(Color.pageBackground)
                                    .cornerRadius(12)

                                    // Reminder times
                                    VStack(spacing: 12) {
                                        ForEach(0..<reminderFrequency.count, id: \.self) { index in
                                            HStack {
                                                Text(getReminderLabel(for: index))
                                                    .font(.system(size: 15, weight: .medium, design: .rounded))
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
                                                .tint(.leetCodeOrange)
                                            }
                                            .padding(16)
                                            .background(Color.pageBackground)
                                            .cornerRadius(12)
                                        }
                                    }

                                    // Info text
                                    VStack(alignment: .leading, spacing: 6) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "info.circle.fill")
                                                .font(.system(size: 14))
                                                .foregroundColor(.leetCodeTextSecondary)
                                            Text("Check-in & problem reminders: \(reminderFrequency.count) per day each")
                                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                                .foregroundColor(.leetCodeTextSecondary)
                                        }

                                        HStack(spacing: 8) {
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 14))
                                                .foregroundColor(.leetCodeYellow)
                                            Text("Weekly Luck: Every Monday at first reminder time")
                                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                                .foregroundColor(.leetCodeTextSecondary)
                                        }
                                    }
                                    .padding(16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.pageBackground)
                                    .cornerRadius(12)
                                }
                                .padding(16)
                                .background(Color.cardBackground)
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
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
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(iconBackgroundColor)
                        .frame(width: 40, height: 40)

                    Image(systemName: iconName)
                        .font(.system(size: 18))
                        .foregroundColor(iconColor)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(activity.type.rawValue)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.leetCodeTextPrimary)

                    Text(activity.type.description)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.leetCodeTextSecondary)
                }
            }
            .padding(.vertical, 12)
        }
        .toggleStyle(SwitchToggleStyle(tint: .leetCodeOrange))
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
