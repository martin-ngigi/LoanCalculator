//
//  LoanCardView.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import SwiftUI

// MARK: - Reusable Loan Card View
struct LoanCardView: View {
    let loan: Loan
    
    var body: some View {
        VStack(spacing: 16) {
            
            VStack(spacing: 5) {
                Text(loan.type.rawValue)
                    .font(.custom("Gilroy-Bold", size: 16))
                    .foregroundColor(Color.theme.whiteColor)
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(CommonUtils.shared.formatCurrency(loan.totalAmountPayable))
                        .font(.custom("Gilroy-Bold", size: 24))
                        .foregroundColor(Color.theme.whiteColor)
                    
                    Text("KES")
                        .font(.custom("Gilroy-Bold", size: 16))
                        .foregroundColor(Color.theme.whiteColor)
                }
            }
            
            HStack(spacing: 0) {
                
                Spacer()
                
                VStack(alignment: .center, spacing: 8) {
                    
                    Text("Monthly Payment")
                        .font(.custom("Gilroy-Regular", size: 12))
                        .foregroundColor( Color.theme.grayColor3)
                    
                    Text("\(CommonUtils.shared.formatCurrency(loan.monthlyPayment)) KES")
                        .font(.custom("Gilroy-Bold", size: 16))
                        .foregroundColor(Color.theme.whiteColor)
                }
                
                
                
                Rectangle()
                    .fill(Color.theme.whiteColor)
                    .frame(width: 1.5, height: 48)
                    .padding(.horizontal, 30)
                
                
                VStack(alignment: .center, spacing: 8) {
                    Text("Interest")
                        .font(.custom("Gilroy-Regular", size: 12))
                        .foregroundColor(Color.theme.grayColor3)
                    
                    Text("\(CommonUtils.shared.formatCurrency(loan.interestAmount)) KES")
                        .font(.custom("Gilroy-Bold", size: 16))
                        .foregroundColor(Color.theme.whiteColor)
                }
                
                Spacer()
            }
        }
        .padding(15)
        .background(cardBackground)
        .cornerRadius(10)
        .shadow(color: Color.theme.blackAndWhite.opacity(0.3), radius: 4, x: 2, y: 4)
    }
    
    private var cardBackground: LinearGradient {
        switch loan.style {
        case .green:
            return LinearGradient(
                colors: [Color.theme.darkGreenColor, Color.theme.lightGreenColor],
                startPoint: .leading,
                endPoint: .trailing
            )
        case .blue:
            return LinearGradient(
                colors: [Color.theme.darkBlueColor, Color.theme.lightBlueColor],
                startPoint: .leading,
                endPoint: .trailing
            )
        case .orange:
            return LinearGradient(
                colors: [Color.theme.darkOrangeColor, Color.theme.lightOrangeColor],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
}


//#Preview {
//    LoanCardView()
//}
