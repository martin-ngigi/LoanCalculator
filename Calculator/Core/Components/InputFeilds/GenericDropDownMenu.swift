//
//  GenericDropDownMenu.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import SwiftUI

struct GenericDropDownMenu<T: Hashable>: View {
    var title: String
    var prompt: String
    var options: [T]
    @Binding var selection: T?
    var labelProvider: (T) -> String
    var onTap: (T) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {

            Text(title)
                .font(.custom("Gilroy-Regular", size: 12))
                .foregroundColor(Color.theme.grayColor4)
            
            VStack(alignment: .leading, spacing: 0) {
                
                Menu {
                    ForEach(options, id: \.self) { option in
                        Button {
                            selection = option
                            onTap(option)
                        } label: {
                            Text(labelProvider(option))
                                .font(.custom("Gilroy-Semibold", size: 14))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                } label: {
                    HStack {
                        
                        Text(selection.map(labelProvider) ?? prompt)
                            .font(.custom("Gilroy-Semibold", size: 14))
                            .foregroundColor(selection.map(labelProvider) != nil ? Color.theme.blackAndWhite : Color.theme.grayColor4)
                        
                        Spacer()
                        
                        Image("ic-arrow-down")
                    }
                    .foregroundColor(Color.theme.blackAndWhite)
                    .padding([.horizontal, .vertical])
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.theme.grayColor4, lineWidth: 0.5)
                    )
                }

            }
        }
    }
}


#Preview {
    GenericDropDownMenu(
        title: "Country",
        prompt: "Select country",
        options: ["Kenya", "Uganda", "Tanzania"],
        selection: .constant(""),
        labelProvider: { $0 },
        onTap: { item in

        }
    )
}
