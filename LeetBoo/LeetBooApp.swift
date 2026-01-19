//
//  LeetBooApp.swift
//  LeetBoo
//
//  Created by Evangelos Meklis on 6/1/26.
//

import SwiftUI
import UserNotifications

@main
struct LeetBooApp: App {
    @StateObject private var dataManager = DataManager()
    @StateObject private var subscriptionManager = SubscriptionManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase

    init() {
        NotificationManager.shared.requestAuthorization { _ in }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
                .environmentObject(subscriptionManager)
                .onAppear {
                    appDelegate.dataManager = dataManager
                }
                .onChange(of: scenePhase) { _, phase in
                    if phase == .active {
                        dataManager.checkAndResetDailyActivities()
                        dataManager.checkAndShowBannersOnAppOpen()
                        Task { await subscriptionManager.refreshSubscriptionStatus() }
                    }
                }
                .onChange(of: subscriptionManager.statusLoaded) { _, loaded in
                    if loaded {
                        dataManager.applySubscriptionStatus(isSubscribed: subscriptionManager.isSubscribed)
                        NotificationManager.shared.scheduleNotifications(userData: dataManager.userData)
                    }
                }
                .onChange(of: subscriptionManager.isSubscribed) { _, isSubscribed in
                    guard subscriptionManager.statusLoaded else { return }
                    dataManager.applySubscriptionStatus(isSubscribed: isSubscribed)
                    NotificationManager.shared.scheduleNotifications(userData: dataManager.userData)
                }
                .onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged)) { _ in
                    dataManager.checkAndResetDailyActivities()
                    dataManager.checkAndShowBannersOnAppOpen()
                }
        }
    }
}

// AppDelegate to handle notification taps
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    weak var dataManager: DataManager?

    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // Handle notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        handleNotification(notification)
        completionHandler([.banner, .sound])
    }

    // Handle notification tap
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
        handleNotification(response.notification)
        completionHandler()
    }

    private func handleNotification(_ notification: UNNotification) {
        let identifier = notification.request.identifier

        // Extract activity type from identifier
        if identifier.starts(with: "daily_checkin_reminder_") {
            dataManager?.triggerCheckInBanner(for: .dailyCheckIn)
        } else if identifier.starts(with: "daily_problem_reminder_") {
            dataManager?.triggerCheckInBanner(for: .dailyProblem)
        } else if identifier == "weekly_luck_reminder" {
            dataManager?.triggerCheckInBanner(for: .weeklyLuck)
        }
    }
}
