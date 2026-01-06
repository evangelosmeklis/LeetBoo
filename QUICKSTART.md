# LeetBoo - Quick Start Guide

## Step 1: Open Xcode Project

```bash
cd /Users/evangelosmeklis/LeetBoo
open LeetBoo.xcodeproj
```

## Step 2: Add Source Files to Xcode

The source files are already in the correct folders, but you need to add them to the Xcode project.

### Add the Models Folder
1. In Xcode's Project Navigator (left sidebar), right-click on the "LeetBoo" folder (the blue one)
2. Select "Add Files to 'LeetBoo'..."
3. Navigate to and select the **Models** folder
4. **IMPORTANT**: Uncheck "Copy items if needed" (files are already in place)
5. Select "Create groups"
6. Make sure "LeetBoo" target is checked
7. Click "Add"

### Add the Views Folder
1. Right-click on the "LeetBoo" folder again
2. Select "Add Files to 'LeetBoo'..."
3. Navigate to and select the **Views** folder
4. **IMPORTANT**: Uncheck "Copy items if needed"
5. Select "Create groups"
6. Make sure "LeetBoo" target is checked
7. Click "Add"

### Add the Services Folder
1. Right-click on the "LeetBoo" folder again
2. Select "Add Files to 'LeetBoo'..."
3. Navigate to and select the **Services** folder
4. **IMPORTANT**: Uncheck "Copy items if needed"
5. Select "Create groups"
6. Make sure "LeetBoo" target is checked
7. Click "Add"

## Step 3: Verify File Structure

Your Project Navigator should look like this:

```
LeetBoo
├── LeetBoo
│   ├── LeetBooApp.swift
│   ├── ContentView.swift
│   ├── Models
│   │   ├── Activity.swift
│   │   └── UserData.swift
│   ├── Views
│   │   ├── DashboardView.swift
│   │   ├── ActivitiesView.swift
│   │   ├── SettingsView.swift
│   │   ├── EditCoinsView.swift
│   │   ├── AddCoinsView.swift
│   │   └── CompleteActivityView.swift
│   ├── Services
│   │   ├── DataManager.swift
│   │   └── NotificationManager.swift
│   └── Assets.xcassets
├── LeetBooTests
└── LeetBooUITests
```

## Step 4: Build and Run

1. Select a simulator or device from the scheme selector (top-left)
   - Recommended: iPhone 15 Pro simulator
2. Press **Cmd+R** or click the Play button
3. Wait for the build to complete
4. The app should launch in the simulator

## Step 5: Grant Permissions

When the app launches for the first time:
1. A notification permission dialog will appear
2. Tap **"Allow"** to enable reminders

## Step 6: Set Up Your Data

1. **Set Current Coins**
   - Tap the pencil icon next to "Current Coins"
   - Enter your current Leetcode coin count
   - Tap "Save"

2. **Set Target Coins**
   - Tap the pencil icon next to "Target Coins"
   - Enter your goal (e.g., 1000 coins)
   - Tap "Save"

3. **Enable Activities**
   - Tap the "Activities" tab at the bottom
   - Toggle on the activities you want to track
   - The app will calculate your estimated monthly coins

4. **Configure Notifications**
   - Tap the "Settings" tab
   - Set your preferred reminder time
   - Choose reminder frequency (1-3 times per day)

## You're All Set!

Your LeetBoo app is now ready to help you track your Leetcode coins and stay motivated!

### What's Next?

- **Complete Activities**: Tap the "+" button on the Dashboard to log completed activities
- **Track Progress**: Watch your progress bar fill up as you earn coins
- **Stay Consistent**: Let the notifications remind you to keep your streaks alive

---

## Troubleshooting

### Build Errors

**"Cannot find 'DataManager' in scope"**
- Make sure all three folders (Models, Views, Services) are added to the project
- Check that each file has the "LeetBoo" target checked in the File Inspector

**"Duplicate symbol" errors**
- Make sure you only added the folders once
- Clean the build folder: Product → Clean Build Folder (Cmd+Shift+K)

### Files Not Appearing

If the folders don't show up after adding:
1. Close and reopen Xcode
2. Try adding individual files instead of folders
3. Make sure you're adding them to the "LeetBoo" group (not the project root)

### App Crashes on Launch

- Check the debug console for error messages
- Make sure all files are included in the target
- Try running on a different simulator

---

Need more help? Check the full README.md for detailed documentation.
