//
//  LoansRepository.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import Foundation

struct LoansRepository: SaveLoansToLocalDataSourceRepositoryProtocol, FetchLoansFromLocalDataSourceRepositoryProtocol, ClearLoansLocalInDataSourceRepositoryProtocol{
    
    static let shared = LoansRepository()
    let loansLocalDataSource = LoansLocalDataSource()
    
    func saveLoansToLocal(loans: [Loan]) {
        loansLocalDataSource.saveLoansToLocal(loans: loans)
    }
    
    func fetchLocalAccounts() -> [Loan]? {
        return loansLocalDataSource.fetchLocalAccounts()
    }
    
    func clearAccountsFromLocal(){
        loansLocalDataSource.clearAccountsFromLocal()
    }
    
}
