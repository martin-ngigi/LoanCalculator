//
//  CustomAlertDialog.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import SwiftUI

struct CustomAlertDialog: View {
    @Binding var isPresented: Bool
    var title: String
    var text: String
    var confirmButtonText: String = ""
    var dismissButtonText: String
    var imageName: String
    var onDismiss: () -> Void
    var onConfirmation: () -> Void

    var body: some View {
        ZStack {

            if isPresented {
                // Background overlay
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                       // isPresented = false // Dismiss when tapping outside
                    }

                // Alert dialog
                VStack(spacing: 20) {
                    
                    Text(title)
                        .font(.custom("Gilroy-Bold", size: 18))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.theme.greenColor)

                    if !imageName.isEmpty {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                    }
                    
                    
                    Text(text)
                        .font(.system(size: 17, weight: .light, design: .rounded))
                        .multilineTextAlignment(.center)
                        .font(.custom("Gilroy-Medium", size: 16))

                    HStack {

                        if !dismissButtonText.isEmpty {
                            CustomButtonView(
                                buttonName: dismissButtonText,
                                backgroundColor: Color.clear,
                                buttonNameColor: Color.white
                            ) {
                                onDismiss()
                                isPresented = false
                            }
                        }
                        

                    if !confirmButtonText.isEmpty {
                        
                        CustomButtonView(buttonName: confirmButtonText) {
                            onConfirmation()
                            isPresented = false
                        }
                    }
                  }
                }
                .padding()
                .background(Color.theme.whiteAndBlack)
                .cornerRadius(11)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.94)
                .overlay(
                       RoundedRectangle(cornerRadius: 11)
                        .stroke(Color.theme.grayColor1, lineWidth: 1)
                   )
                .padding()
                .shadow(radius: 10)
            }
        }
    }
}

#Preview {
    CustomAlertDialog(
        isPresented: .constant(true),
        title: "Oops",
        text: "Error occurred",
        confirmButtonText: "Retry",
        dismissButtonText: "Okay",
        imageName: "error",
        onDismiss: {
            
        },
        onConfirmation: {
            
        }
    )
}
