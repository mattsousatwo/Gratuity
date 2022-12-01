//
//  EXT+String.swift
//  Gratuity
//
//  Created by Matthew Sousa on 11/27/22.
//

import Foundation

extension String {
    
    /// Decode a String to Setting
    func convertToSettingConfiguration() -> SettingConfiguation? {
        let decoder = JSONDecoder()
        guard let data = self.data(using: .utf8) else { return nil }
        guard let setting = try? decoder.decode(SettingConfiguation.self, from: data) else { return nil }
        print("Convert String to Setting Success")
        return setting
    }
}
