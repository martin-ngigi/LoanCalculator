//
//  DummyLoansData.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import Foundation

struct DummyLoansData{
    
    static let shared = DummyLoansData()
    
    var dummyLoans: [Loan] = [
        
        Loan(
            id: 1,
            type: .salaryELoan,
            amount: 11500,
            totalAmountPayable: 13000,
            monthlyPayment: 6500,
            interest: 1500,
            interestRate: 0.13,
            interestAmount: 1500,
            loanPeriodMonths: 2,
            style: .green,
            repaymentSchedule: [
                RepaymentInstalment(
                    instalmentNumber: 1,
                    dueDate: "01 Feb 2026",
                    amount: 6500
                ),
                RepaymentInstalment(
                    instalmentNumber: 2,
                    dueDate: "01 Mar 2026",
                    amount: 6500
                )
            ]
        ),

        Loan(
            id: 2,
            type: .buyNowPayLater,
            amount: 8000,
            totalAmountPayable: 9500,
            monthlyPayment: 4750,
            interest: 1500,
            interestRate: 0.19,
            interestAmount: 1500,
            loanPeriodMonths: 2,
            style: .blue,
            repaymentSchedule: [
                RepaymentInstalment(
                    instalmentNumber: 1,
                    dueDate: "10 Feb 2026",
                    amount: 4750
                ),
                RepaymentInstalment(
                    instalmentNumber: 2,
                    dueDate: "10 Mar 2026",
                    amount: 4750
                )
            ]
        ),

        Loan(
            id: 3,
            type: .salaryELoan,
            amount: 11500,
            totalAmountPayable: 13000,
            monthlyPayment: 6500,
            interest: 1500,
            interestRate: 0.13,
            interestAmount: 1500,
            loanPeriodMonths: 2,
            style: .green,
            repaymentSchedule: [
                RepaymentInstalment(
                    instalmentNumber: 1,
                    dueDate: "01 Apr 2026",
                    amount: 6500
                ),
                RepaymentInstalment(
                    instalmentNumber: 2,
                    dueDate: "01 May 2026",
                    amount: 6500
                )
            ]
        ),

        Loan(
            id: 4,
            type: .stockLoan,
            amount: 11500,
            totalAmountPayable: 12800,
            monthlyPayment: 6400,
            interest: 1300,
            interestRate: 0.11,
            interestAmount: 1300,
            loanPeriodMonths: 2,
            style: .orange,
            repaymentSchedule: [
                RepaymentInstalment(
                    instalmentNumber: 1,
                    dueDate: "15 Feb 2026",
                    amount: 6400
                ),
                RepaymentInstalment(
                    instalmentNumber: 2,
                    dueDate: "15 Mar 2026",
                    amount: 6400
                )
            ]
        ),

        Loan(
            id: 5,
            type: .buyNowPayLater,
            amount: 8000,
            totalAmountPayable: 9200,
            monthlyPayment: 4600,
            interest: 1200,
            interestRate: 0.15,
            interestAmount: 1200,
            loanPeriodMonths: 2,
            style: .blue,
            repaymentSchedule: [
                RepaymentInstalment(
                    instalmentNumber: 1,
                    dueDate: "20 Feb 2026",
                    amount: 4600
                ),
                RepaymentInstalment(
                    instalmentNumber: 2,
                    dueDate: "20 Mar 2026",
                    amount: 4600
                )
            ]
        )
    ]
}
