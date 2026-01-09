//
//  LoansListView.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import SwiftUI

struct LoansListView: View {
    @StateObject private var viewModel = LoanViewModel()
    @StateObject private var themeViewModel = ThemeViewModel()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 0) {
                    // Header
                    ZStack{
                        Image("Header2")
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                            .edgesIgnoringSafeArea(.top)
                        
                        HStack(spacing: 16) {
                            
                            Image("user")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .padding(.leading, 15)
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Hello There!")
                                    .font(.custom("ProductSans-Bold", size: 24))
                                    .foregroundColor(Color.theme.whiteColor)
                                
                                Text("Boost your income today!")
                                    .font(.custom("ProductSans-Regular", size: 12))
                                    .foregroundColor(Color.theme.whiteColor.opacity(0.9))
                            }
                            
                            Spacer()

                            Menu {
                                ForEach(ThemeEntity.allCases) { theme in
                                    Button {
                                        themeViewModel.changeTheme(to: theme)
                                    } label: {
                                        Label {
                                            Text(theme.themName)
                                        } icon: {
                                            Image(systemName: theme.icon)
                                        }
                                    }
                                }
                            } label: {
                                Image(systemName: themeViewModel.currentTheme.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color.theme.whiteColor)
                                    .padding(.trailing, 15)
                            }
                            
                        }
                        .padding(.horizontal, 10)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    
                    // Content
                    ScrollView {
                        VStack(spacing: 0) {
                            Text("Loan Calculations")
                                .font(.custom("Gilroy-Semibold", size: 16))
                                .padding(.vertical, 15)
                            
                            // Loan Cards
                            VStack(spacing: 16) {
                                
                                if viewModel.loans.isEmpty {
                                    VStack{
                                        Image("missing")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                        
                                        Text("Your saved loan calculations will appear here")
                                            .font(.custom("Gilroy-Regular", size: 12))
                                            .foregroundColor(Color.theme.grayColor5)
                                            .padding(.vertical, 15)
                                    }
                                }
                                ForEach(viewModel.loans) { loan in
                                    NavigationLink{
                                        LoanDetailsView(
                                            loan: loan,
                                            onDismiss: { toast in
                                                Task{
                                                    try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 sec
                                                    viewModel.toast = toast
                                                }
                                            }
                                        ).navigationBarBackButtonHidden()
                                    } label: {
                                        LoanCardView(loan: loan)
                                    }
                                }
                            }
                                                    
                        }
                        .padding(.horizontal, 10)
                        .padding(.bottom, 100)
                    }
                    
                }
                
                // Floating Calculator Button
                NavigationLink{
                    CalculateLoanView(
                        onDismiss: { toast in
                            Task{
                                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 sec
                                viewModel.toast = toast
                            }
                        }
                    ).navigationBarBackButtonHidden()
                } label: {
                    Image("calculator")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .padding(7)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color.theme.lightGreenColor,
                                    Color.theme.greenColor,
                                    Color.theme.greenColor,
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Circle())
                        .shadow(color: Color.theme.blackAndWhite.opacity(0.4), radius: 6, x: 3, y: 3)
                }
                .padding(.trailing, 24)
                .padding(.bottom, 32)
            }
            .onAppear{
                viewModel.fetchLoansFromLocal()
            }
            .toastView(toast: $viewModel.toast)
        }
    }
}

#Preview {
    LoansListView()
}
