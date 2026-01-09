//
//  LoanType.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import Foundation

enum LoanType: String, Codable {
    case salaryELoan = "Salary E-Loan"
    case buyNowPayLater = "Buy Now Pay Later"
    case stockLoan = "Stock Loan"
    
    var title: String {
        switch self {
        case .salaryELoan:
            return "Salary E-Loan"
        case .buyNowPayLater:
            return "Buy Now Pay Later"
        case .stockLoan:
            return "Stock Loan"
        }
    }
    
    var interestRate: Double {
        switch self {
        case .salaryELoan:
            return 15.0
        case .buyNowPayLater:
            return 12.0
        case .stockLoan:
            return 18.0
        }
    }
    
    var style: CardStyle {
        switch self {
        case .salaryELoan:
                .green
        case .buyNowPayLater:
                .blue
        case .stockLoan:
                .orange
        }
    }
}
