//
//  UberApp.swift
//  Uber
//
//  Created by Mike Keller on 03.12.22.
//

import SwiftUI

@main
struct UberApp: App {
    @StateObject var viewModel: LocationSearchViewModel = LocationSearchViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(self.viewModel)
        }
    }
}
