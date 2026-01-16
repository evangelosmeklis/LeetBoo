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
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Color.leetCodeOrange.opacity(0.15))
                        .frame(width: 28, height: 28)
                    
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.leetCodeOrange)
                }
                
                Text(title)
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.leetCodeTextSecondary)
                    .tracking(1.5)
            }
            
            VStack(spacing: 14) {
                ForEach(items, id: \.0) { item in
                    HStack(alignment: .top, spacing: 18) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.0)
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                                .foregroundColor(.leetCodeTextPrimary)
                            
                            Text(item.2)
                                .font(.system(size: 14, weight: .medium, design: .monospaced))
                                .foregroundColor(.leetCodeTextSecondary)
                                .tracking(0.3)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        Spacer()
                        
                        Text("+\(item.1)")
                            .font(.system(size: 15, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.leetCodeOrange, Color.leetCodeOrangeBright],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .shadow(color: Color.leetCodeOrange.opacity(0.3), radius: 6, x: 0, y: 3)
                    }
                    .padding(18)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.glassBackground)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
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
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.6), Color.white.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(color: Color.black.opacity(0.06), radius: 15, x: 0, y: 6)
                }
            }
        }
    }
}
