//
//  CalculationView.swift
//  Gratuity
//
//  Created by Matthew Sousa on 3/7/22.
//

import SwiftUI

struct CalculationView: View {
    
    @ObservedObject private var calculationModel = CalculationViewModel()
    
    @StateObject var settings = Settings()
    
    @State private var percentages = [TipPercentage(0.12), TipPercentage(0.15),
                                      TipPercentage(0.20), TipPercentage(0.25)]
    
    var body: some View {
        
        
        
        VStack(alignment: .center) {
            
            inputFields()
            
            Spacer()
            
            percentageButtons()
                .padding(.bottom)
            
        }
        .contentShape(Rectangle())
        .keyboardAdaptive()
        .onTapGesture {
            self.hideKeyboard()
            calculationModel.updateTotal()
        }
        
        .onAppear {
            calculationModel.updateTotal()
        }
        .onChange(of: calculationModel.priceValue) { newValue in
//            calculationModel.priceString = calculationModel.convertToCurrency(newValue)
            //            totalPriceString = calculationModel.convertToCurrency(newValue)
        }
        .navigationTitle(Text("Gratuity"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SettingsView(options: $percentages)
                        .environmentObject(settings)
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .resizable()
                        .frame(width: 20,
                               height: 20,
                               alignment: .center)
                }.buttonStyle(PlainButtonStyle() )
                
            }
            
        }
        .onAppear {
            print("ColorScheme = \(settings.colorScheme.title)")
        }
        .environmentObject(settings)
        
    }
        
}

// Preview
struct CalculationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CalculationView()
        }
    }
}



extension CalculationView {
    
    /// All of the information used to calculate the tip
    func inputFields() -> some View {
        VStack {
            calculationTextfield()
            
            tipField()
            numberOfPeopleRow()
            Divider()
            total()
            tipTotal()
        }
    }
    
    /// Row to display the total price
    func total() -> some View {
        return HStack(alignment: .center) {
            Text("Total")
            Spacer()
            Text(calculationModel.totalPriceString)
                .font(.largeTitle)
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    func tipTotal() -> some View {
        return HStack(alignment: .center) {
            Text("Tip Total")
            Spacer()
            Text("\(calculationModel.tipTotalString)")
                .font(.title)
        }
        .padding(.horizontal)
        .foregroundColor(.gray)
    }
    
    /// Price textfield
    func calculationTextfield() -> some View {
        HStack(alignment: .center) {
            Text("Price")
            Spacer()
            
            //            TextField("",
            //                      value: $calculationModel.priceValue,
            //                      formatter: calculationModel.localeCurrencyFormat)
            //
            
            TextField("",
                      value: $calculationModel.priceValue,
                      formatter: calculationModel.localeCurrencyFormat) {
                calculationModel.updateTotal()
            }
                      .disableAutocorrection(true)
                      .accentColor(.clear)
                      .keyboardType(.decimalPad)
                      .font(.largeTitle)
                      .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
    
    // Tip field
    func tipField() -> some View {
        HStack {
            
            Text("tip")
            Spacer()
            
            IncrementButton(.tipMinus) {
                calculationModel.subtractTipPercentage()
            }
            Text("\(calculationModel.tipPercentage.asString)")
                .frame(width: 60)
                .font(.title)
                .padding(.horizontal, 10)
            IncrementButton(.tipPlus) {
                calculationModel.addOntoTipPercentage()
            }
                
            
                
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
    
    
    /// Row to handle the amount of people to input into the calculation
    func numberOfPeopleRow() -> some View {
        
//        enum IncrementType {
//            case plus, minus
//        }
//
//        /// Button to increment to decrement the value of numberOfPeople
//        func incrementButton(_ type: IncrementType) -> some View {
//            var imageTag = ""
//            switch type {
//            case .plus:
//                imageTag = "plus"
//            case .minus:
//                imageTag = "minus"
//            }
//
//            return Button {
//                defer {
//                    calculationModel.updateTotal()
//                }
//                switch type {
//                case .plus:
//                    if calculationModel.numberOfPeople < 99 {
//                        calculationModel.numberOfPeople += 1
//                    }
//                case .minus:
//                    if calculationModel.numberOfPeople > 1 {
//                        calculationModel.numberOfPeople -= 1
//                    }
//                }
//
//            } label: {
//                Image(systemName: imageTag)
//                    .foregroundColor(settings.colorScheme.color)
//            }
//        }
        
        
        return HStack(alignment: .center) {
            
            Text("People")
            HStack {
                IncrementButton(.peopleMinus) {
                    calculationModel.subtractNumberOfPeople()
                }
//                incrementButton(.minus)
                
                Text("\(calculationModel.numberOfPeople)")
                    .frame(width: 35)
                    .font(.title)
                    .padding(.horizontal, 10)
                
//                incrementButton(.plus)
                IncrementButton(.peoplePlus) {
                    calculationModel.addOntoNumberOfPeople()
                }
            }.padding(5)
            
            Spacer()
            Text("\(calculationModel.tipValuePerPersonString)")
                .font(.title)
            
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
    
    /// Four buttons to determine the tip percentage
    func percentageButtons() -> some View {
        LazyVGrid(columns: calculationModel.percentageButtonColumnWidth,
                  alignment: .center,
                  spacing: 30) {
            ForEach(percentages, id: \.self) { percent in
                TipButton(percentage: percent,
                          size: .large)
                    .contentShape(RoundedRectangle(cornerRadius: 12) )
                    .onTapGesture {
                        self.hideKeyboard()
                        calculationModel.tipPercentage = percent
                        calculationModel.updateTotal()
                    }
                    .environmentObject(settings)
            }
            
        }
    }
    
    
}
