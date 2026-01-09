//
//  InputTextFieldView.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import SwiftUI

struct InputTextFieldView: View {
    var image: String = ""
    var description: String = ""
    var placeholder: String = ""
    @Binding var text: String
    var foregroundColor: Color = Color.theme.blackAndWhite
    var keyboardType: UIKeyboardType = .default
    var characterLimit = 30
    var dividerColor: Color = Color.theme.grayColor4
    var errorMessage: String = ""
    var loadingMessage: String = "Loading..."
    var isLoading: Bool = false
    var extraMessage: String = ""
    var inputFieldCurrency: String = ""
    var isDisabled: Bool = false


    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            if !description.isEmpty {
                Text(description)
                    .font(.custom("Gilroy-Regular", size: 12))
                    .foregroundColor(Color.theme.grayColor4)
            }
            
            HStack {
                
                if !image.isEmpty {
                    Image(image)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(Color.theme.blackAndWhite)
                        .frame(width: 20, height: 20)
                }
                  
                if !inputFieldCurrency.isEmpty {
                    HStack{
                        Text(inputFieldCurrency)
                            .font(.custom("Gilroy-Semibold", size: 14))
                        
                        Rectangle()
                            .fill(Color.theme.grayColor4)
                            .frame(width: 1, height: 20)
                            .padding(.horizontal, 10)
                    }
                }
                  
                VStack(alignment: .leading, spacing: 0) {

                    
                    TextField(placeholder, text: $text)
                        .font(.custom("Gilroy-Semibold", size: 14))
                        .textFieldStyle(TappableTextFieldStyle())
                        .autocorrectionDisabled(true)
                        .autocapitalization(.none)
                        .keyboardType(keyboardType)
                        .foregroundColor(foregroundColor)
                        .onTapGesture {
                            self.endEditing()
                        }
                        .onChange(of: text) {  newValue in
                            if newValue.count > characterLimit {
                                text = String(newValue.prefix(characterLimit))
                            }
                        }
                        .disabled(isDisabled)
                    
                }
            }
            .padding(.vertical, 2)
            .padding(.horizontal, 10)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.theme.grayColor4, lineWidth: 0.5)
            )

            if isLoading {
                Text(loadingMessage)
                    .foregroundColor(Color.blue)
            }
            else if !extraMessage.isEmpty {
                Text(extraMessage)
                    .font(.custom("ProductSans-Light", size: 17))
                    .foregroundColor(Color.red)
            }
            else if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.system(size: 12,
                                  weight: .light,
                                  design: .rounded))
                    .foregroundColor(Color.red)
            }
            
        }
    }
}

struct TappableTextFieldStyle: TextFieldStyle { // https://stackoverflow.com/questions/56795712/swiftui-textfield-touchable-area
    @FocusState private var textFieldFocused: Bool
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, 12)
            .focused($textFieldFocused)
            .contentShape(Rectangle()) // Make entire padded area tappable
            .onTapGesture {
                textFieldFocused = true
            }
    }
}

#Preview {
    InputTextFieldView( text: .constant(""))
}
