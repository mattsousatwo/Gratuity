//
//  SettingConfiguration.swift
//  Gratuity
//
//  Created by Matthew Sousa on 11/27/22.
//

import Foundation

/// Saved data packet containing the users configuation of the color scheme and last used tip percentage
class SettingConfiguration: Codable, CustomDebugStringConvertible {
    /// ColorScheme used in the application
    var colorScheme: ColorElement
    /// Last used tip by the user
    var lastUsedTip: TipPercentage
    /// Saved Tips
    var tipOptions: [TipPercentage]
    /// The number of people
    var personCount: Int
    /// UUID for the object
    var uuid: String
    
    var debugDescription: String {
        return "\n ConfigurationID - \(uuid) \n Color: \(colorScheme.title) \n lastUsedTip: \(lastUsedTip) \n options: \(tipOptions) \n personCount - \(personCount)"
    }
    
    /// Used to encode Setting into JSON
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init(scheme: ColorElement,
         tip: TipPercentage,
         options: [TipPercentage],
         personCount: Int,
         uuid: String? = nil) {
        self.colorScheme = scheme
        self.lastUsedTip = tip
        self.tipOptions = options
        self.personCount = personCount
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
        case tipOptions = "tipOptions"
        case personCount = "personCount"
        case uuid = "uuid"
    }
    
    /// Decoder Protocol
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        colorScheme = try container.decode(ColorElement.self, forKey: .colorScheme)
        lastUsedTip = try container.decode(TipPercentage.self, forKey: .lastUsedTip)
        tipOptions = try container.decode([TipPercentage].self, forKey: .tipOptions)
        personCount = try container.decode(Int.self, forKey: .personCount)
        uuid = try container.decode(String.self, forKey: .uuid)
    }

    /// Encoder Protocol
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(colorScheme, forKey: .colorScheme)
        try container.encode(lastUsedTip, forKey: .lastUsedTip)
        try container.encode(tipOptions, forKey: .tipOptions)
        try container.encode(personCount, forKey: .personCount)
        try container.encode(uuid, forKey: .uuid)
    }
    
}

extension SettingConfiguration {
    
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
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    
    
}
