//
//  TipPercentage.swift
//  Gratuity
//
//  Created by Matthew Sousa on 3/8/22.
//

import Foundation

class TipPercentage {
    
    private var id: String = UUID().uuidString
    var percentage: Double = 0.00
    var asString: String = ""
    
    init(_ value: Double) {
        self.percentage = value
        updatePercentageString(value)
    }
    
    init(_ value: CustomPercentage = .customPercentage) {
        self.percentage = 0.00
        self.asString = "Custom"
    }
    
    enum CustomPercentage {
        case customPercentage
    }
    
    /// Number formatter for local Currency
    private var percentFormat: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .percent
        return formatter
    }

    func add(_ value: Double) {
        self.percentage = percentage + value
        updatePercentageString()
    }
    
    func subtract(_ value: Double) {
        self.percentage = percentage - value
        updatePercentageString()
    }
    
    private func updatePercentageString(_ value: Double? = nil) {
        if value == nil {
            guard let formattedValue = percentFormat.string(from: NSNumber(value: percentage)) else { return }
            asString = formattedValue
        } else {
            guard let value = value else { return }
            guard let formattedValue = percentFormat.string(from: NSNumber(value: value)) else { return }
            asString = formattedValue
        }
        
    }
}

extension TipPercentage: Comparable {
    static func < (lhs: TipPercentage, rhs: TipPercentage) -> Bool {
        lhs.percentage < rhs.percentage
    }
}

extension TipPercentage: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension TipPercentage: Equatable {
    static func == (lhs: TipPercentage, rhs: TipPercentage) -> Bool {
        return lhs.percentage == rhs.percentage
    }
}
