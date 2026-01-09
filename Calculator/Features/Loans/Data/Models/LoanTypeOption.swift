//
//  LoanTypeOption.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import Foundation

struct LoanTypeOption: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let interestRate: Double
}
