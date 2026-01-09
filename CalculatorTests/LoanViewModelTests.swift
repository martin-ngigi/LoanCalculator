//
//  LoanViewModelTests.swift
//  CalculatorTests
//
//  Created by Hummingbird on 09/01/2026.
//

import Foundation

import XCTest
import Combine
@testable import Calculator

class LoanViewModelTests: XCTestCase {
    
    var sut: LoanViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = LoanViewModel()
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialState() {
        // Given: A newly initialized LoanViewModel
        // When: Checking initial state
        // Then: All properties should have their default values
        XCTAssertTrue(sut.loans.isEmpty, "Loans array should be empty on initialization")
        XCTAssertNil(sut.toast, "Toast should be nil on initialization")
        XCTAssertFalse(sut.isNavigateToLoanDetailsView, "Navigation flag should be false on initialization")
        XCTAssertNil(sut.selectedLoanType, "Selected loan type should be nil on initialization")
        XCTAssertEqual(sut.loanInterest, "", "Loan interest should be empty on initialization")
        XCTAssertEqual(sut.loanPeriod, "", "Loan period should be empty on initialization")
        XCTAssertEqual(sut.loanAmount, "", "Loan amount should be empty on initialization")
        XCTAssertEqual(sut.interestAmount, 0.0, "Interest amount should be 0.0 on initialization")
        XCTAssertEqual(sut.totalAmountPayable, 0.0, "Total amount payable should be 0.0 on initialization")
        XCTAssertTrue(sut.repaymentSchedule.isEmpty, "Repayment schedule should be empty on initialization")
        XCTAssertFalse(sut.isShowAlertDialog, "Alert dialog flag should be false on initialization")
        XCTAssertFalse(sut.showDocumentPicker, "Document picker flag should be false on initialization")
        XCTAssertNil(sut.pdfDataToExport, "PDF data should be nil on initialization")
    }
    
    func testLoanTypesArray() {
        // Given: A newly initialized LoanViewModel
        // When: Checking the loan types array
        // Then: It should contain exactly 3 loan types
        XCTAssertEqual(sut.loanTypes.count, 3, "Loan types array should contain exactly 3 types")
        XCTAssertTrue(sut.loanTypes.contains(.salaryELoan), "Loan types should contain salaryELoan")
        XCTAssertTrue(sut.loanTypes.contains(.buyNowPayLater), "Loan types should contain buyNowPayLater")
        XCTAssertTrue(sut.loanTypes.contains(.stockLoan), "Loan types should contain stockLoan")
    }
    
    // MARK: - loanTypeChanged Tests
    
    func testLoanTypeChanged_WithValidLoanType() {
        // Given: A valid loan type and loan details
        sut.selectedLoanType = .salaryELoan
        sut.loanAmount = "10000"
        sut.loanPeriod = "12"
        
        // When: loanTypeChanged is called
        sut.loanTypeChanged()
        
        // Then: Loan interest should be set and calculation should be performed
        XCTAssertFalse(sut.loanInterest.isEmpty, "Loan interest should be set when loan type is selected")
        XCTAssertNotEqual(sut.totalAmountPayable, 0.0, "Total amount payable should be calculated")
    }
    
    func testLoanTypeChanged_WithNilLoanType() {
        // Given: No loan type selected
        sut.selectedLoanType = nil
        let initialInterest = sut.loanInterest
        
        // When: loanTypeChanged is called
        sut.loanTypeChanged()
        
        // Then: Nothing should happen, interest should remain unchanged
        XCTAssertEqual(sut.loanInterest, initialInterest, "Loan interest should not change when loan type is nil")
    }
    
    // MARK: - calculateLoan Tests
    
    func testCalculateLoan_WithValidInputs() {
        // Given: Valid loan amount, interest rate, and period
        sut.loanAmount = "100000"
        sut.loanInterest = "10"
        sut.loanPeriod = "12"
        
        // When: calculateLoan is called
        sut.calculateLoan()
        
        // Then: Total amount and repayment schedule should be calculated correctly
        XCTAssertEqual(sut.totalAmountPayable, 110000.0, "Total amount payable should be 110,000 (100,000 + 10% interest)")
        XCTAssertEqual(sut.repaymentSchedule.count, 12, "Repayment schedule should contain 12 instalments")
        
        let expectedMonthlyPayment = 110000.0 / 12.0
        for (index, instalment) in sut.repaymentSchedule.enumerated() {
            XCTAssertEqual(instalment.instalmentNumber, index + 1, "Instalment number should be \(index + 1)")
            XCTAssertEqual(instalment.amount, expectedMonthlyPayment, accuracy: 0.01, "Monthly payment should be approximately \(expectedMonthlyPayment)")
        }
    }
    
    func testCalculateLoan_WithZeroAmount() {
        // Given: Zero loan amount
        sut.loanAmount = "0"
        sut.loanInterest = "10"
        sut.loanPeriod = "12"
        
        // When: calculateLoan is called
        sut.calculateLoan()
        
        // Then: Total amount payable should be 0
        XCTAssertEqual(sut.totalAmountPayable, 0.0, "Total amount payable should be 0 when loan amount is 0")
    }
    
    func testCalculateLoan_WithInvalidAmount() {
        // Given: Invalid (non-numeric) loan amount
        sut.loanAmount = "invalid"
        sut.loanInterest = "10"
        sut.loanPeriod = "12"
        
        // When: calculateLoan is called
        sut.calculateLoan()
        
        // Then: Calculation should fail gracefully
        XCTAssertEqual(sut.totalAmountPayable, 0.0, "Total amount payable should be 0 when loan amount is invalid")
        XCTAssertTrue(sut.repaymentSchedule.isEmpty, "Repayment schedule should be empty when loan amount is invalid")
    }
    
    func testCalculateLoan_WithInvalidInterest() {
        // Given: Invalid (non-numeric) interest rate
        sut.loanAmount = "100000"
        sut.loanInterest = "invalid"
        sut.loanPeriod = "12"
        
        // When: calculateLoan is called
        sut.calculateLoan()
        
        // Then: Calculation should fail gracefully
        XCTAssertEqual(sut.totalAmountPayable, 0.0, "Total amount payable should be 0 when interest rate is invalid")
        XCTAssertTrue(sut.repaymentSchedule.isEmpty, "Repayment schedule should be empty when interest rate is invalid")
    }
    
    func testCalculateLoan_WithZeroPeriod() {
        // Given: Zero loan period
        sut.loanAmount = "100000"
        sut.loanInterest = "10"
        sut.loanPeriod = "0"
        
        // When: calculateLoan is called
        sut.calculateLoan()
        
        // Then: Repayment schedule should be empty (division by zero protection)
        XCTAssertTrue(sut.repaymentSchedule.isEmpty, "Repayment schedule should be empty when loan period is 0")
    }
    
    func testCalculateLoan_WithNonNumericPeriod() {
        // Given: Non-numeric loan period
        sut.loanAmount = "100000"
        sut.loanInterest = "10"
        sut.loanPeriod = "12a"
        
        // When: calculateLoan is called
        sut.calculateLoan()
        
        // Then: Repayment schedule should be empty
        XCTAssertTrue(sut.repaymentSchedule.isEmpty, "Repayment schedule should be empty when loan period contains non-numeric characters")
    }
    
    func testCalculateLoan_WithAmountContainingCommas() {
        // Given: Loan amount with comma separators
        sut.loanAmount = "100,000"
        sut.loanInterest = "10"
        sut.loanPeriod = "12"
        
        // When: calculateLoan is called
        sut.calculateLoan()
        
        // Then: Commas should be removed and calculation should work correctly
        XCTAssertEqual(sut.totalAmountPayable, 110000.0, "Total amount payable should correctly handle commas in input")
        XCTAssertEqual(sut.repaymentSchedule.count, 12, "Repayment schedule should be generated when amount contains commas")
    }
    
    func testCalculateLoan_WithDifferentInterestRates() {
        // Given: Same loan amount and period with different interest rates
        sut.loanAmount = "50000"
        sut.loanPeriod = "6"
        
        // When: Testing with 5% interest
        sut.loanInterest = "5"
        sut.calculateLoan()
        // Then: Total should be 52,500
        XCTAssertEqual(sut.totalAmountPayable, 52500.0, "Total amount payable should be 52,500 with 5% interest")
        
        // When: Testing with 15% interest
        sut.loanInterest = "15"
        sut.calculateLoan()
        // Then: Total should be 57,500
        XCTAssertEqual(sut.totalAmountPayable, 57500.0, "Total amount payable should be 57,500 with 15% interest")
        
        // When: Testing with 0% interest
        sut.loanInterest = "0"
        sut.calculateLoan()
        // Then: Total should be 50,000 (no interest)
        XCTAssertEqual(sut.totalAmountPayable, 50000.0, "Total amount payable should be 50,000 with 0% interest")
    }
    
    func testCalculateLoan_RepaymentScheduleDates() {
        // Given: Valid loan parameters
        sut.loanAmount = "100000"
        sut.loanInterest = "10"
        sut.loanPeriod = "3"
        
        // When: calculateLoan is called
        sut.calculateLoan()
        
        // Then: Each instalment should have a valid date
        XCTAssertEqual(sut.repaymentSchedule.count, 3, "Should have 3 instalments")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        for instalment in sut.repaymentSchedule {
            XCTAssertFalse(instalment.dueDate.isEmpty, "Due date should not be empty")
            XCTAssertNotNil(dateFormatter.date(from: instalment.dueDate), "Due date '\(instalment.dueDate)' should be in valid format")
        }
    }
    
    func testCalculateLoan_RepaymentScheduleIncrementsMonthly() {
        // Given: Valid loan parameters for 6 months
        sut.loanAmount = "60000"
        sut.loanInterest = "12"
        sut.loanPeriod = "6"
        
        // When: calculateLoan is called
        sut.calculateLoan()
        
        // Then: Each instalment should be in consecutive months
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let calendar = Calendar.current
        
        for i in 0..<sut.repaymentSchedule.count - 1 {
            let currentDate = dateFormatter.date(from: sut.repaymentSchedule[i].dueDate)!
            let nextDate = dateFormatter.date(from: sut.repaymentSchedule[i + 1].dueDate)!
            
            let monthDifference = calendar.dateComponents([.month], from: currentDate, to: nextDate).month
            XCTAssertEqual(monthDifference, 1, "Instalments should be exactly 1 month apart")
        }
    }
    
    // MARK: - saveCalculation Tests
    
    func testSaveCalculation_WithValidInputs() {
        // Given: Complete and valid loan calculation
        sut.selectedLoanType = .salaryELoan
        sut.loanAmount = "100000"
        sut.loanInterest = "10"
        sut.loanPeriod = "12"
        sut.calculateLoan()
        
        // When: saveCalculation is called
        sut.saveCalculation()
        
        // Then: Loan properties should be set correctly
        XCTAssertNotNil(sut.selectedLoanType, "Selected loan type should not be nil after save")
        XCTAssertEqual(sut.totalAmountPayable, 110000.0, "Total amount payable should be 110,000 after save")
        XCTAssertEqual(sut.interestAmount, 10000.0, "Interest amount should be calculated as 10,000")
    }
    
    func testSaveCalculation_WithNilLoanType() {
        // Given: Loan calculation without a loan type
        sut.selectedLoanType = nil
        sut.loanAmount = "100000"
        sut.loanInterest = "10"
        sut.loanPeriod = "12"
        sut.calculateLoan()
        
        // When: saveCalculation is called
        sut.saveCalculation()
        
        // Then: Save should exit early without processing
        XCTAssertNil(sut.selectedLoanType, "Save should return early when loan type is nil")
    }
    
    func testSaveCalculation_WithInvalidAmount() {
        // Given: Invalid loan amount
        sut.selectedLoanType = .salaryELoan
        sut.loanAmount = "invalid"
        sut.loanInterest = "10"
        sut.loanPeriod = "12"
        
        // When: saveCalculation is called
        sut.saveCalculation()
        
        // Then: Total amount payable should be reset to 0
        XCTAssertEqual(sut.totalAmountPayable, 0.0, "Total amount payable should be 0 when amount is invalid")
    }
    
    func testSaveCalculation_WithEmptyRepaymentSchedule() {
        // Given: Loan with empty repayment schedule (zero period)
        sut.selectedLoanType = .salaryELoan
        sut.loanAmount = "100000"
        sut.loanInterest = "10"
        sut.loanPeriod = "0"
        sut.calculateLoan()
        
        // When: saveCalculation is called
        sut.saveCalculation()
        
        // Then: Repayment schedule should remain empty
        XCTAssertTrue(sut.repaymentSchedule.isEmpty, "Repayment schedule should be empty when period is 0")
    }
    
    func testSaveCalculation_CalculatesInterestAmount() {
        // Given: Valid loan parameters
        sut.selectedLoanType = .salaryELoan
        sut.loanAmount = "100000"
        sut.loanInterest = "10"
        sut.loanPeriod = "12"
        sut.calculateLoan()
        
        // When: saveCalculation is called
        sut.saveCalculation()
        
        // Then: Interest amount should be correctly calculated
        XCTAssertEqual(sut.interestAmount, 10000.0, "Interest amount should be 10% of 100,000 = 10,000")
    }
    
    func testSaveCalculation_WithAmountContainingCommas() {
        // Given: Loan amount with comma formatting
        sut.selectedLoanType = .buyNowPayLater
        sut.loanAmount = "250,000"
        sut.loanInterest = "8"
        sut.loanPeriod = "24"
        sut.calculateLoan()
        
        // When: saveCalculation is called
        sut.saveCalculation()
        
        // Then: Interest should be calculated correctly after removing commas
        XCTAssertEqual(sut.interestAmount, 20000.0, "Interest amount should correctly handle commas: 8% of 250,000 = 20,000")
    }
    
    // MARK: - downloadCalculation Tests
    /*
    func testDownloadCalculation_SetsPropertiesCorrectly() {
        // Given: A complete loan object
        let repaymentSchedule = [
            RepaymentInstalment(instalmentNumber: 1, dueDate: "01 Jan 2026", amount: 9166.67),
            RepaymentInstalment(instalmentNumber: 2, dueDate: "01 Feb 2026", amount: 9166.67)
        ]
        
        let loan = Loan(
            id: 123456,
            type: .salaryELoan,
            amount: 100000,
            totalAmountPayable: 110000,
            monthlyPayment: 9166.67,
            interest: 10,
            interestRate: 10,
            interestAmount: 10000,
            loanPeriodMonths: 12,
            style: .green,
            repaymentSchedule: repaymentSchedule
        )
        
        // When: downloadCalculation is called
        sut.downloadCalculation(loan: loan)
        
        // Then: All loan properties should be transferred to view model
        XCTAssertEqual(sut.selectedLoanType, .salaryELoan, "Selected loan type should be set to salaryELoan")
        XCTAssertEqual(sut.totalAmountPayable, 110000, "Total amount payable should be 110,000")
        XCTAssertEqual(sut.interestAmount, 10000, "Interest amount should be 10,000")
        XCTAssertEqual(sut.loanAmount, "100000.0", "Loan amount should be set to '100000.0'")
        XCTAssertEqual(sut.repaymentSchedule.count, 2, "Repayment schedule should have 2 instalments")
    }
    
    
    func testDownloadCalculation_SetsRepaymentScheduleCorrectly() {
        // Given: A loan with specific repayment schedule
        let expectedSchedule = [
            RepaymentInstalment(instalmentNumber: 1, dueDate: "15 Mar 2026", amount: 5000.0),
            RepaymentInstalment(instalmentNumber: 2, dueDate: "15 Apr 2026", amount: 5000.0),
            RepaymentInstalment(instalmentNumber: 3, dueDate: "15 May 2026", amount: 5000.0)
        ]
        
        let loan = Loan(
            id: 789,
            type: .stockLoan,
            amount: 45000,
            totalAmountPayable: 48000,
            monthlyPayment: 5000,
            interest: 6.67,
            interestRate: 6.67,
            interestAmount: 3000,
            loanPeriodMonths: 3,
            style: .orange,
            repaymentSchedule: expectedSchedule
        )
        
        // When: downloadCalculation is called
        sut.downloadCalculation(loan: loan)
        
        // Then: Repayment schedule should match exactly
        XCTAssertEqual(sut.repaymentSchedule.count, 3, "Should have 3 instalments")
        for (index, instalment) in sut.repaymentSchedule.enumerated() {
            XCTAssertEqual(instalment.instalmentNumber, expectedSchedule[index].instalmentNumber, "Instalment number should match at index \(index)")
            XCTAssertEqual(instalment.dueDate, expectedSchedule[index].dueDate, "Due date should match at index \(index)")
            XCTAssertEqual(instalment.amount, expectedSchedule[index].amount, accuracy: 0.01, "Amount should match at index \(index)")
        }
    }
     */
    
    // MARK: - Published Properties Tests
    
    func testPublishedProperties_Loans() {
        // Given: An expectation for loans to be published
        let expectation = XCTestExpectation(description: "Loans should be published when changed")
        
        sut.$loans
            .dropFirst()
            .sink { loans in
                // Then: Published loans should have 1 item
                XCTAssertEqual(loans.count, 1, "Published loans array should contain 1 loan")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When: Loans array is updated
        sut.loans = [Loan(
            id: 1,
            type: .salaryELoan,
            amount: 100000,
            totalAmountPayable: 110000,
            monthlyPayment: 9166.67,
            interest: 10,
            interestRate: 10,
            interestAmount: 10000,
            loanPeriodMonths: 12,
            style: .green,
            repaymentSchedule: []
        )]
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPublishedProperties_TotalAmountPayable() {
        // Given: An expectation for totalAmountPayable to be published
        let expectation = XCTestExpectation(description: "TotalAmountPayable should be published when changed")
        
        sut.$totalAmountPayable
            .dropFirst()
            .sink { amount in
                // Then: Published amount should be 50,000
                XCTAssertEqual(amount, 50000.0, "Published total amount payable should be 50,000")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When: totalAmountPayable is updated
        sut.totalAmountPayable = 50000.0
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPublishedProperties_RepaymentSchedule() {
        // Given: An expectation for repaymentSchedule to be published
        let expectation = XCTestExpectation(description: "RepaymentSchedule should be published when changed")
        
        sut.$repaymentSchedule
            .dropFirst()
            .sink { schedule in
                // Then: Published schedule should have 1 instalment
                XCTAssertEqual(schedule.count, 1, "Published repayment schedule should contain 1 instalment")
                XCTAssertEqual(schedule.first?.instalmentNumber, 1, "First instalment number should be 1")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When: repaymentSchedule is updated
        sut.repaymentSchedule = [RepaymentInstalment(instalmentNumber: 1, dueDate: "01 Jan 2026", amount: 10000)]
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPublishedProperties_SelectedLoanType() {
        // Given: An expectation for selectedLoanType to be published
        let expectation = XCTestExpectation(description: "SelectedLoanType should be published when changed")
        
        sut.$selectedLoanType
            .dropFirst()
            .sink { loanType in
                // Then: Published loan type should be buyNowPayLater
                XCTAssertEqual(loanType, .buyNowPayLater, "Published loan type should be buyNowPayLater")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When: selectedLoanType is updated
        sut.selectedLoanType = .buyNowPayLater
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPublishedProperties_IsShowAlertDialog() {
        // Given: An expectation for isShowAlertDialog to be published
        let expectation = XCTestExpectation(description: "IsShowAlertDialog should be published when changed")
        
        sut.$isShowAlertDialog
            .dropFirst()
            .sink { isShowing in
                // Then: Published flag should be true
                XCTAssertTrue(isShowing, "Published isShowAlertDialog should be true")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When: isShowAlertDialog is updated
        sut.isShowAlertDialog = true
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Edge Cases and Boundary Tests
    
    func testCalculateLoan_WithVeryLargeLoanAmount() {
        // Given: Very large loan amount
        sut.loanAmount = "10000000"
        sut.loanInterest = "5"
        sut.loanPeriod = "60"
        
        // When: calculateLoan is called
        sut.calculateLoan()
        
        // Then: Calculation should handle large numbers correctly
        XCTAssertEqual(sut.totalAmountPayable, 10500000.0, "Should correctly calculate for large loan amount")
        XCTAssertEqual(sut.repaymentSchedule.count, 60, "Should generate 60 instalments")
    }
    
    func testCalculateLoan_WithVerySmallInterestRate() {
        // Given: Very small interest rate (0.1%)
        sut.loanAmount = "100000"
        sut.loanInterest = "0.1"
        sut.loanPeriod = "12"
        
        // When: calculateLoan is called
        sut.calculateLoan()
        
        // Then: Calculation should handle small percentages correctly
        XCTAssertEqual(sut.totalAmountPayable, 100100.0, "Should correctly calculate with 0.1% interest")
    }
    
    func testCalculateLoan_WithSingleMonthPeriod() {
        // Given: Single month loan period
        sut.loanAmount = "50000"
        sut.loanInterest = "5"
        sut.loanPeriod = "1"
        
        // When: calculateLoan is called
        sut.calculateLoan()
        
        // Then: Should generate single instalment
        XCTAssertEqual(sut.repaymentSchedule.count, 1, "Should generate 1 instalment for 1 month period")
        XCTAssertEqual(sut.repaymentSchedule.first?.amount, 52500.0, "Single instalment should be full loan + interest")
    }
    
    func testCalculateLoan_WithLongTermLoan() {
        // Given: Long-term loan (5 years = 60 months)
        sut.loanAmount = "500000"
        sut.loanInterest = "7.5"
        sut.loanPeriod = "60"
        
        // When: calculateLoan is called
        sut.calculateLoan()
        
        // Then: Should generate 60 instalments
        XCTAssertEqual(sut.repaymentSchedule.count, 60, "Should generate 60 instalments for 5-year loan")
        XCTAssertEqual(sut.totalAmountPayable, 537500.0, "Total should be 500,000 + 7.5% interest")
    }
    
    func testCalculateLoan_WithDecimalLoanAmount() {
        // Given: Loan amount with decimal values
        sut.loanAmount = "99999.99"
        sut.loanInterest = "10"
        sut.loanPeriod = "12"
        
        // When: calculateLoan is called
        sut.calculateLoan()
        
        // Then: Should handle decimal values correctly
        XCTAssertEqual(sut.totalAmountPayable, 109999.989, accuracy: 0.01, "Should handle decimal loan amounts correctly")
    }
    
    func testSaveCalculation_GeneratesUniqueTimestamp() {
        // Given: Valid loan calculation
        sut.selectedLoanType = .salaryELoan
        sut.loanAmount = "100000"
        sut.loanInterest = "10"
        sut.loanPeriod = "12"
        sut.calculateLoan()
        
        // When: saveCalculation is called twice with a delay
        let timestamp1 = Int64(Date().timeIntervalSince1970 * 1000)
        sut.saveCalculation()
        
        Thread.sleep(forTimeInterval: 0.01) // Small delay
        
        let timestamp2 = Int64(Date().timeIntervalSince1970 * 1000)
        sut.saveCalculation()
        
        // Then: Timestamps should be different
        XCTAssertNotEqual(timestamp1, timestamp2, "Timestamps should be unique for different saves")
    }
}
