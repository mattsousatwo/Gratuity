//
//  IncrementButton.swift
//  Gratuity
//
//  Created by Matthew Sousa on 3/16/22.
//

import SwiftUI

/// Button to increment to decrement the value of numberOfPeople or tipValue
struct IncrementButton: View {
    
    @EnvironmentObject var settings: Settings
    var type: IncrementType
    var imageTag = ""
    
    var parameterMethod: () -> Void
    
    init(_ type: IncrementType, _ completion: @escaping () -> Void) {
        self.type = type
        self.parameterMethod = completion
    }
    
    var body: some View {
        
        
        Button {
            parameterMethod()
        } label: {
            type.image
                .foregroundColor(settings.colorScheme.color)
        }
        
        
    }
}

struct IncrementButton_Previews: PreviewProvider {
    static var previews: some View {
        IncrementButton(.tipMinus) {
             
        }
    }
}

extension IncrementButton {
    enum IncrementType {
        case tipPlus, tipMinus, peoplePlus, peopleMinus
        
        var image: Image {
            switch self {
            case .tipPlus, .peoplePlus:
                return Image(systemName: "plus")
            case .tipMinus, .peopleMinus:
                return Image(systemName: "minus")
            }
        }
        
    }
    
    
    
}
