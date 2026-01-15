import SwiftUI

struct CoinInfoView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Color.pageBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        infoSection(
                            title: "Daily Activities",
                            items: [
                                ("Daily Check-in", "1 coin", "Simply open the app every day."),
                                ("Daily Problem", "10 coins", "Solve the daily LeetCode problem.")
                            ]
                        )
                        
                        infoSection(
                            title: "Weekly Challenges",
                            items: [
                                ("Weekly Luck", "10 coins", "Claim this on the contest page every Monday."),
                                ("Weekly Contest", "5 coins", "Participate in the weekly contest."),
                                ("Bi-Weekly Contest", "5 coins", "Participate in the bi-weekly contest."),
                                ("Both Contests", "35 coins", "Bonus for doing both contests in a week!")
                            ]
                        )
                        
                        infoSection(
                            title: "Monthly Milestones",
                            items: [
                                ("30 Day Streak", "30 coins", "Check in every single day for a month."),
                                ("Monthly Badge", "25 coins", "Complete 25 daily challenges in a month."),
                                ("Perfect Month", "50 coins", "Complete all daily challenges in a month.")
                            ]
                        )

                        Spacer(minLength: 40)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("How to Earn Coins")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.leetCodeOrange)
                }
            }
        }
    }
    
    private func infoSection(title: String, items: [(String, String, String)]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(.leetCodeTextSecondary)
                .textCase(.uppercase)
                .tracking(0.5)
            
            VStack(spacing: 12) {
                ForEach(items, id: \.0) { item in
                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.0)
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.leetCodeTextPrimary)
                            
                            Text(item.2)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.leetCodeTextSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        Spacer()
                        
                        Text("+\(item.1)")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.leetCodeOrange)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.leetCodeOrange.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .padding(16)
                    .background(Color.cardBackground)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
                }
            }
        }
    }
}
