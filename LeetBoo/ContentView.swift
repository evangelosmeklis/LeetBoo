//
//  ContentView.swift
//  LeetBoo
//
//  Created by Evangelos Meklis on 6/1/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(1)
        }
        .accentColor(.leetCodeOrange)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .environmentObject(DataManager())
}
