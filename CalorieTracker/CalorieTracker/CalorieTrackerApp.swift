//
//  CalorieTrackerApp.swift
//  CalorieTracker
//
//  Created by Josh Fuery on 6/4/24.
//

import SwiftUI
import SwiftData

@main
struct CalorieTrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Macro.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MacroView()
        }
        .modelContainer(sharedModelContainer)
    }
}
