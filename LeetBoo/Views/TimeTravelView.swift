import SwiftUI

struct TimeTravelView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    @State private var selectedDate = Date()
    @State private var selectedActivities: Set<ActivityType> = [.dailyCheckIn]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.pageBackground.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Date Picker Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select Date")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(.leetCodeTextSecondary)
                            .textCase(.uppercase)
                            .tracking(0.5)
                        
                        DatePicker("Date", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.cardBackground)
                                    .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                            )
                            .accentColor(.leetCodeOrange)
                    }
                    
                    // Activity Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select Activities to Log")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(.leetCodeTextSecondary)
                            .textCase(.uppercase)
                            .tracking(0.5)
                        
                        HStack(spacing: 12) {
                            activityButton(type: .dailyCheckIn, icon: "checkmark.circle.fill", color: .leetCodeGreen)
                            activityButton(type: .dailyProblem, icon: "brain.head.profile.fill", color: .leetCodeOrange)
                        }
                    }
                    
                    Spacer()
                    
                    // Action Button
                    Button(action: {
                        for activity in selectedActivities {
                            dataManager.logActivity(type: activity, date: selectedDate)
                        }
                        dismiss()
                    }) {
                        Text("Log Activity")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(selectedActivities.isEmpty ? Color.gray : Color.leetCodeOrange)
                            .cornerRadius(16)
                            .shadow(color: (selectedActivities.isEmpty ? Color.gray : Color.leetCodeOrange).opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .disabled(selectedActivities.isEmpty)
                }
                .padding(24)
            }
            .navigationTitle("Time Travel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.leetCodeTextSecondary)
                }
            }
        }
    }
    
    private func activityButton(type: ActivityType, icon: String, color: Color) -> some View {
        let isSelected = selectedActivities.contains(type)
        
        return Button(action: {
            if isSelected {
                selectedActivities.remove(type)
            } else {
                selectedActivities.insert(type)
            }
        }) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(isSelected ? .white : color)
                
                Text(type.rawValue)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(isSelected ? .white : .leetCodeTextPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? color : Color.cardBackground)
                    .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.green.opacity(0) : Color.white.opacity(0.5), lineWidth: 0)
            )
        }
    }
}
