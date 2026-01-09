//
//  LoanTypesBottomSheet.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import SwiftUI

struct LoanTypesBottomSheet: View {
    var loanTypes: [LoanType] = []
    var selectedLoanType: LoanType?
    var onTap: (LoanType) -> Void
    
    var body: some View {
        VStack(spacing: 20){
            
            Text("Loan Types")
                .font(.custom("Gilroy-Bold", size: 19))

            VStack(spacing: 15) {
                ForEach(loanTypes, id: \.self) { loanType in
                    Button{
                        onTap(loanType)
                    } label: {
                        Text(loanType.title)
                            .font(.custom("Gilroy-Semibold", size: 14))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .foregroundColor(Color.theme.greenColor1)
                            .background(selectedLoanType == loanType ?  Color.theme.greenColor6 : Color.theme.whiteAndBlack)
                            .cornerRadius(7)
                            .shadow(color: Color.theme.blackAndWhite.opacity(0.3), radius: 3, x: 1, y: 2)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.theme.grayColor4, lineWidth: 0.1)
                    )
                }
            }
            
            
            Spacer()
        }
        .padding(.vertical, 20)
        .padding()
        //.presentationDragIndicator(.visible)
    }
}

#Preview {
    LoanTypesBottomSheet(
        onTap: { _ in
            
        }
    )
}
