//
//  CalculationViewModel.swift
//  Gratuity
//
//  Created by Matthew Sousa on 3/7/22.
//

import Foundation
import SwiftUI

class CalculationViewModel: ObservableObject {
    
    private var digitLimit = 9
    @Published private var digitLimitHasBeenReached: Bool = false
    
    /// The numerical value of the inital price
    @Published var priceValue: Double = 0
    
//    {
//        didSet {
//            let count = priceValue.description.count
//            if count > digitLimit {
////                priceValue = oldValue
//                guard let updatedValue = Double(priceValue.description.prefix(digitLimit)) else { return }
//                priceValue = updatedValue
//                self.digitLimitHasBeenReached = true
//            } else {
//                self.digitLimitHasBeenReached = false
//            }
//
//        }
//    }
    
    /// The string value of the price -- May be used in a textfield --- UNUSED
    @Published var priceString: String = ""
    
    /// The numerical tip value for each person on the bill
    @Published var tipValuePerPerson: Double = 0
    /// The string tip value for each person on the bill
    @Published var tipValuePerPersonString: String = ""
    /// The tip percentage in use
    @Published var tipPercentage = TipPercentage(0.15)
    
    /// Total of the tip pooled together String
    @Published var tipTotalString: String = ""
    /// Total of the tip pooled together Value
    @Published var tipTotalValue: Double = 0.00
    
    /// The numerical total price 
    @Published var totalPriceValue: Double = 0.00
    /// The total price string value 
    @Published var totalPriceString: String = "total String"
    
    /// Number of people on the bill
    @Published var numberOfPeople: Int = 1
    
    
    /// Grid column width values for the tip percentage buttons - each element describes the width for the coresponding column
    let percentageButtonColumnWidth = [GridItem(.flexible()),
                                       GridItem(.flexible()) ]
    
    /// The percentages used in the tip percentage buttons
    @Published var percentages = [TipPercentage(0.12),
                                  TipPercentage(0.15),
                                  TipPercentage(0.20),
                                  TipPercentage()]

    /// Number formatter for local Currency
    var localeCurrencyFormat: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter
    }
    
    /// Convert Double to locale amount currency
    func convertToCurrency(_ amount: Double) -> String {
        let roundedValue = round(amount * 100) / 100
        if let formattedTipAmount = localeCurrencyFormat.string(from: roundedValue as NSNumber) {
            return formattedTipAmount
        }
        return ""
    }
    
    /// Update the price values & strings - Tip, Total, TipTotal
    func updateTotal() {
        
        let priceTotal = GratuityFactor(price: priceValue,
                                        tip: tipPercentage)
        
        tipValuePerPerson = priceTotal.tipPer(person: numberOfPeople)
        tipValuePerPersonString = convertToCurrency(tipValuePerPerson)
        
        totalPriceValue = priceTotal.totalPrice
        totalPriceString = convertToCurrency(priceTotal.totalPrice)
    
        tipTotalValue = tipValuePerPerson * Double(numberOfPeople)
        tipTotalString = convertToCurrency(tipTotalValue )
        
    }
    
    /// Subtract the value of numberOfPeople if more than 1
    func subtractNumberOfPeople(_ value: Int = 1) {
        if numberOfPeople > 1 {
            numberOfPeople -= value
            updateTotal()
        }
    }
    
    /// Add one to the value of numberOfPeople if less than 50
    func addOntoNumberOfPeople(_ value: Int = 1) {
        if numberOfPeople < 50 {
            numberOfPeople += value
            updateTotal()
        }
    }
    
    /// Subtract the tip percentage by one if more than 1%
    func subtractTipPercentage(_ value: Double = 0.01) {
        if tipPercentage >= TipPercentage(0.02) {
            tipPercentage.subtract(value)
            updateTotal()
        }
        print(tipPercentage.asString)
    }
    
    /// Add one to the tip percentage if less than 99%
    func addOntoTipPercentage(_ value: Double = 0.01) {
        if tipPercentage < TipPercentage(0.99) {
            tipPercentage.add(value)
            updateTotal()
        }
        print(tipPercentage.asString)
    }
    
}


class PriceBindingDouble: ObservableObject {
    @Published var value: Double = 0 {
        didSet {
            if value.description.count > digitLimit &&
                oldValue.description.count <= digitLimit {
                value = oldValue
            }
        }
    }
    
    private var digitLimit = 9
}
