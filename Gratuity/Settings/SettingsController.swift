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
    
    /// Primary Settings configuration array
    @Published var fetchedConfig: FetchedResults<Configuration>?
    /// Current configuration being used
    @Published var configuration: SettingConfiguration?
    
    /// Desired color scheme for application
    @Published var colorScheme: ColorElement = .ooze
    /// Last used tip percentage
    @Published var savedTipPercentage: TipPercentage = TipPercentage(0.15)
    
    @Published var tipOptions: [TipPercentage] = []
    
    @Published var personCount: Int = 1
    
    let persictenceController  = PersistenceController.shared
    let viewContext = PersistenceController.shared.container.viewContext
    
    
    /// Default configuration used if no values are stored
    private let defaultConfig = SettingConfiguration(scheme: .mar,
                                                     tip: TipPercentage(0.12),
                                                     options: [TipPercentage(0.05), TipPercentage(0.08),          TipPercentage(0.10), TipPercentage(0.12)],
                                                     personCount: 1)
}


extension SettingsController {
    
    /// Unwrap the saved configuration value ----- UNUSED ------
//    func unwrapConfiguration()  {
//        guard let configuration = fetchedConfig else { return  }
//        guard let savedSettings = configuration.first else { return }
//        print("Core Data Configuration ID \(savedSettings.uuid ?? "nil" )")
//        guard let savedConfig = savedSettings.settings?.convertToSettingConfiguration() else { return }
//        self.configuration = savedConfig
//    }
    
    
    /// Unwrap the saved configuration value
    func unwrap(config: FetchedResults<Configuration>?) -> SettingConfiguration? {
        guard let configuration = fetchedConfig else { return defaultConfig }
        guard let savedSettings = configuration.first else { return defaultConfig }
        print("Core Data Configuration ID \(savedSettings.uuid ?? "nil" )")
        guard let savedConfig = savedSettings.settings?.convertToSettingConfiguration() else { return defaultConfig }
        self.configuration = savedConfig
        return savedConfig
    }

    
    /// Load saved settings from fetched Configurations - if none are fetched, create new configuration
    func loadSettings(_ configuration: SettingConfiguration? = nil)  {
        if let configuration = configuration {
            self.configuration = configuration
            assignConfigurationValues(to: configuration)
            print("\nLoad saved configuration \n --- \n\(configuration) \n --- \n")
        } else {
            guard let fetchedConfiguration = configuration else {
                assignConfigurationValues(to: defaultConfig)
                print("\nLoad saved configuration \n --- \n\(defaultConfig) \n --- \n")
                return
            }
            assignConfigurationValues(to: fetchedConfiguration)
            print("\nLoad saved configuration \n --- \n\(fetchedConfiguration) \n --- \n")
        }
    }
    
    /// Use to update SettingsControllers values - colorScheme, savedTipPercentage, tipOptions, personCount
    func assignConfigurationValues(to config: SettingConfiguration) {
        colorScheme = config.colorScheme
        savedTipPercentage = config.lastUsedTip
        tipOptions = config.tipOptions
        personCount = config.personCount
    }
    
    
    /// Will create settings for user if settings have not been initalized
    func initalizeSettings(in context: NSManagedObjectContext) {
        if let fetchedConfig = fetchedConfig {
            print("The amount of settings saved/fetched == \(fetchedConfig.count)")
            switch fetchedConfig.count {
            case 0:
                createNewSetting(in: context)
            case 1:
                
                let savedConfig = unwrap(config: fetchedConfig)
                loadSettings(savedConfig)
    
            default:
                
                /// if more than 1 {
                ///     keep most recent
                ///     delete remainder
                /// }
                
                
                break
            }
        } else {
            createNewSetting(in: context)
        }
    }
    
    /// Create a new setting
    func createNewSetting(in context: NSManagedObjectContext,
                          _ configuration: SettingConfiguration? = nil) {
        
//        let context = result.container.viewContext
        let newElement = Configuration(context: context)
        newElement.uuid = UUID().uuidString
        
        if let configuration = configuration,
            let configurationJSON = configuration.convertToJSON() {
                loadSettings(configuration)
                newElement.settings = configurationJSON
        } else {
            
            guard let defaultConfigurationJSON = defaultConfig.convertToJSON() else { return }
            loadSettings(defaultConfig)
            newElement.settings = defaultConfigurationJSON
        }
        
        do {
            try context.save()
            print("Successful Save ~ \(newElement.settings ?? "Settings is nil")")
        } catch {
            print("Failed to save new setting")
        }
    }
    
    /// Update Setting color or tip
    func updateConfiguration(to color: ColorElement? = nil,
                             tip tipUpdate: TipPercentage? = nil,
                             tipOptions: [TipPercentage]? = nil,
                             personCount: Int? = nil,
                             in context: NSManagedObjectContext) {
        guard let config = configuration else { return }
        
        
        if let color = color {
            config.colorScheme = color
            print("Updating to - color: \(color.title)")
        }
        if let tipUpdate = tipUpdate {
            config.lastUsedTip = tipUpdate
            print("Updating to - tip: \(tipUpdate.asString)")
        }
        
        if let tipOptions = tipOptions {
            config.tipOptions = tipOptions
            print("Updating to - tipOptions \(tipOptions)")
        }
        
        if let personCount = personCount {
            config.personCount = personCount
            print("Updating to - personCount: \(personCount)")
        }
        
        configuration = config
        assignConfigurationValues(to: config)
        
        
        guard let fetchedSetting = fetchedConfig?.first else { return }
        guard let configurationJSON = config.convertToJSON() else { return }
        fetchedSetting.settings = configurationJSON
        
        
        do {
            try viewContext.save()
            print("Saving update of \(config.uuid) ")
        } catch {
            print("Failed to update Setting - UUID: \(config.uuid)")
        }
        
        
        print("Updated setting - \(config)")
    }
    
}

// Delete
extension SettingsController {
    
    /// Delete All elements
    func deleteAllSettingConfigurations(in context: NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Configuration")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
        } catch {
            print(error)
        }
        print("DeleteAll() ")
    }
    
    /// Delete a specific configuration
    func delete(configuration: Configuration, in context: NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Configuration")
        request.predicate = NSPredicate(format: "uuid == %@", configuration.uuid ?? "")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
        } catch {
            print(error)
        }

    }
    
    
    
}
