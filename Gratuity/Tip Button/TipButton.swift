//
//  TipButton.swift
//  Gratuity
//
//  Created by Matthew Sousa on 3/7/22.
//

import SwiftUI

struct TipButton: View {
    
    @EnvironmentObject var settings: Settings
    
    private let buttonModel = TipButtonModel()
    
    var percentage: TipPercentage
    var size: TipButtonSize = .small
    var font: Font? = nil
    
    var body: some View {
        tipBody()
    }
}

struct TipButton_Previews: PreviewProvider {
    static var previews: some View {
        TipButton(percentage: TipPercentage(0.12))
            .environmentObject(Settings())
            .previewLayout(.sizeThatFits)
    }
}


extension TipButton {
    
    // The body of the TipButton
    func tipBody() -> some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 5)
                .foregroundColor(settings.colorScheme.color)
                .frame(width: size.size,
                       height: size.size,
                       alignment: .center)
                
            
            Text(percentage.asString)
                .font(size == .large ? .title : font)
                .font(size == .small ? .headline : font)
                
        }
    }
    
    
    
}


extension TipButton {
    
    enum TipButtonSize {
        case small
//        case medium
        case large
        
        var size: CGFloat {
            switch self {
            case .small:
                return UIScreen.main.bounds.width / 4 - 30
//            case .medium:
//                <#code#>
            case .large:
                return UIScreen.main.bounds.width / 2 - 30
            }
        }
    }
    
}
