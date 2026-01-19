import SwiftUI

struct CoinInfoView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

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
                        
                        Text("COIN INFO")
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
                            // Header Section
                            VStack(spacing: 8) {
                                Text("Learn how to")
                                    .font(.system(size: 26, weight: .semibold, design: .rounded))
                                    .foregroundColor(.leetCodeTextPrimary)
                                
                                Text("earn Leetcoins")
                                    .font(.system(size: 26, weight: .semibold, design: .rounded))
                                    .foregroundColor(.leetCodeTextPrimary)
                            }
                            .padding(.top, 8)
                            
                            VStack(alignment: .leading, spacing: 20) {
                                infoSection(
                                    title: "Check-in Missions",
                                    icon: "checkmark.circle.fill",
                                    color: .leetCodeGreen,
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
                                    icon: "doc.text.fill",
                                    color: .leetCodeBlue,
                                    items: [
                                        ("Contribute a Testcase", "100", "Submit a new testcase."),
                                        ("Contribute a Question", "1000", "Submit a new question."),
                                        ("File Content Issue", "100", "Report a content issue in the feedback repo."),
                                        ("Report Contest Violation", "100", "Report a contest violation.")
                                    ]
                                )
                                
                                infoSection(
                                    title: "Contest Missions",
                                    icon: "trophy.fill",
                                    color: .leetCodeYellow,
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
                                    icon: "person.circle.fill",
                                    color: .leetCodePurple,
                                    items: [
                                        ("Connect LinkedIn", "10", "One-time LinkedIn connection."),
                                        ("Connect Google", "10", "One-time Google connection."),
                                        ("Connect GitHub", "10", "One-time GitHub connection."),
                                        ("Connect Facebook", "10", "One-time Facebook connection.")
                                    ]
                                )
                            }
                            .padding(.horizontal, 20)

                            Spacer(minLength: 40)
                        }
                        .padding(.bottom, 32)
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
    
    private func infoSection(title: String, icon: String, color: Color, items: [(String, String, String)]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section header
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(color)
                }
                
                Text(title.uppercased())
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(.leetCodeTextSecondary)
                    .tracking(1.5)
            }
            
            // Items in a card
            VStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    HStack(alignment: .center, spacing: 14) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.0)
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(.leetCodeTextPrimary)
                            
                            Text(item.2)
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundColor(.leetCodeTextSecondary)
                                .lineLimit(2)
                        }
                        
                        Spacer()
                        
                        Text("+\(item.1)")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(color)
                            )
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    
                    if index < items.count - 1 {
                        Divider()
                            .background(Color.subtleGray.opacity(0.5))
                            .padding(.horizontal, 16)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.subtleGray.opacity(0.5), lineWidth: 1)
                    )
            )
        }
    }
}
