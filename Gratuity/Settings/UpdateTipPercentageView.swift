//
//  UpdateTipPercentageView.swift
//  Gratuity
//
//  Created by Matthew Sousa on 3/17/22.
//

import SwiftUI

struct UpdateTipPercentageView: View {
    
    @EnvironmentObject var settings: SettingsController
    
    @Binding var options: [TipPercentage]
    
    @State private var newValue: Double = 0.00
    @State private var tipValue: TipPercentage = TipPercentage(0.00)
    
    var currentTipPercentage: TipPercentage
    
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .percent
        return formatter
    }
    
    var body: some View {
        
        Form { 
            
            HStack {
                Text("Current Value")
                
                Text(currentTipPercentage.asString)
                    .foregroundColor(settings.colorScheme.color)
                
            }.padding()
            
            TextField(currentTipPercentage.asString,
                      value: $newValue,
                      formatter: formatter, onCommit: {
                    // Format tip Value to percent
                    // ~ TipPercentage has a private method to do so
                currentTipPercentage.update(value: newValue)
                
                
            })
            .keyboardType(.decimalPad)
            .padding()
            
        }
        .navigationTitle(Text("Update Percentage"))
        .toolbar {
            
            ToolbarItem(placement: .navigationBarTrailing) {
                saveButton()
            }
        }
        .onAppear {
            tipValue = currentTipPercentage
//            newValue = currentTipPercentage.percentage
            
        }
        
        
        
    }
    
}

extension UpdateTipPercentageView {
    
    /// Save button
    private func saveButton() -> some View {
        Button {
            
            // extract number value from textfield input
            // compare tip percentage and new input value
            // if difference && acceptable percentage, save
            
            
            // Find matching Perrcent in percents array of SettingsConfig
            // update value
            // save
            
            updateTip(with: currentTipPercentage.id)
            
            print("Save button press - newValue: \(newValue )")
            
            
            
        } label: {
            Text("Save")
                .font(.headline)
                .foregroundColor(settings.colorScheme.color)
        }.buttonStyle( PlainButtonStyle() )
    }
    
    private func updateTip(with id: String) {
        for tip in settings.tipOptions {
            if tip.id == id {
                tip.update(value: newValue)
            }
        }
        settings.updateConfiguration(tipOptions: settings.tipOptions,
                                     in: settings.viewContext)
    }
    
    
    
    
    
    
}

struct UpdateTipPercentageView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateTipPercentageView(options: .constant([TipPercentage(0.02), TipPercentage(0.04), TipPercentage(0.08), TipPercentage(0.10)]), currentTipPercentage: TipPercentage(0.02))
    }
}
