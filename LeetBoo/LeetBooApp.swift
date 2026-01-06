//
//  LeetBooApp.swift
//  LeetBoo
//
//  Created by Evangelos Meklis on 6/1/26.
//

import SwiftUI

@main
struct LeetBooApp: App {
    @StateObject private var dataManager = DataManager()

    init() {
        NotificationManager.shared.requestAuthorization { _ in }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
        }
    }
}
