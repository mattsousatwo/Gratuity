//
//  UpdateTipPercentageView.swift
//  Gratuity
//
//  Created by Matthew Sousa on 3/17/22.
//

import SwiftUI

struct UpdateTipPercentageView: View {
    
    @EnvironmentObject var settings: Settings
    @State private var st: String = ""
    
    var body: some View {
        
        Form { 
            
            HStack {
                Text("Current Value")
                
                Text("0%")
                
            }.padding()
            
            TextField("Value", text: $st)
                .padding()
            
        }
        .navigationTitle(Text("Update Percentage"))
        .toolbar {
            
            ToolbarItem(placement: .navigationBarTrailing) {
                saveButton()
            }
        }
        
        
        
    }
    
}

extension UpdateTipPercentageView {
    
    /// Save button
    private func saveButton() -> some View {
        Button {
            
        } label: {
            Text("Save")
                .font(.headline)
                .foregroundColor(settings.colorScheme.color)
        }.buttonStyle( PlainButtonStyle() )
    }
}

struct UpdateTipPercentageView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateTipPercentageView()
    }
}
