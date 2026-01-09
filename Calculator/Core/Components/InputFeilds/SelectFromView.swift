//
//  SelectFromView.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import SwiftUI

struct SelectFromView: View {
    var leadingImage: String = ""
    var trailingImage: String = "ic-arrow-down"
    var description: String
    var title: String  = ""
    var titleColor: Color  = Color.theme.grayColor4
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 10){
            HStack {
                Text(description)
                    .font(.custom("Gilroy-Regular", size: 12))
                    .foregroundColor(Color.theme.grayColor4)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Button{
                onTap()
            } label: {
                HStack(spacing: 0) {
                    if !leadingImage.isEmpty {
                        Image(leadingImage)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.theme.blackAndWhite)
                            .frame(width: 25, height: 25)
                            .padding(.leading, 5)
                    }
                    VStack(alignment: .leading, spacing: 0){
                        
                        if !title.isEmpty {
                            Text(title)
                                .font(.custom("Gilroy-Semibold", size: 14))
                                .foregroundColor(titleColor)
                        }
                    }
                    
                    Spacer()
                    
                    Image(trailingImage)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.theme.grayColor4, lineWidth: 0.5)
                )
            }
            
        }
        .foregroundColor(Color.theme.blackAndWhite)
    }
}

#Preview {
    SelectFromView(
        description: "Drop down",
        title: "Title here",
        onTap: {
        }
    )
    .padding(10)
}
