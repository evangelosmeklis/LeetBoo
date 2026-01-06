import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var enableNotifications: Bool
    @State private var reminderTime: Date
    @State private var reminderFrequency: ReminderFrequency

    init() {
        let settings = DataManager().userData.notificationSettings
        _enableNotifications = State(initialValue: settings.enableNotifications)
        _reminderTime = State(initialValue: settings.dailyReminderTime)
        _reminderFrequency = State(initialValue: settings.reminderFrequency)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enable Notifications For")) {
                    ForEach(dataManager.userData.activities) { activity in
                        ActivityToggleRow(activity: activity)
                    }
                }

                Section(header: Text("Notification Settings")) {
                    Toggle("Enable Notifications", isOn: $enableNotifications)
                        .onChange(of: enableNotifications) {
                            updateSettings()
                        }

                    if enableNotifications {
                        DatePicker(
                            "Reminder Time",
                            selection: $reminderTime,
                            displayedComponents: .hourAndMinute
                        )
                        .onChange(of: reminderTime) {
                            updateSettings()
                        }

                        Picker("Reminder Frequency", selection: $reminderFrequency) {
                            ForEach(ReminderFrequency.allCases, id: \.self) { frequency in
                                Text(frequency.rawValue).tag(frequency)
                            }
                        }
                        .onChange(of: reminderFrequency) {
                            updateSettings()
                        }

                        Text("Daily reminders: \(reminderFrequency.count) per day")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text("Weekly Luck: Every Monday at reminder time")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Section(header: Text("Data Management")) {
                    Button(action: resetAllData) {
                        HStack {
                            Text("Reset All Data")
                                .foregroundColor(.red)
                            Spacer()
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }

                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Max Coins/Month")
                        Spacer()
                        Text("370")
                            .foregroundColor(.secondary)
                    }

                    Text("Daily: 330 coins/month • Weekly Luck: 40 coins/month")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Settings")
        }
        .onAppear {
            let settings = dataManager.userData.notificationSettings
            enableNotifications = settings.enableNotifications
            reminderTime = settings.dailyReminderTime
            reminderFrequency = settings.reminderFrequency
        }
    }

    private func updateSettings() {
        let newSettings = NotificationSettings(
            enableNotifications: enableNotifications,
            dailyReminderTime: reminderTime,
            reminderFrequency: reminderFrequency
        )
        dataManager.updateNotificationSettings(newSettings)

        NotificationManager.shared.scheduleDailyNotifications(
            for: dataManager.userData.activities,
            settings: newSettings
        )
    }

    private func resetAllData() {
        dataManager.userData = UserData()
        dataManager.saveData()
        NotificationManager.shared.scheduleDailyNotifications(
            for: dataManager.userData.activities,
            settings: dataManager.userData.notificationSettings
        )
    }
}

struct ActivityToggleRow: View {
    let activity: Activity
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        Toggle(isOn: binding) {
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.type.rawValue)
                    .font(.headline)

                Text(activity.type.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
    }

    private var binding: Binding<Bool> {
        Binding(
            get: { activity.isEnabled },
            set: { _ in
                dataManager.toggleActivity(activity.type)
                NotificationManager.shared.scheduleDailyNotifications(
                    for: dataManager.userData.activities,
                    settings: dataManager.userData.notificationSettings
                )
            }
        )
    }
}
