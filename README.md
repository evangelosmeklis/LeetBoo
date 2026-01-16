# LeetBoo - iOS Leetcode Coin Tracker

A comprehensive iOS app to help you track your Leetcode coins, stay consistent with your practice, and reach your coin goals through smart notifications and progress tracking.

**Disclaimer**: LeetBoo is not affiliated with, endorsed by, or connected to LeetCode. LeetCode is a registered trademark of LeetCode, Inc. This app is an independent tool created to help users track their LeetCode coin progress.

## Features

### Coin Tracking
- Track your current Leetcode coins
- Set and update target coin goals
- Visual progress indicators
- Real-time calculations of time to reach your target

### Activity Management
Choose which activities you want to pursue:
- **Daily**: 11 coins (10 for problem, 1 for check-in) = 330/month
- **Monthly Bonuses**: 105 coins (50 for monthly completion, 25 for 25-day streak, 30 for 30-day check-in) = 105/month
- **Weekly Luck**: 10 coins every Monday = 40/month
- **Contest Participation**: ~100 coins/month (5 Weekly + 5 Biweekly + 35 bonus)

### Smart Notifications
- Customizable reminder times
- Multiple daily reminders (1-3 times per day)
- Activity-specific notifications
- Special Monday reminders for Weekly Luck

### Progress Tracking
- Mark activities as completed
- Update coin count when tasks are done
- Monthly completion tracking
- Estimated time to reach your target based on selected activities

### Customizable Settings
- Enable/disable notifications
- Set reminder times
- Choose reminder frequency
- Reset monthly progress
- Reset all data

## Project Structure

```
LeetBoo/
├── Models/
│   ├── Activity.swift          # Activity types and definitions
│   └── UserData.swift          # User data model and settings
├── Views/
│   ├── DashboardView.swift     # Dashboard with coins and progress
│   ├── ActivitiesView.swift    # Activity selection and management
│   ├── SettingsView.swift      # App settings and preferences
│   ├── EditCoinsView.swift     # Edit current/target coins
│   ├── AddCoinsView.swift      # Quick add coins
│   └── CompleteActivityView.swift # Mark activities as completed
├── Services/
│   ├── DataManager.swift       # Data persistence and state management
│   └── NotificationManager.swift # Local notification handling
├── ContentView.swift           # Main tab view
└── LeetBooApp.swift           # Main app entry point
```

## Getting Started

### Prerequisites
- Xcode 14.0 or later
- iOS 16.0 or later
- macOS for development

### Running the App

1. **Open the Project**
   ```bash
   cd LeetBoo
   open LeetBoo.xcodeproj
   ```

2. **Add Files to Xcode (if not already added)**
   - In Xcode, right-click on the "LeetBoo" folder
   - Select "Add Files to LeetBoo..."
   - Add the Models, Views, and Services folders
   - Make sure "Copy items if needed" is unchecked (files are already in place)
   - Ensure "Create groups" is selected
   - Click "Add"

3. **Build and Run**
   - Select your target device or simulator
   - Press Cmd+R to build and run
   - Grant notification permissions when prompted

### First Time Setup

1. **Grant Notification Permissions**
   - When the app first launches, it will request notification permissions
   - Tap "Allow" to receive reminders

2. **Set Your Current Coins**
   - Tap the pencil icon next to "Current Coins"
   - Enter your current Leetcode coin count

3. **Set Your Target**
   - Tap the pencil icon next to "Target Coins"
   - Enter your desired coin goal

4. **Select Activities**
   - Go to the "Activities" tab
   - Toggle on the activities you want to pursue
   - The app will automatically calculate your estimated monthly coins

5. **Customize Notifications**
   - Go to the "Settings" tab
   - Set your preferred reminder time
   - Choose how many reminders you want per day

## Usage

### Tracking Daily Progress
1. Complete your Leetcode activities
2. Tap the "+" button on the Dashboard
3. Select the activity you completed or enter custom coins
4. The app will update your coin count and track your progress

### Quick Actions
- Use the Quick Actions on the Dashboard to mark activities as completed
- Each activity shows when it was last completed
- Suggested coin amounts are provided for quick entry

### Viewing Progress
- The Dashboard shows your progress percentage
- See estimated days/months to reach your target
- Track monthly completion counts for each activity

### Monthly Reset
- At the start of each month, go to Settings
- Tap "Reset Monthly Progress" to start fresh
- This resets completion counts but keeps your coin totals

## Tips for Success

1. **Enable All Activities**: To maximize coins (~575/month), enable all four activity types
2. **Consistent Check-ins**: Don't break your streaks - they contribute to Monthly Bonuses
3. **Weekend Contests**: Try to do both Weekly and Biweekly contests for the 35-coin bonus
4. **Monday Reminder**: Don't forget to claim your 10 Weekly Luck coins every Monday

## Coin Breakdown

- **Daily (330/month)**: 11 coins × 30 days
- **Monthly Bonuses (105/month)**: 50 + 25 + 30
- **Weekly Luck (40/month)**: 10 coins × 4 Mondays
- **Contests (~100/month)**: Variable based on participation

**Total Possible**: ~575 coins/month

## Troubleshooting

### Notifications Not Working
1. Go to iPhone Settings → LeetBoo → Notifications
2. Ensure "Allow Notifications" is enabled
3. Check notification settings in the app's Settings tab

### Files Not Showing in Xcode
1. Make sure all folders (Models, Views, Services) are added to the Xcode project
2. Check that all Swift files have the target "LeetBoo" selected in their File Inspector
3. Clean build folder (Cmd+Shift+K) and rebuild

### Data Not Persisting
- The app uses UserDefaults for storage
- Data persists between app launches
- Use "Reset All Data" in Settings to start fresh if needed

## Development

### Adding New Features
- Models go in the `Models/` directory
- UI components go in the `Views/` directory
- Business logic goes in the `Services/` directory

### Testing
- Use the iOS Simulator for quick testing
- Test on a real device for notification functionality
- Test different iOS versions for compatibility

## Future Enhancements

- Badge tracking for specific achievements
- Graphs and charts for progress visualization
- Weekly/monthly statistics
- Integration with Leetcode API (if available)
- iCloud sync for multiple devices
- Widgets for home screen
- Dark mode customization

## License

Personal project for Leetcode coin tracking and practice motivation.

---

Happy coding and good luck reaching your coin goals with LeetBoo! 🚀
