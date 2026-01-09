//
//  LocalState.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import Foundation
import SwiftUI

enum Keys: String{
    case theme
    case isDarkModeOn
}

public class LocalState {
    @AppStorage(Keys.isDarkModeOn.rawValue) static var isDarkModeOn: String?
}
