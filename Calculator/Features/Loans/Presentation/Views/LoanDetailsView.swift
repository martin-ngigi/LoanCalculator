//
//  LoanDetailsView.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import SwiftUI

struct LoanDetailsView: View {
    @StateObject private var viewModel = LoanViewModel()
    let loan: Loan
    var onDismiss: (Toast?) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Loan Type and Total Amount
                    VStack(spacing: 12) {
                        Text(loan.type.title)
                            .font(.custom("Gilroy-Semibold", size: 14))
                            .padding(.top, 10)
                        
                        HStack(spacing: 4) {
                            
                            Text("Total Amount Payable")
                                .font(.custom("Gilroy-Regular", size: 14))
                                .foregroundColor(Color.theme.grayColor4)
                            
                            Text("(KES)")
                                .font(.custom("Gilroy-Regular", size: 12))
                                .foregroundColor(Color.theme.greenColor)
                        }
                        
                        Text(CommonUtils.shared.formatCurrency(loan.totalAmountPayable))
                            .font(.custom("Gilroy-Bold", size: 32))
                            .foregroundColor(Color.theme.greenColor)
                    }
                    
                    // Loan Details
                    VStack(spacing: 10) {
                        DetailRow(
                            label: "Loan Interest (%)",
                            value: "\(Int(loan.interestRate))%",
                            valueColor: Color.theme.greenColor1
                        )
                        
                        DetailRow(
                            label: "Interest",
                            value: "\(CommonUtils.shared.formatCurrency(loan.interestAmount)) KES",
                            valueColor: Color.theme.greenColor1
                        )
                        
                        DetailRow(
                            label: "Loan Amount",
                            value: "\(CommonUtils.shared.formatCurrency(loan.totalAmountPayable)) KES",
                            valueColor: Color.theme.greenColor1
                        )
                        
                        DetailRow(
                            label: "Loan Period (months)",
                            value: "\(loan.loanPeriodMonths) Months",
                            valueColor: Color.theme.greenColor1
                        )
                    }
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                        .padding(.horizontal, 40)
                    
                    // Repayment Schedule
                    VStack(spacing: 20) {
                        Text("Repayment Schedule")
                            .font(.custom("Gilroy-Semibold", size: 18))
                        
                        VStack(spacing: 16) {
                            ForEach(loan.repaymentSchedule) { instalment in
                                InstalmentRow(instalment: instalment)
                            }
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            
            Spacer()
            
            CustomButtonView(
                buttonName: "Download Calculation",
                leadingIcon: "arrow.down.to.line.compact"
            ) {
                viewModel.downloadCalculation(loan: loan)
            }
        }
        .sheet(
            isPresented: $viewModel.showDocumentPicker,
            onDismiss: {
                let toast = Toast(
                    style: .success,
                    title: "File downloaded successfully",
                    message: "Your loan schedule downloaded successfully."
                )
                onDismiss(toast)
                dismiss()
            },
            content: {
                if let pdfData = viewModel.pdfDataToExport {
                    var dateFormatter : DateFormatter{
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyyMMdd_HHmmss"
                        return formatter
                    }
                    let timestamp = dateFormatter.string(from: Date())
                    let fileName = "LoanCalculation_\(timestamp).pdf"
                    
                    DocumentPicker(pdfData: pdfData, fileName: fileName)
                }
            }
        )
        .padding(.horizontal)
        .customToolbar(
            title: "Loan Calculation",
            backAction: {
                dismiss()
            },
            dismissAction: {
                dismiss()
            }
        )
    }
    
}

// MARK: - Reusable Components
struct DetailRow: View {
    let label: String
    let value: String
    let valueColor: Color
    
    var body: some View {
        HStack {
            Text(label)
                .font(.custom("Gilroy-Regular", size: 14))
                .foregroundColor(Color.theme.grayColor4)
            
            Spacer()
            
            Text(value)
                .font(.custom("Gilroy-Bold", size: 18))
                .foregroundColor(valueColor)
        }
    }
}

struct InstalmentRow: View {
    let instalment: RepaymentInstalment
    
    var body: some View {
        HStack {
            
            Text("\(ordinal(instalment.instalmentNumber)) instalment - \(instalment.dueDate)")
                .font(.custom("Gilroy-Regular", size: 12))
            
            Spacer()
            
            Text("\(CommonUtils.shared.formatCurrency(instalment.amount)) KES")
                .font(.custom("Gilroy-Bold", size: 14))
        }
    }
    
    private func ordinal(_ number: Int) -> String {
        switch number {
        case 1: return "1st"
        case 2: return "2nd"
        case 3: return "3rd"
        default: return "\(number)th"
        }
    }
}
