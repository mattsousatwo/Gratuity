//
//  ColorElement.swift
//  Gratuity
//
//  Created by Matthew Sousa on 3/14/22.
//

import SwiftUI

enum ColorElement: Int, CaseIterable, Codable, Equatable {
    
    case papaya, mar, ooze, summer, blazing, intergalactic, nuetral
    
    /// Color associated to value
    var color: Color {
        switch self {
        case .papaya:
            return .orange
        case .mar:
            return .blue
        case .ooze:
            return .green
        case .summer:
            return .yellow
        case .blazing:
            return .red
        case .intergalactic:
            return .purple
        case .nuetral:
            return .gray
        }
    }
    
    /// Name of color element to be displayed in picker
    var title: String {
        switch self {
        case .papaya:
            return "Papaya"
        case .mar:
            return "Mar"
        case .ooze:
            return "Ooze"
        case .summer:
            return "Summer"
        case .blazing:
            return "Blazing"
        case .intergalactic:
            return "Intergalactic"
        case .nuetral:
            return "Nuetral"
        }
    }
    
}
