//
//  GratuityFactor.swift
//  Gratuity
//
//  Created by Matthew Sousa on 3/7/22.
//

import Foundation

struct GratuityFactor {
    
    /// The inital price of the bill
    let price: Double
    /// The percentage of the tip
    let tipPercentage: TipPercentage
    /// The price of the tip
    var tipTotal: Double = 0.0
    
    /// Total Price including the tip
    var totalPrice: Double {
        return tipTotal + price
    }
    
    init(price: Double, tip: TipPercentage) {
        self.price = price
        self.tipPercentage = tip
        
        tipTotal = price * tipPercentage.percentage
    }
    
    /// The tip value divided by a number of people 
    func tipPer(person: Int) -> Double {
        return tipTotal / Double(person)
    }
}
