//
//  ThemeModeEntity.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import Foundation

import SwiftUI

enum ThemeEntity: String, CaseIterable, Identifiable {
    case device, light, dark

    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .device: return .unspecified
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    var themName: String {
        switch self {
        case .device:
            "System"
        case .light:
            "Light"
        case .dark:
            "Dark"
        }
    }
    
    var icon: String {
        switch self {
        case .device:
            "gearshape.circle"
        case .light:
             "sun.max.circle"
        case .dark:
            "moon.circle"
        }
    }
    
    init(isDarkModeOn: Bool?) {
        switch isDarkModeOn {
        case true: self = .dark
        case false: self = .light
        default: self = .device
        }
    }
    
    var id: String{ rawValue}
}
