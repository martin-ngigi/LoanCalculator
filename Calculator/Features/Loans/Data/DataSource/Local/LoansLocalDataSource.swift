//
//  LoansLocalDataSource.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import Foundation

struct LoansLocalDataSource {
    
    func saveLoansToLocal(loans: [Loan]) {
        let key = "userLoans"
        var currentLoans: [Loan] = []

        // 1. Load existing loans
        if let data = UserDefaults.standard.data(forKey: key),
           let savedLoans = try? JSONDecoder().decode([Loan].self, from: data) {
            currentLoans = savedLoans
        }

        // 2. Insert or update
        for newLoan in loans {
            if let index = currentLoans.firstIndex(where: { $0.id == newLoan.id }) {
                // Update existing loan
                currentLoans[index] = newLoan
            } else {
                // Insert new loan
                currentLoans.append(newLoan)
            }
        }

        // 3. Save back
        guard let encodedData = try? JSONEncoder().encode(currentLoans) else {
            print("DEBUG: Failed to encode loans")
            return
        }

        UserDefaults.standard.setValue(encodedData, forKey: key)
        print("DEBUG: saveLoansToLocal saved loans: \(currentLoans)")
    }

    func fetchLocalAccounts() -> [Loan]? {
        let key = "userLoans"
        let dummyLoans = DummyLoansData.shared.dummyLoans

        guard let savedData = UserDefaults.standard.data(forKey: key) else {
            return nil
        }

        print("DEBUG: fetchLocalAccounts savedData \(savedData)")

        guard let decodedAccounts = try? JSONDecoder().decode([Loan].self, from: savedData) else {
            return nil
        }

        print("DEBUG: fetchLocalAccounts decodedAccounts \(decodedAccounts)")
        
        let sortedDecodedAccounts = decodedAccounts.sorted {
            $0.createdDate > $1.createdDate
        }

        // decodedAccounts FIRST, then dummy loans
        //return sortedDecodedAccounts + dummyLoans
        return sortedDecodedAccounts
    }

    
    func fetchLocalAccountsOnly() -> [Loan]? {
        if let savedData = UserDefaults.standard.data(forKey: "userLoans") {
            
            print("DEBUG: saveLoansToLocal savedData  \(savedData) ")
            
            if let decodedAccounts = try? JSONDecoder().decode([Loan].self, from: savedData) {
                print("DEBUG: saveLoansToLocal savedData decodedAccounts  \(decodedAccounts) ")
                return decodedAccounts
            }
        }
        return nil
    }
    
    
    func clearAccountsFromLocal() {
        UserDefaults.standard.removeObject(forKey: "userLoans")
        print("DEBUG: saveLoansToLocal userLoans from UserDefaults.")
    }
}
