import SwiftUI

struct TimeTravelView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @State private var selectedDate = Date()
    @State private var selectedActivities: Set<ActivityType> = [.dailyCheckIn]

    private var contentMaxWidth: CGFloat? {
        horizontalSizeClass == .regular ? 640 : nil
    }
    
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
                        
                        Text("TIME TRAVEL")
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
                    .frame(maxWidth: contentMaxWidth)
                    .frame(maxWidth: .infinity)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            // Header
                            VStack(spacing: 8) {
                                Text("Log a past")
                                    .font(.system(size: 26, weight: .semibold, design: .rounded))
                                    .foregroundColor(.leetCodeTextPrimary)
                                
                                Text("activity")
                                    .font(.system(size: 26, weight: .semibold, design: .rounded))
                                    .foregroundColor(.leetCodeTextPrimary)
                            }
                            .padding(.top, 8)
                            
                            // Date Picker Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("SELECT DATE")
                                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                                    .foregroundColor(.leetCodeTextSecondary)
                                    .tracking(1.5)
                                
                                DatePicker("Date", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.subtleGray.opacity(0.5), lineWidth: 1)
                                            )
                                    )
                                    .tint(.leetCodeGreen)
                            }
                            .padding(.horizontal, 20)
                            
                            // Activity Selection
                            VStack(alignment: .leading, spacing: 12) {
                                Text("SELECT ACTIVITIES")
                                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                                    .foregroundColor(.leetCodeTextSecondary)
                                    .tracking(1.5)
                                
                                HStack(spacing: 12) {
                                    activityButton(type: .dailyCheckIn, icon: "checkmark.circle.fill", color: .leetCodeGreen)
                                    activityButton(type: .dailyProblem, icon: "brain.head.profile.fill", color: .leetCodeOrange)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer(minLength: 20)
                            
                            // Action Button
                            Button(action: {
                                for activity in selectedActivities {
                                    dataManager.logActivity(type: activity, date: selectedDate, shouldAddCoins: true)
                                }
                                dismiss()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "clock.arrow.circlepath")
                                        .font(.system(size: 16, weight: .semibold))
                                    
                                    Text("Log Activity")
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                }
                                .foregroundColor(selectedActivities.isEmpty ? .leetCodeTextSecondary : .black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(selectedActivities.isEmpty ? Color.subtleGray.opacity(0.3) : Color.leetCodeGreen)
                                )
                            }
                            .disabled(selectedActivities.isEmpty)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 32)
                        }
                        .padding(.top, 8)
                        .frame(maxWidth: contentMaxWidth)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
        .preferredColorScheme(.dark)
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
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(isSelected ? color : color.opacity(0.15))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(isSelected ? .black : color)
                }
                
                Text(type.rawValue)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(isSelected ? .leetCodeTextPrimary : .leetCodeTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? color : Color.subtleGray.opacity(0.5), lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
