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
    
    var body: some View {
        
        VStack {
            Form {
                
                ColorSchemePicker()
                    .environment(\.managedObjectContext,
                                  settings.viewContext)
                    
                TipPercentagePicker(selection: $selection,
                                    options: $settings.tipOptions)
            }
            .environmentObject(settings)
            
        }.navigationTitle(Text("Settings"))
        
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView( ).environmentObject(SettingsController())
    }
}
