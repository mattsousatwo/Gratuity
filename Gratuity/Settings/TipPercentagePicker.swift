//
//  TipPercentagePicker.swift
//  Gratuity
//
//  Created by Matthew Sousa on 3/17/22.
//

import SwiftUI

struct TipPercentagePicker: View {
    
    @EnvironmentObject var settings: Settings
    @Binding var selection: TipPercentage
    @Binding var options: [TipPercentage]
    
    var body: some View {
        
        Section("Tip Options") {
            
            ForEach(0..<options.count, id: \.self) { i in
                
                // Go to view to set percentage && Save
                NavigationLink {
                    UpdateTipPercentageView()
                        .environmentObject(settings)
                } label: {
                    
                    
                    HStack {
                        Text("\(i + 1).")
                            .font(.headline)
                            .padding(.trailing)
                        TipButton(percentage: options[i],
                                  size: .small,
                                  font: .headline)
                        //                                    .contentShape(RoundedRectangle(cornerRadius: 12) )
                        Spacer()
                    }
                }.tag(options[i])
                
                .environmentObject(settings)
            }
            .padding(8)
            
            
        } // Section
        
    }
    
}

struct TipPercentagePicker_Previews: PreviewProvider {
    static var previews: some View {
        TipPercentagePicker(selection: .constant(TipPercentage(0.2)),
                            options: .constant([]))
    }
}
