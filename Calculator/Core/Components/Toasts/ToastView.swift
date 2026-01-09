//
//  ToastView.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import SwiftUI

struct ToastView: View {
    var style: ToastStyle
    var title: String
    var message: String
    var width = CGFloat.infinity
    var hasBorder: Bool = false
    var onCancelTapped: () -> Void
    
    var body: some View {
        HStack( alignment: .center, spacing: 12){
            ZStack {
                Circle()
                    .fill(Color.theme.greenColor)

                Text("i")
                    .font(.system(size: 30 * 0.6, weight: .bold))
                    .italic()
                    .foregroundColor(Color.theme.whiteColor)
            }
            .frame(width: 30, height: 30)
            
            VStack{
                Text(title)
                    .font(.custom("Gilroy-Semibold", size: 19))
                    .foregroundStyle(Color.theme.darkGreenColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(message)
                    .foregroundStyle(Color.gray)
                    .font(.custom("Gilroy-Medium", size: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer(minLength: 10)
            
            Button{
                onCancelTapped()
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(style.themeColor)
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .background(Color.theme.greenColor5)
        .cornerRadius(8)
        .overlay {
            Group{
                if hasBorder {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style.themeColor, lineWidth: 2)
                }
            }
        }
        .padding(.horizontal, 5)
        //.sensoryFeedback(.success, trigger: true) // Vibrate
    }
}
