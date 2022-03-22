//
//  SettingsView.swift
//  Gratuity
//
//  Created by Matthew Sousa on 3/14/22.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var settings: Settings
    
    @State private var selection = TipPercentage(0.3)
//    @State private var options = [TipPercentage(0.3), TipPercentage(0.7),
//                                  TipPercentage(0.10), TipPercentage(0.4)]
    @Binding var options: [TipPercentage]
    
    
    var body: some View {
        
        VStack {
            Form {
                
                ColorSchemePicker()
                    
                TipPercentagePicker(selection: $selection,
                                    options: $options)
            }
            .environmentObject(settings)
            Text("Thank you for using Gratuity")
        }.navigationTitle(Text("Settings"))
        
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView( options: .constant([TipPercentage(0.3), TipPercentage(0.7),
                                          TipPercentage(0.10), TipPercentage(0.4)])).environmentObject(Settings())
    }
}
