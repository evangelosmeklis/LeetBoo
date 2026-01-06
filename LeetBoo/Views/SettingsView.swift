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
            ZStack {
                Color.backgroundGradient.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Activities Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("NOTIFICATIONS")
                                .font(.system(.caption, design: .rounded))
                                .fontWeight(.bold)
                                .tracking(1.5)
                                .foregroundColor(.leetCodeTextSecondary)
                                .padding(.horizontal, 4)
                            
                            VStack(spacing: 1) {
                                ForEach(dataManager.userData.activities) { activity in
                                    ActivityToggleRow(activity: activity)
                                    if activity.id != dataManager.userData.activities.last?.id {
                                        Divider().background(Color.white.opacity(0.1))
                                    }
                                }
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                        }
                        
                        // Notification Settings Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("PREFERENCES")
                                .font(.system(.caption, design: .rounded))
                                .fontWeight(.bold)
                                .tracking(1.5)
                                .foregroundColor(.leetCodeTextSecondary)
                                .padding(.horizontal, 4)
                            
                            VStack(spacing: 20) {
                                Toggle("Enable Notifications", isOn: Binding(
                                    get: { enableNotifications },
                                    set: { val in
                                        enableNotifications = val
                                        updateSettings()
                                    }
                                ))
                                .foregroundColor(.leetCodeTextPrimary)
                                .tint(.leetCodeOrange)
                                
                                if enableNotifications {
                                    Divider().background(Color.white.opacity(0.1))
                                    
                                    DatePicker(
                                        "Reminder Time",
                                        selection: Binding(
                                            get: { reminderTime },
                                            set: { val in
                                                reminderTime = val
                                                updateSettings()
                                            }
                                        ),
                                        displayedComponents: .hourAndMinute
                                    )
                                    .foregroundColor(.leetCodeTextPrimary)
                                    .colorScheme(.dark)
                                    
                                    Divider().background(Color.white.opacity(0.1))
                                    
                                    HStack {
                                        Text("Frequency")
                                            .foregroundColor(.leetCodeTextPrimary)
                                        Spacer()
                                        Picker("Frequency", selection: Binding(
                                            get: { reminderFrequency },
                                            set: { val in
                                                reminderFrequency = val
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

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Daily reminders: \(reminderFrequency.count) per day")
                                            .font(.caption)
                                            .foregroundColor(.leetCodeTextSecondary)
                                        
                                        Text("Weekly Luck: Every Monday at reminder time")
                                            .font(.caption)
                                            .foregroundColor(.leetCodeTextSecondary)
                                    }
                                }
                            }
                            .padding(24)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                        }
                        
                        // Data Management Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("DATA")
                                .font(.system(.caption, design: .rounded))
                                .fontWeight(.bold)
                                .tracking(1.5)
                                .foregroundColor(.leetCodeTextSecondary)
                                .padding(.horizontal, 4)
                            
                            Button(action: resetAllData) {
                                HStack {
                                    Text("Reset All Data")
                                        .foregroundColor(.leetCodeRed)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Image(systemName: "trash")
                                        .foregroundColor(.leetCodeRed)
                                }
                                .padding(24)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                            }
                        }
                        
                        // About Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("ABOUT")
                                .font(.system(.caption, design: .rounded))
                                .fontWeight(.bold)
                                .tracking(1.5)
                                .foregroundColor(.leetCodeTextSecondary)
                                .padding(.horizontal, 4)
                            
                            VStack(spacing: 16) {
                                HStack {
                                    Text("Version")
                                        .foregroundColor(.leetCodeTextPrimary)
                                    Spacer()
                                    Text("1.0.0")
                                        .foregroundColor(.leetCodeTextSecondary)
                                }
                                
                                Divider().background(Color.white.opacity(0.1))
                                
                                HStack {
                                    Text("Max Coins/Month")
                                        .foregroundColor(.leetCodeTextPrimary)
                                    Spacer()
                                    Text("370")
                                        .foregroundColor(.leetCodeTextSecondary)
                                }
                                
                                Text("Daily: 330 coins/month • Weekly Luck: 40 coins/month")
                                    .font(.caption)
                                    .foregroundColor(.leetCodeTextSecondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(24)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                        }
                    }
                    .padding()
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
        .preferredColorScheme(.dark)
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
        // Refresh local state if needed
        let settings = dataManager.userData.notificationSettings
        enableNotifications = settings.enableNotifications
        reminderTime = settings.dailyReminderTime
    }
}

struct ActivityToggleRow: View {
    let activity: Activity
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        Toggle(isOn: binding) {
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.type.rawValue)
                    .font(.body)
                    .foregroundColor(.leetCodeTextPrimary)

                Text(activity.type.description)
                    .font(.caption)
                    .foregroundColor(.leetCodeTextSecondary)
            }
            .padding(.vertical, 8)
        }
        .tint(.leetCodeOrange)
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
