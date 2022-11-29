//
//  SettingConfiguration.swift
//  Gratuity
//
//  Created by Matthew Sousa on 11/27/22.
//

import Foundation

/// Saved data packet containing the users configuation of the color scheme and last used tip percentage
class SettingConfiguation: Codable {
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

extension SettingConfiguation {
    
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
