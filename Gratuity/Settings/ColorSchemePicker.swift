//
//  ColorSchemePicker.swift
//  Gratuity
//
//  Created by Matthew Sousa on 3/14/22.
//

import SwiftUI

struct ColorSchemePicker: View {
    
    @EnvironmentObject var settings: Settings
    
    @State private var selection = 0
    
    var body: some View {
        
        Section("Color Scheme") {
            
            Picker(selection: $settings.colorScheme) {
                ForEach(ColorElement.allCases, id: \.self) { color in
                    row(for: color)
                }
            } label: {
                Text("Selection")
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
//            .onTapGesture {
//                settings.colorScheme = color
//            }
    }
    
}

struct ColorSchemePicker_Previews: PreviewProvider {
    static var previews: some View {
        ColorSchemePicker()
    }
}
