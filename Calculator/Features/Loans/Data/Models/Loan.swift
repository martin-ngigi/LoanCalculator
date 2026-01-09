//
//  Loan.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import Foundation

struct Loan: Identifiable, Codable {
    let id: Int
    let type: LoanType
    let amount: Double
    let totalAmountPayable: Double
    let monthlyPayment: Double
    let interest: Double
    let interestRate: Double
    let interestAmount: Double
    let loanPeriodMonths: Int
    let style: CardStyle
    let repaymentSchedule: [RepaymentInstalment]
    let createdDate: Date = Date()
}

struct RepaymentInstalment: Identifiable, Codable {
    let id = UUID()
    let instalmentNumber: Int
    let dueDate: String
    let amount: Double
}
