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

            ProgressView()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.fill")
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(2)
        }
        .tint(.leetCodeOrange)
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
        .environmentObject(DataManager())
}
