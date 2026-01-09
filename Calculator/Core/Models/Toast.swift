//
//  Toast.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import Foundation

struct Toast: Equatable {
    var style: ToastStyle
    var title: String
    var message: String
    var duration: Double = 4
    var width: Double = .infinity
}
