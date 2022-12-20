//
//  TipPercentage.swift
//  Gratuity
//
//  Created by Matthew Sousa on 3/8/22.
//

import Foundation

class TipPercentage: Codable, CustomDebugStringConvertible {
    
    var id: String
    var percentage: Double = 0.00
    var asString: String = ""
    
    var debugDescription: String {
        return asString
    }
    
    init(_ value: Double) {
        self.id = UUID().uuidString
        self.percentage = value
        updatePercentageString(value)
        
    }
    
    /// Init to define a CustomPercentage ~ Used for Testing ~
    init(_ value: CustomPercentage = .customPercentage) {
        self.id = UUID().uuidString
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

    /// Update the percentage by increasing the value
    func add(_ value: Double) {
        self.percentage = percentage + value
        updatePercentageString()
    }
    
    /// Update the percentage by decrementing the value
    func subtract(_ value: Double) {
        self.percentage = percentage - value
        updatePercentageString()
    }
    
    /// Update the string used to describe the percentage by formatting the numerical percentage value into a percent and then converting it as a String to the asString parameter
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
    
    /// Update the TipPercentage value
    func update(value: Double) {
        percentage = value
        updatePercentageString(value)
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
