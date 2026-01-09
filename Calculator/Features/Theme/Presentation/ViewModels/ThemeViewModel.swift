//
//  ThemeViewModel.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import Foundation
import Combine
import UIKit
import SwiftUI

class ThemeViewModel: ObservableObject{
    @Published var currentTheme: ThemeEntity = .device

    func changeTheme(to theme: ThemeEntity) {
        LocalState.isDarkModeOn = "\(theme == .dark)" // "true" or "false"
        currentTheme = theme
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = theme.userInterfaceStyle
        print("Debug: isDarkModeOn \(LocalState.isDarkModeOn ?? "")")
    }
    
    func setAppTheme() {
        var isDarkModeOn: Bool
        let savedThemeIsDarkModeOn: String? = LocalState.isDarkModeOn
        
        if savedThemeIsDarkModeOn == "true" {
            isDarkModeOn = true
        }
        else if savedThemeIsDarkModeOn == "false"{
            isDarkModeOn = false
        }
        else {
            // Fallback to system default
            let systemStyle = UIScreen.main.traitCollection.userInterfaceStyle
            //isDarkModeOn = systemStyle == .dark ? true : false
            isDarkModeOn = true
            print("DEBUG: systemStyle \(systemStyle), isDarkModeOn \(isDarkModeOn)")
        }
        
        currentTheme = ThemeEntity(isDarkModeOn: isDarkModeOn)
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = currentTheme.userInterfaceStyle
        print("DEBUG: currentTheme \(currentTheme.themName)")
    }
}
