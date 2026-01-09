//
//  CustomButtonView.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import SwiftUI

struct CustomButtonView: View {
    var buttonName: String
    var width: Double = .infinity
    var height: Double = 48
    var leadingIcon: String=""
    var leadingimage: String=""
    var icon: String=""
    var image: String=""
    var foregroundStyle: Color = Color.white
    var backgroundColor: Color = Color.theme.greenColor
    var borderColor: Color = Color.theme.greenColor
    var buttonNameColor: Color = Color.theme.whiteColor
    var isDisabled: Bool = false
    var isLoading: Bool = false
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                if(!leadingIcon.isEmpty){
                    Image(systemName: leadingIcon)
                }
                
                if(!leadingimage.isEmpty){
                    Image(leadingimage)
                }
                
                if isLoading{
                    ProgressView()
                }
                
                if(!buttonName.isEmpty){
                    Text(buttonName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(isDisabled ? Color.theme.blackColor : buttonNameColor)
                    
                }
          
                if(!icon.isEmpty){
                    Image(systemName: icon)
                }
                
                if(!image.isEmpty){
                    Image(image)
                }
                
            }
            .foregroundColor(foregroundStyle)
            .frame(maxWidth: width, maxHeight: height)
            .frame(height: height)
        }
        .background(isDisabled ? Color.theme.grayColor1 : backgroundColor)
        .disabled(isDisabled)
        .cornerRadius(7)
        .overlay(
               RoundedRectangle(cornerRadius: 7)
                   .stroke(borderColor, lineWidth: 1)
        )
        .shadow(color: Color.theme.blackAndWhite.opacity(0.16), radius: 3, x: 0, y: 1)

    }
}

#Preview {
    CustomButtonView(buttonName: "ButtonName", icon: "arrow.right") {
        print("You clicked CustomButtonView")
    }
}
