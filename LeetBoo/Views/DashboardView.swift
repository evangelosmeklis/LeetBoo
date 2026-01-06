import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingEditCoins = false
    @State private var showingEditTarget = false
    @State private var showingAddCoins = false
    
    // Animation states
    @State private var appearAnimation = false

    var body: some View {
        NavigationView {
            ZStack {
                // Artistic Background
                Color.backgroundGradient
                    .ignoresSafeArea()
                
                // Subtle ambient glow
                Circle()
                    .fill(Color.leetCodeOrange.opacity(0.1))
                    .frame(width: 300, height: 300)
                    .blur(radius: 60)
                    .offset(x: -100, y: -200)
                
                Circle()
                    .fill(Color.leetCodeGreen.opacity(0.05))
                    .frame(width: 200, height: 200)
                    .blur(radius: 50)
                    .offset(x: 100, y: 300)

                ScrollView {
                    VStack(spacing: 24) {
                        currentCoinsCard
                            .offset(y: appearAnimation ? 0 : 20)
                            .opacity(appearAnimation ? 1 : 0)
                            .animation(.easeOut(duration: 0.5).delay(0.1), value: appearAnimation)
                        
                        targetCoinsCard
                            .offset(y: appearAnimation ? 0 : 20)
                            .opacity(appearAnimation ? 1 : 0)
                            .animation(.easeOut(duration: 0.5).delay(0.2), value: appearAnimation)
                        
                        progressCard
                            .offset(y: appearAnimation ? 0 : 20)
                            .opacity(appearAnimation ? 1 : 0)
                            .animation(.easeOut(duration: 0.5).delay(0.3), value: appearAnimation)
                        
                        estimationCard
                            .offset(y: appearAnimation ? 0 : 20)
                            .opacity(appearAnimation ? 1 : 0)
                            .animation(.easeOut(duration: 0.5).delay(0.4), value: appearAnimation)
                        
                        todayTasksCard
                            .offset(y: appearAnimation ? 0 : 20)
                            .opacity(appearAnimation ? 1 : 0)
                            .animation(.easeOut(duration: 0.5).delay(0.5), value: appearAnimation)
                    }
                    .padding()
                }
            }
            .navigationTitle("LeetBoo")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddCoins = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.leetCodeOrange)
                            .clipShape(Circle())
                            .shadow(color: .leetCodeOrange.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                }
            }
            .sheet(isPresented: $showingAddCoins) {
                AddCoinsSheet()
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            appearAnimation = true
            dataManager.checkAndResetDailyActivities()
        }
    }

    private var currentCoinsCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("CURRENT COINS")
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.bold)
                        .tracking(1.5)
                        .foregroundColor(.leetCodeTextSecondary)
                    
                    Spacer()
                    
                    Button(action: { showingEditCoins = true }) {
                        Image(systemName: "pencil")
                            .font(.subheadline)
                            .foregroundColor(.leetCodeTextSecondary)
                    }
                }

                HStack {
                    Text("\(dataManager.userData.currentCoins)")
                        .font(.system(size: 56, weight: .thin, design: .rounded))
                        .foregroundStyle(Color.leetCodeGradient)
                        .shadow(color: .leetCodeOrange.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Spacer()
                }
            }
            .padding(24)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(.linearGradient(colors: [.white.opacity(0.2), .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        .sheet(isPresented: $showingEditCoins) {
            EditCoinsView(title: "Edit Current Coins", coins: dataManager.userData.currentCoins) { newValue in
                dataManager.updateCurrentCoins(newValue)
            }
        }
    }

    private var targetCoinsCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("TARGET COINS")
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.bold)
                        .tracking(1.5)
                        .foregroundColor(.leetCodeTextSecondary)
                    
                    Spacer()
                    
                    Button(action: { showingEditTarget = true }) {
                        Image(systemName: "pencil")
                            .font(.subheadline)
                            .foregroundColor(.leetCodeTextSecondary)
                    }
                }

                HStack {
                    Text("\(dataManager.userData.targetCoins)")
                        .font(.system(size: 44, weight: .light, design: .rounded))
                        .foregroundColor(.leetCodeGreen)
                        .shadow(color: .leetCodeGreen.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Spacer()
                }
            }
            .padding(24)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(.linearGradient(colors: [.white.opacity(0.1), .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
        )
        .sheet(isPresented: $showingEditTarget) {
            EditCoinsView(title: "Edit Target Coins", coins: dataManager.userData.targetCoins) { newValue in
                dataManager.updateTargetCoins(newValue)
            }
        }
    }

    private var progressCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)

            VStack(alignment: .leading, spacing: 16) {
                Text("PROGRESS")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.bold)
                    .tracking(1.5)
                    .foregroundColor(.leetCodeTextSecondary)

                let progress = min(1.0, Double(dataManager.userData.currentCoins) / Double(max(1, dataManager.userData.targetCoins)))

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .frame(width: geometry.size.width, height: 12)
                            .opacity(0.1)
                            .foregroundColor(.white)
                        
                        Capsule()
                            .frame(width: min(CGFloat(progress) * geometry.size.width, geometry.size.width), height: 12)
                            .foregroundStyle(Color.leetCodeGradient)
                            .shadow(color: .leetCodeOrange.opacity(0.5), radius: 8, x: 0, y: 0)
                    }
                }
                .frame(height: 12)

                HStack {
                    Text("\(Int(progress * 100))%")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.leetCodeTextPrimary)
                    Text("Complete")
                        .font(.subheadline)
                        .foregroundColor(.leetCodeTextSecondary)
                    Spacer()
                    Text("\(max(0, dataManager.userData.targetCoins - dataManager.userData.currentCoins)) coins left")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.leetCodeTextSecondary)
                }
            }
            .padding(24)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(.linearGradient(colors: [.white.opacity(0.1), .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
        )
    }

    private var estimationCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)

            VStack(alignment: .leading, spacing: 16) {
                Text("ESTIMATED TIME")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.bold)
                    .tracking(1.5)
                    .foregroundColor(.leetCodeTextSecondary)

                if dataManager.userData.estimatedMonthlyCoins > 0 {
                    HStack(spacing: 24) {
                        VStack(alignment: .leading) {
                            Text("\(String(format: "%.1f", dataManager.userData.monthsToTarget))")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.leetCodeTextPrimary)
                            Text("Months")
                                .font(.caption)
                                .foregroundColor(.leetCodeTextSecondary)
                        }
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 1, height: 40)

                        VStack(alignment: .leading) {
                            Text("~\(dataManager.userData.daysToTarget)")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.leetCodeTextPrimary)
                            Text("Days")
                                .font(.caption)
                                .foregroundColor(.leetCodeTextSecondary)
                        }
                    }

                    Text("Based on \(dataManager.userData.estimatedMonthlyCoins) coins/mo")
                        .font(.caption)
                        .foregroundColor(.leetCodeTextSecondary)
                        .padding(.top, 4)
                } else {
                    Text("Enable notifications in Settings to see estimation")
                        .font(.subheadline)
                        .foregroundColor(.leetCodeTextSecondary)
                }
            }
            .padding(24)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(.linearGradient(colors: [.white.opacity(0.1), .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
        )
    }

    private var todayTasksCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)

            VStack(alignment: .leading, spacing: 16) {
                Text("TODAY'S TASKS")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.bold)
                    .tracking(1.5)
                    .foregroundColor(.leetCodeTextSecondary)

                if dataManager.userData.enabledActivities.isEmpty {
                    Text("No notifications enabled.")
                        .font(.subheadline)
                        .foregroundColor(.leetCodeTextSecondary)
                        .padding()
                } else {
                    VStack(spacing: 12) {
                        ForEach(dataManager.userData.enabledActivities) { activity in
                            TodayTaskRow(activity: activity)
                        }
                    }
                }
            }
            .padding(24)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(.linearGradient(colors: [.white.opacity(0.1), .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
        )
    }
}

struct TodayTaskRow: View {
    let activity: Activity
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.type.rawValue)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.leetCodeTextPrimary)

                Text(activity.type.description)
                    .font(.caption)
                    .foregroundColor(.leetCodeTextSecondary)
            }

            Spacer()

            if activity.completedToday {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.leetCodeGreen)
                    Text("Done")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.leetCodeGreen)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.leetCodeGreen.opacity(0.1))
                .cornerRadius(20)
            } else {
                Button(action: {
                    withAnimation {
                        dataManager.markActivityDone(activity.type)
                    }
                }) {
                    Text("Mark Done")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.leetCodeOrange)
                        .clipShape(Capsule())
                        .shadow(color: .leetCodeOrange.opacity(0.3), radius: 5, x: 0, y: 2)
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.2))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(activity.completedToday ? Color.leetCodeGreen.opacity(0.3) : Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}

struct AddCoinsSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @State private var coinsToAdd: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGradient.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("ADD COINS MANUALLY")
                            .font(.system(.caption, design: .rounded))
                            .fontWeight(.bold)
                            .tracking(1.5)
                            .foregroundColor(.leetCodeTextSecondary)
                        
                        TextField("Enter amount", text: $coinsToAdd)
                            .keyboardType(.numberPad)
                            .font(.system(size: 32, design: .rounded))
                            .padding()
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1)))
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(24)
                    
                    VStack(alignment: .leading, spacing: 16) {
                         HStack {
                             Text("Current Total")
                                 .foregroundColor(.leetCodeTextSecondary)
                             Spacer()
                             Text("\(dataManager.userData.currentCoins)")
                                 .font(.headline)
                                 .foregroundColor(.leetCodeTextPrimary)
                         }

                         if let coins = Int(coinsToAdd), coins > 0 {
                             Rectangle()
                                 .fill(Color.white.opacity(0.1))
                                 .frame(height: 1)
                                 
                             HStack {
                                 Text("New Total")
                                     .foregroundColor(.leetCodeTextSecondary)
                                 Spacer()
                                 Text("\(dataManager.userData.currentCoins + coins)")
                                     .font(.title3)
                                     .foregroundColor(.leetCodeGreen)
                                     .fontWeight(.bold)
                             }
                         }
                    }
                     .padding(24)
                     .background(.ultraThinMaterial)
                     .cornerRadius(24)
                     
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Add Coins")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        if let coins = Int(coinsToAdd), coins > 0 {
                            dataManager.addCoins(coins)
                            dismiss()
                        }
                    }
                    .fontWeight(.bold)
                    .foregroundColor(coinsToAdd.isEmpty || Int(coinsToAdd) ?? 0 <= 0 ? .gray : .leetCodeOrange)
                    .disabled(coinsToAdd.isEmpty || Int(coinsToAdd) ?? 0 <= 0)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
