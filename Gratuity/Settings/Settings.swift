//
//  Settings.swift
//  Gratuity
//
//  Created by Matthew Sousa on 3/14/22.
//

import Foundation
import SwiftUI
import CoreData

/// Class overseeing the users prefrences
class Settings: ObservableObject {
    
    /// Desired color scheme for application
    @Published var colorScheme: ColorElement = .ooze
    let result = PersistenceController(inMemory: true)
    
}


extension Settings {
    
    /// Unwrap saved settings from Default element
    func unwrapSettings(_ defaultSettings: Default?) -> String? {
        guard let savedSettings = defaultSettings else { return nil }
        return savedSettings.settings
    }
    
    
    /// Will create settings for user if settings have not been initalized
    func initalizeSettings(_ defaults: [Default]) {
        switch defaults.count {
        case 0:
            createNewSetting()
        default:
            break
        }
    }
    
    /// Create a new setting
    func createNewSetting(_ configuration: SettingConfiguation? = nil) {
        
        let context = result.container.viewContext
        let newElement = Default(context: context)
        
        
        newElement.uuid = UUID().uuidString
        
        
        if let configuration = configuration,
            let configurationJSON = configuration.convertToJSON() {
                newElement.settings = configurationJSON
                print("Successful Conversion of Configuration - \(configurationJSON)")
        } else {
            newElement.settings = "New Settings"
        }
        
        do {
            try context.save()
            print("Successful Save ~ \(newElement.settings ?? "Settings is nil")")
        } catch {
            print("Failed to save new setting")
        }
    }
    
}


extension Settings {
    
    // Delete All elements
    func deleteAllSettingConfigurations() {
        let context = result.container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NAME")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
        } catch {
            print(error)
        }
    }
    
    
    
    
    
    
}
