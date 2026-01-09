//
//  LoanViewModel.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import Foundation
import Combine

class LoanViewModel: ObservableObject {
    @Published var loans: [Loan] = []
    @Published var toast: Toast?
    @Published var isNavigateToLoanDetailsView: Bool = false
    
    // Loan Type Options
    let loanTypes: [LoanType] = [
        LoanType.salaryELoan, LoanType.buyNowPayLater, LoanType.stockLoan
    ]
        
    // Form Fields
    @Published var selectedLoanType: LoanType?
    @Published var loanInterest: String = ""
    @Published var loanPeriod: String = ""
    @Published var loanAmount: String = ""
    @Published var interestAmount: Double = 0.0

    // Calculated Values
    @Published var totalAmountPayable: Double = 0.0
    @Published var repaymentSchedule: [RepaymentInstalment] = []

    @Published var dialogEntity = DialogEntity()
    @Published var isShowAlertDialog = false
    @Published var isShowLoanTypesBottomSheet = false
    
    // PDF Alert
    @Published var showDocumentPicker = false
    @Published var pdfDataToExport: Data?
    
    let loansUsecases = LoansUsecases(
        saveLoansToLocalDataSourceRepository: LoansRepository.shared,
        clearLoansLocalInDataSourceRepository: LoansRepository.shared,
        fetchLoansFromLocalDataSourceRepository: LoansRepository.shared
    )
    
    func downloadCalculation(loan: Loan) {
        
        selectedLoanType = loan.type
        totalAmountPayable = loan.totalAmountPayable
        interestAmount = loan.interestAmount
        loanAmount = "\(loan.amount)"
        repaymentSchedule = loan.repaymentSchedule
        
           let pdfGenerator = LoanPDFGenerator(viewModel: self)
           if let pdfData = pdfGenerator.generatePDFData() {
               self.pdfDataToExport = pdfData
               self.showDocumentPicker = true
           }
       }
    
    func loanTypeChanged() {
        guard let selectedLoanType = self.selectedLoanType else { return }
        loanInterest = String(format: "%.2f", selectedLoanType.interestRate)
        calculateLoan()
    }
    
    func calculateLoan() {
        repaymentSchedule = []
        
        guard let amount = Double(loanAmount.replacingOccurrences(of: ",", with: "")) else {
            totalAmountPayable = 0.0
            repaymentSchedule = []
            return
        }
        
        guard let interest = Double(loanInterest) else {
            totalAmountPayable = 0.0
            repaymentSchedule = []
            return
        }
        
        let interestAmount = amount * (interest / 100.0)
        totalAmountPayable = amount + interestAmount
        
        // Generate repayment schedule
        let instalmentAmount = totalAmountPayable / loanPeriod.to2Double()
        var schedule: [RepaymentInstalment] = []
        
        let calendar = Calendar.current
        let today = Date()
        guard let intLoanPeriod = Int(loanPeriod) else {return}
        if intLoanPeriod == 0 {return}
        if !loanPeriod.allSatisfy({ $0.isNumber }) { return }
        
        for i in 1...intLoanPeriod {
            if let dueDate = calendar.date(byAdding: .month, value: i - 1, to: today) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM yyyy"
                
                schedule.append(RepaymentInstalment(
                    instalmentNumber: i,
                    dueDate: dateFormatter.string(from: dueDate),
                    amount: instalmentAmount
                ))
            }
        }
        
        repaymentSchedule = schedule
    }
    
    func saveCalculation() {
        let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
        guard let selectedLoanType = self.selectedLoanType else { return }
        guard let loanAmount = Double(self.loanAmount.replacingOccurrences(of: ",", with: "")) else {
            totalAmountPayable = 0.0
            repaymentSchedule = []
            return
        }
        guard let monthlyPayment = repaymentSchedule.first?.amount else { return }
        let interestRate = loanInterest.to2Double()
        interestAmount = loanAmount * (interestRate / 100.0)
        let loanPeriod = Int(loanPeriod.to2Double())

        
        let loan =  Loan(
            id: Int(timestamp),
            type: selectedLoanType,
            amount: loanAmount,
            totalAmountPayable: totalAmountPayable,
            monthlyPayment: monthlyPayment,
            interest: interestRate,
            interestRate: interestRate,
            interestAmount: interestAmount,
            loanPeriodMonths: loanPeriod,
            style: selectedLoanType.style,
            repaymentSchedule: repaymentSchedule
        )
        
        loansUsecases.executeSaveLoansToLocal(loans: [loan])
    }
    
    func fetchLoansFromLocal() {
        let loans = loansUsecases.executeFetchLocalAccounts() ?? []
        self.loans = loans
    }
}
