//
//  LoansUsecases.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import Foundation

struct LoansUsecases{
    let saveLoansToLocalDataSourceRepository: SaveLoansToLocalDataSourceRepositoryProtocol
    let clearLoansLocalInDataSourceRepository: ClearLoansLocalInDataSourceRepositoryProtocol
    let fetchLoansFromLocalDataSourceRepository: FetchLoansFromLocalDataSourceRepositoryProtocol
    
    
    init(
        saveLoansToLocalDataSourceRepository: SaveLoansToLocalDataSourceRepositoryProtocol,
        clearLoansLocalInDataSourceRepository: ClearLoansLocalInDataSourceRepositoryProtocol,
        fetchLoansFromLocalDataSourceRepository: FetchLoansFromLocalDataSourceRepositoryProtocol
    ) {
        self.saveLoansToLocalDataSourceRepository = saveLoansToLocalDataSourceRepository
        self.clearLoansLocalInDataSourceRepository = clearLoansLocalInDataSourceRepository
        self.fetchLoansFromLocalDataSourceRepository = fetchLoansFromLocalDataSourceRepository
    }
    
    func executeSaveLoansToLocal(loans: [Loan]) {
        saveLoansToLocalDataSourceRepository.saveLoansToLocal(loans: loans)
    }
    
    func executeFetchLocalAccounts() -> [Loan]? {
        return fetchLoansFromLocalDataSourceRepository.fetchLocalAccounts()
    }
    
    func executeClearAccountsFromLocal(){
        clearLoansLocalInDataSourceRepository.clearAccountsFromLocal()
    }
}
