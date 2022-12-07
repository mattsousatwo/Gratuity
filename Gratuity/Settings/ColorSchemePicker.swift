//
//  ColorSchemePicker.swift
//  Gratuity
//
//  Created by Matthew Sousa on 3/14/22.
//

import SwiftUI

struct ColorSchemePicker: View {
    
    
    @EnvironmentObject var settings: SettingsController
    
    var body: some View {
        
        Section("Color Scheme") {
            
            Picker(selection: $settings.colorScheme) {
                ForEach(ColorElement.allCases, id: \.self) { color in
                    row(for: color)
                }
            } label: {
                Text("Selection")
            }
            .onChange(of: settings.colorScheme) { newColor in

            }
            

            
        }
    }
    
    /// Row in picker
    func row(for color: ColorElement) -> some View {
        return HStack {
            Circle()
                .foregroundColor(color.color)
                .frame(width: 25, height: 25)
            Text(color.title)
//                .foregroundColor(.primary)
                .font( $settings.colorScheme.wrappedValue == color ? .headline : .body)
                .padding(.horizontal)
            Spacer()
            
            
        }.padding()
    }
    
}

struct ColorSchemePicker_Previews: PreviewProvider {
    static var previews: some View {
        ColorSchemePicker()
    }
}
