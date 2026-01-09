//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import SwiftUI

@main
struct CalculatorApp: App {
    
    init() {
        CommonUtils.shared.setUpAppNavigationHeaderImage()
    }
    
    @StateObject var themesViewModel = ThemeViewModel()

    var body: some Scene {
        WindowGroup {
            LoansListView()
                .onAppear{
                    themesViewModel.setAppTheme()
                }
        }
    }
}
