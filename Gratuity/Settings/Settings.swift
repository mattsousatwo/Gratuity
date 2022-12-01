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
    func loadSettingConfiguration(_ defaultSettings: FetchedResults<Default>)  {
        print("UnwrapSettings - (\(defaultSettings.first?.settings ?? "NIL 1"))")
        
        guard let savedSettings = defaultSettings.first else { return }
        guard let configuration = savedSettings.settings?.convertToSettingConfiguration() else { return }
        
        colorScheme = configuration.colorScheme
        /// Maybe need to set up saved tips as its own array, then load the values into the system
        /// currently there is only the last used percentage saved
        /// this was done on purpose yet might not be the best solution
        
        
        print("UnwrapSettings - (\(savedSettings.settings ?? "NIL 2"))")
        
    }
    
    
    /// Will create settings for user if settings have not been initalized
    func initalizeSettings(in context: NSManagedObjectContext,
                           _ defaults: FetchedResults<Default>) {
        print("The amount of settings saved/fetched == \(defaults.count)")
        switch defaults.count {
        case 0:
            createNewSetting(in: context,
                             SettingConfiguation(scheme: .intergalactic,
                             tip: TipPercentage(0.12)) )
        case 1:
            loadSettingConfiguration(defaults)
        default:
            break
        }
    }
    
    /// Create a new setting
    func createNewSetting(in context: NSManagedObjectContext,
                          _ configuration: SettingConfiguation? = nil) {
        
//        let context = result.container.viewContext
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
