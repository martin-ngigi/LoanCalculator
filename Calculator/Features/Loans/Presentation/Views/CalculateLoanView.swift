//
//  CalculateLoanView.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import SwiftUI
import Combine

// MARK: - Calculate Loan View
struct CalculateLoanView: View {
    
    @StateObject var viewModel = LoanViewModel()
    @Environment(\.dismiss) var dismiss
    @FocusState private var isAmountFocused: Bool
    var onDismiss: (Toast?) -> Void
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(spacing: 0) {
                // Content
                VStack(spacing: 24) {
                    
                    VStack(spacing: 8) {
                        HStack(spacing: 4) {
                            
                            Text("Total Amount Payable")
                                .font(.custom("Gilroy-Regular", size: 14))
                                .foregroundColor(Color.theme.grayColor4)
                            
                            Text("(KES)")
                                .font(.custom("Gilroy-Regular", size: 12))
                                .foregroundColor(Color.theme.greenColor)
                        }
                        .padding(.top)
                        
                        Text(CommonUtils.shared.formatCurrency(viewModel.totalAmountPayable))
                            .font(.custom("Gilroy-Bold", size: 32))
                            .foregroundColor(Color.theme.greenColor)
                    }
                                        
                    // Form Fields
                    VStack(spacing: 20) {
                        
                        SelectFromView(
                            description: "Loan Type",
                            title: viewModel.selectedLoanType?.title ?? "Select Loan Type",
                            titleColor: viewModel.selectedLoanType?.title == nil ? Color.gray.opacity(0.5) : Color.theme.blackAndWhite,
                            onTap: {
                                viewModel.isShowLoanTypesBottomSheet = true
                            }
                        )
                        
                        // Loan Interest
                        InputTextFieldView(
                            description: "Loan Interest (%)",
                            placeholder: "Enter Loan Interest ",
                            text: $viewModel.loanInterest,
                            isDisabled: true
                        )
                        
                        
                        // Loan Amount
                        InputTextFieldView(
                            description: "Loan Amount",
                            placeholder: "Enter Loan Amount",
                            text: $viewModel.loanAmount,
                            inputFieldCurrency: "KES"
                        )
                        .onChange(of: viewModel.loanAmount) {newValue in
                            viewModel.calculateLoan()
                        }
                        
                        VStack(spacing: 3){
                            // Loan Period
                            InputTextFieldView(
                                description: "Loan Period (months)",
                                placeholder: "Enter Loan Period",
                                text: $viewModel.loanPeriod
                            )
                            .onChange(of: viewModel.loanPeriod) {newValue in
                                viewModel.calculateLoan()
                            }
                            
                            // Total Amount Summary
                            if !"\(viewModel.totalAmountPayable)".isEmpty && viewModel.totalAmountPayable != 0{
                                HStack {
                                    Text("Total Amount Payable:")
                                        .font(.custom("Gilroy-Regular", size: 12))
                                                                    
                                    Text("\(CommonUtils.shared.formatCurrency(viewModel.totalAmountPayable)) KES")
                                        .font(.custom("Gilroy-Semibold", size: 12))
                                        .foregroundColor(Color.theme.greenColor)

                                    Spacer()

                                }
                            }
                        }
                        
                    }
                    
                    // Repayment Schedule
                    if !viewModel.repaymentSchedule.isEmpty{
                        VStack(spacing: 20) {
                            Text("Repayment Schedule")
                                .font(.custom("Gilroy-Semibold", size: 18))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 16) {
                                ForEach(viewModel.repaymentSchedule) { instalment in
                                    InstalmentRow(instalment: instalment)
                                }
                            }
                        }
                    }
                    
                    Spacer(minLength: 20)
                }
                
                var isEnabled: Bool {
                    return viewModel.selectedLoanType != nil
                    && viewModel.loanAmount != "0"
                    && !viewModel.loanAmount.isEmpty
                    && !viewModel.loanInterest.isEmpty
                    && !viewModel.loanPeriod.isEmpty
                    && !viewModel.repaymentSchedule.isEmpty
                }

                // Save Button
                CustomButtonView(
                    buttonName: "Save Calculation",
                    borderColor: Color.clear,
                    isDisabled: !isEnabled
                ) {
                    viewModel.saveCalculation()
                    viewModel.dialogEntity =  DialogEntity(
                        title: "Calculation Saved",
                        message: "You are loan calculation has been saved successfully.",
                        icon: "money",
                        confirmButtonText: "Go Home",
                        dismissButtonText: "",
                        onConfirm: {
                            let toast = Toast(
                                style: .success,
                                title: "Info",
                                message: "Your loan schedule has been saved successfully."
                            )
                            onDismiss(toast)
                            dismiss()
                        },
                        onDismiss: {
                            dismiss()
                        }
                    )
                    viewModel.isShowAlertDialog = true
                }
            }
        }
        .padding(.horizontal)
        .overlay {
            CustomAlertDialog(
                isPresented: $viewModel.isShowAlertDialog,
                title: viewModel.dialogEntity.title,
                text: viewModel.dialogEntity.message,
                confirmButtonText: viewModel.dialogEntity.confirmButtonText,
                dismissButtonText: viewModel.dialogEntity.dismissButtonText,
                imageName: viewModel.dialogEntity.icon,
                onDismiss: {
                    if let onDismiss = viewModel.dialogEntity.onDismiss {
                        onDismiss()
                    }
                },
                onConfirmation: {
                    if let onConfirm = viewModel.dialogEntity.onConfirm {
                        onConfirm()
                    }
                }
            )
        }
        .sheet(isPresented: $viewModel.isShowLoanTypesBottomSheet){
            LoanTypesBottomSheet(
                loanTypes: viewModel.loanTypes,
                selectedLoanType: viewModel.selectedLoanType,
                onTap: { loanType in
                    viewModel.selectedLoanType = loanType
                    viewModel.loanTypeChanged()
                    viewModel.isShowLoanTypesBottomSheet = false
                }
            )
            .conditionalPresentationDetents(fraction: 0.4)
        }
        .customToolbar(
            title: "Calculate Loan",
            backAction: {
                dismiss()
            },
            dismissAction: {
                dismiss()
            }
        )
    }
}
