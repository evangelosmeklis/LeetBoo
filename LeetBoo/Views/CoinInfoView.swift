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
                            title: "Check-in Missions",
                            items: [
                                ("Daily Check-in", "1", "Log in each day."),
                                ("30 Day Check-in Streak", "30", "Check in 30 days straight."),
                                ("Complete Daily Challenge", "10", "Finish the daily challenge."),
                                ("Weekly Premium Challenges", "35", "Complete weekly premium challenges."),
                                ("Lucky Monday", "10", "Claim on the contest page every Monday.")
                            ]
                        )
                        
                        infoSection(
                            title: "Contribution Missions",
                            items: [
                                ("Contribute a Testcase", "100", "Submit a new testcase."),
                                ("Contribute a Question", "1000", "Submit a new question."),
                                ("File Content Issue", "100", "Report a content issue in the feedback repo."),
                                ("Report Contest Violation", "100", "Report a contest violation.")
                            ]
                        )
                        
                        infoSection(
                            title: "Contest Missions",
                            items: [
                                ("Join a Contest", "5", "Join weekly or biweekly contests."),
                                ("Join Weekly + Biweekly", "35", "Join both contests in the same week."),
                                ("1st Place Contest", "5000", "Finish first in a contest."),
                                ("2nd Place Contest", "2500", "Finish second in a contest."),
                                ("3rd Place Contest", "1000", "Finish third in a contest."),
                                ("Top 50 Contest", "300", "Place in the top 50."),
                                ("Top 100 Contest", "100", "Place in the top 100."),
                                ("Top 200 Contest", "50", "Place in the top 200."),
                                ("First Contest Submission", "200", "Submit to your first contest.")
                            ]
                        )
                        
                        infoSection(
                            title: "Profile Missions",
                            items: [
                                ("Connect LinkedIn", "10", "One-time LinkedIn connection."),
                                ("Connect Google", "10", "One-time Google connection."),
                                ("Connect GitHub", "10", "One-time GitHub connection."),
                                ("Connect Facebook", "10", "One-time Facebook connection.")
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
