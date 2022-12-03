//
//  SettingsController.swift
//  Gratuity
//
//  Created by Matthew Sousa on 3/14/22.
//

import Foundation
import SwiftUI
import CoreData

/// Class overseeing the users prefrences
class SettingsController: ObservableObject {
    
    /// Desired color scheme for application
    @Published var colorScheme: ColorElement = .ooze
    /// Last used tip percentage
    @Published var savedTipPercentage: TipPercentage = TipPercentage(0.15)
    
    @Published var tipOptions: [TipPercentage] = []
    
    @Published var personCount: Int = 1
    
//    private let result = PersistenceController(inMemory: true)
    
}


extension SettingsController {
    
    /// Unwrap saved settings from Default element
    func loadSettingConfiguration(_ defaultSettings: FetchedResults<Default>)  {
        guard let savedSettings = defaultSettings.first else { return }
        guard let configuration = savedSettings.settings?.convertToSettingConfiguration() else { return }
        
        print("\n ---- LoadSettingConfiguration() ---- \(configuration)\n")
        colorScheme = configuration.colorScheme
        savedTipPercentage = configuration.lastUsedTip
        tipOptions = configuration.tipOptions
        personCount = configuration.personCount
        /// Maybe need to set up saved tips as its own array, then load the values into the system
        /// currently there is only the last used percentage saved
        /// this was done on purpose yet might not be the best solution
        
        
    }
    
    
    /// Will create settings for user if settings have not been initalized
    func initalizeSettings(in context: NSManagedObjectContext,
                           _ defaults: FetchedResults<Default>) {
        print("The amount of settings saved/fetched == \(defaults.count)")
        switch defaults.count {
        case 0:
            createNewSetting(in: context,
                             SettingConfiguation(scheme: .intergalactic,
                                                 tip: TipPercentage(0.12),
                                                 options: [TipPercentage(0.05), TipPercentage(0.08),
                                                           TipPercentage(0.10), TipPercentage(0.12)],
                                                 personCount: 1) )
        case 1:
            loadSettingConfiguration(defaults)
        default:
            
            /// if more than 1 {
            ///     keep most recent
            ///     delete remainder
            /// }
            
            
            break
        }
    }
    
    /// Create a new setting
    func createNewSetting(in context: NSManagedObjectContext,
                          _ configuration: SettingConfiguation? = nil) {
        
//        let context = result.container.viewContext
        let newElement = Default(context: context)
        newElement.uuid = UUID().uuidString
        
        
        // MARK: Need to update @Published values upon creation
        // Need to set values if SettingConfig is not applied
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
    
    /// Update Setting color or tip
    func update(_ fetchedResults: FetchedResults<Default>,
                to color: ColorElement? = nil,
                tip tipUpdate: TipPercentage? = nil,
                tipOptions: [TipPercentage]? = nil,
                personCount: Int? = nil,
                in context: NSManagedObjectContext) {
        guard let savedSetting = fetchedResults.first else { return }
        guard let config = savedSetting.settings?.convertToSettingConfiguration() else { return }
        
        if let color = color {
            config.colorScheme = color
            print("Updating to \(color.title)")
        }
        if let tipUpdate = tipUpdate {
            config.lastUsedTip = tipUpdate
            print("Updating to \(tipUpdate.asString)")
        }
        
        guard let updatedConfiguration = config.convertToJSON() else { return }
        savedSetting.settings = updatedConfiguration
        
        do {
            try context.save()
            print("Saving update of \(savedSetting.uuid ?? "nil") ")
        } catch {
            print("Failed to update Setting - UUID: \(config.uuid)")
        }
        
        
        print("Updated setting - \(savedSetting.settings ?? "nil")")
    }
    
}


extension SettingsController {
    
    /// Delete All elements
    func deleteAllSettingConfigurations(in context: NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Default")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
        } catch {
            print(error)
        }
        print("DeleteAll() ")
    }
    
    /// Delete a specific configuration
    func delete(configuration: Default, in context: NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Default")
        request.predicate = NSPredicate(format: "uuid == %@", configuration.uuid ?? "")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
        } catch {
            print(error)
        }

    }
    
    
    
}
