//
//  FetchLoansFromLocalDataSourceRepositoryProtocol.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import Foundation

protocol FetchLoansFromLocalDataSourceRepositoryProtocol{
    func fetchLocalAccounts() -> [Loan]?
}
