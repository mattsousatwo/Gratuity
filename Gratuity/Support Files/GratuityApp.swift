//
//  GratuityApp.swift
//  Gratuity
//
//  Created by Matthew Sousa on 3/7/22.
//

import SwiftUI

@main
struct GratuityApp: App {
//    let persistenceController = PersistenceController.shared
    let settings = SettingsController()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                CalculationView()
                    .environment(\.managedObjectContext, settings.viewContext)
            }
        }
    }
}
