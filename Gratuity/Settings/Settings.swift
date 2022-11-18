//
//  Settings.swift
//  Gratuity
//
//  Created by Matthew Sousa on 3/14/22.
//

import Foundation
import SwiftUI
import CoreData

class Settings: ObservableObject {
    
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
        
    }
    
    /// Create a new setting
    func createNewSetting() {
        
        let context = result.container.viewContext
        
        let newElement = Default(context: context)
        
        
        newElement.uuid = UUID().uuidString
        
        newElement.settings = "New Settings"
        
        
        do {
            try context.save()
            print("Successful Save ~ \(newElement.settings ?? "Settings is nil")")
        } catch {
            print("Failed to save new setting")
        }
    }
    
    
    
    
}


class Setting: Codable {
    /// ColorScheme used in the application
    var colorScheme: ColorElement
    /// Last used tip by the user
    var lastUsedTip: TipPercentage
    /// UUID for the object
    var uuid: String
    
    /// Used to encode Setting into JSON
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init(scheme: ColorElement, tip: TipPercentage, uuid: String? = nil) {
        self.colorScheme = scheme
        self.lastUsedTip = tip
        if uuid == nil {
            self.uuid = UUID().uuidString
        } else {
            self.uuid = uuid ?? UUID().uuidString
        }
        encoder.outputFormatting = .prettyPrinted
    }
    
    /// Coding keys used to encode/decode Setting to JSON
    enum CodingKeys: String, CodingKey {
        case colorScheme = "colorScheme"
        case lastUsedTip = "lastUsedTip"
        case uuid = "uuid"
    }
    
    /// Decoder Protocol
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        colorScheme = try container.decode(ColorElement.self, forKey: .colorScheme)
        lastUsedTip = try container.decode(TipPercentage.self, forKey: .lastUsedTip)
        uuid = try container.decode(String.self, forKey: .uuid)
    }

    /// Encoder Protocol
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(colorScheme, forKey: .colorScheme)
        try container.encode(lastUsedTip, forKey: .lastUsedTip)
        try container.encode(uuid, forKey: .uuid)
    }
    
}

extension Setting {
    
    /// Update colorScheme or lastUsedTip
    func update(scheme: ColorElement? = nil, tip: TipPercentage? = nil) {
        if scheme != nil {
            guard let scheme = scheme else { return }
            colorScheme = scheme
        }
        if tip != nil {
            guard let tip = tip else { return }
            lastUsedTip = tip
        }
    }
    
    /// Convert Setting to JSON String in order to save to Coredata
    func convertToJSON() -> String? {
        guard let data = try? encoder.encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension String {
    
    /// Decode a String to Setting
    func convertToSetting() -> Setting? {
        let decoder = JSONDecoder()
        guard let data = self.data(using: .utf8) else { return nil }
        guard let setting = try? decoder.decode(Setting.self, from: data) else { return nil }
        print("Convert String to Setting Success")
        return setting
    }
}
