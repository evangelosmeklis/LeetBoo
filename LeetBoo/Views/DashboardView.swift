import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingEditCoins = false
    @State private var showingEditTarget = false
    @State private var showingAddCoins = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    currentCoinsCard
                    targetCoinsCard
                    progressCard
                    estimationCard
                    todayTasksCard
                }
                .padding()
            }
            .navigationTitle("LeetBoo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddCoins = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                }
            }
            .sheet(isPresented: $showingAddCoins) {
                AddCoinsSheet()
            }
        }
        .onAppear {
            dataManager.checkAndResetDailyActivities()
        }
    }

    private var currentCoinsCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Current Coins")
                .font(.headline)
                .foregroundColor(.secondary)

            HStack {
                Text("\(dataManager.userData.currentCoins)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.orange)

                Spacer()

                Button(action: { showingEditCoins = true }) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $showingEditCoins) {
                    EditCoinsView(title: "Edit Current Coins", coins: dataManager.userData.currentCoins) { newValue in
                        dataManager.updateCurrentCoins(newValue)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    private var targetCoinsCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Target Coins")
                .font(.headline)
                .foregroundColor(.secondary)

            HStack {
                Text("\(dataManager.userData.targetCoins)")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(.green)

                Spacer()

                Button(action: { showingEditTarget = true }) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $showingEditTarget) {
                    EditCoinsView(title: "Edit Target Coins", coins: dataManager.userData.targetCoins) { newValue in
                        dataManager.updateTargetCoins(newValue)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Progress")
                .font(.headline)
                .foregroundColor(.secondary)

            let progress = min(1.0, Double(dataManager.userData.currentCoins) / Double(max(1, dataManager.userData.targetCoins)))

            ProgressView(value: progress)
                .tint(.blue)

            HStack {
                Text("\(Int(progress * 100))% Complete")
                    .font(.subheadline)
                Spacer()
                Text("\(max(0, dataManager.userData.targetCoins - dataManager.userData.currentCoins)) coins to go")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    private var estimationCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Estimated Time to Target")
                .font(.headline)
                .foregroundColor(.secondary)

            if dataManager.userData.estimatedMonthlyCoins > 0 {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.purple)
                        Text("\(String(format: "%.1f", dataManager.userData.monthsToTarget)) months")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }

                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.purple)
                        Text("~\(dataManager.userData.daysToTarget) days")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }

                    Text("Based on \(dataManager.userData.estimatedMonthlyCoins) coins/month")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("Enable notifications in Settings to see estimation")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    private var todayTasksCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Tasks")
                .font(.headline)
                .foregroundColor(.secondary)

            if dataManager.userData.enabledActivities.isEmpty {
                Text("No notifications enabled. Go to Settings to enable Daily and Weekly Luck reminders.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                VStack(spacing: 10) {
                    ForEach(dataManager.userData.enabledActivities) { activity in
                        TodayTaskRow(activity: activity)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct TodayTaskRow: View {
    let activity: Activity
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.type.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text(activity.type.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if activity.completedToday {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Done")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            } else {
                Button(action: {
                    dataManager.markActivityDone(activity.type)
                }) {
                    Text("Mark Done")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(activity.completedToday ? Color.green.opacity(0.1) : Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct AddCoinsSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @State private var coinsToAdd: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Add Coins Manually")) {
                    TextField("Enter coins earned", text: $coinsToAdd)
                        .keyboardType(.numberPad)
                        .font(.title2)
                }

                Section {
                    HStack {
                        Text("Current Total:")
                        Spacer()
                        Text("\(dataManager.userData.currentCoins)")
                            .foregroundColor(.secondary)
                    }

                    if let coins = Int(coinsToAdd), coins > 0 {
                        HStack {
                            Text("New Total:")
                            Spacer()
                            Text("\(dataManager.userData.currentCoins + coins)")
                                .foregroundColor(.green)
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
            .navigationTitle("Add Coins")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        if let coins = Int(coinsToAdd), coins > 0 {
                            dataManager.addCoins(coins)
                            dismiss()
                        }
                    }
                    .fontWeight(.semibold)
                    .disabled(coinsToAdd.isEmpty || Int(coinsToAdd) ?? 0 <= 0)
                }
            }
        }
    }
}
