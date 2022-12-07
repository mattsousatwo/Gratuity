//
//  SettingsView.swift
//  Gratuity
//
//  Created by Matthew Sousa on 3/14/22.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var settings: SettingsController
    
    @State private var selection = TipPercentage(0.3)
//    @State private var options = [TipPercentage(0.3), TipPercentage(0.7),
//                                  TipPercentage(0.10), TipPercentage(0.4)]
    
    
    var body: some View {
        
        VStack {
            Form {
                
                ColorSchemePicker()
                    .environment(\.managedObjectContext,
                                  settings.persictenceController.container.viewContext)
                    
                TipPercentagePicker(selection: $selection,
                                    options: $settings.tipOptions)
            }
            .environmentObject(settings)
            Text("Thank you for using Gratuity")
        }.navigationTitle(Text("Settings"))
        
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView( ).environmentObject(SettingsController())
    }
}
