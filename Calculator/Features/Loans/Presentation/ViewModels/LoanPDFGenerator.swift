//
//  LoanPDFGenerator.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import Foundation
import Combine
import PDFKit
import UIKit
import SwiftUI

// MARK: - PDF Generator
class LoanPDFGenerator {
    let viewModel: LoanViewModel
    
    init(viewModel: LoanViewModel) {
        self.viewModel = viewModel
    }
    
    func generatePDFData() -> Data? {
        let pdfMetaData = [
            kCGPDFContextCreator: "Co-op Bank Loan Calculator",
            kCGPDFContextAuthor: "Co-op Bank",
            kCGPDFContextTitle: "Loan Calculation Receipt"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            drawPDFContent(in: pageRect)
        }
        
        return data
    }
    
    func drawPDFContent(in pageRect: CGRect) {
        let margin: CGFloat = 40
        var currentY: CGFloat = margin
        
        // Draw Header Background
        let headerRect = CGRect(x: 0, y: 0, width: pageRect.width, height: 140)
        UIColor(red: 0.05, green: 0.25, blue: 0.15, alpha: 1.0).setFill()
        UIBezierPath(rect: headerRect).fill()
        
        // Draw Co-op Bank Logo Text (simplified)
        let logoText = "co-opbank"
        let logoAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 24),
            .foregroundColor: UIColor.white
        ]
        let logoSize = logoText.size(withAttributes: logoAttributes)
        logoText.draw(at: CGPoint(x: margin, y: 40), withAttributes: logoAttributes)
        
        // Draw Transaction Advice
        let adviceText = "Transaction Advice"
        let adviceAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor(red: 0.6, green: 0.8, blue: 0.2, alpha: 1.0)
        ]
        adviceText.draw(at: CGPoint(x: margin + 150, y: 45), withAttributes: adviceAttributes)
        
        let thankYouText = "Thank you for banking with us"
        let thankYouAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.white.withAlphaComponent(0.9)
        ]
        thankYouText.draw(at: CGPoint(x: margin + 150, y: 75), withAttributes: thankYouAttributes)
        
        currentY = 160
        
        // Success Section
        drawCenteredText("Success", at: &currentY, fontSize: 28, bold: true, color: .darkGray)
        currentY += 10
        
        // Loan Type
        drawCenteredText(viewModel.selectedLoanType?.title ?? "Co-op Loan", at: &currentY, fontSize: 18, bold: true, color: .black)
        currentY += 25
        
        // Amount
        let amountText = formatCurrency(viewModel.totalAmountPayable) + " KES"
        drawCenteredText(amountText, at: &currentY, fontSize: 32, bold: true, color: UIColor(red: 0.6, green: 0.8, blue: 0.2, alpha: 1.0))
        currentY += 10
        
        let paymentLabel = "\(viewModel.selectedLoanType?.title ?? "Loan") Calculation"
        drawCenteredText(paymentLabel, at: &currentY, fontSize: 16, bold: false, color: .darkGray)
        currentY += 40
        
        // Loan Details Section
        drawLabelValue("Loan Interest (%):", value: "\(Int(viewModel.selectedLoanType?.interestRate ?? 0))%", at: &currentY, leftMargin: margin)
        drawLabelValue("Interest:", value: "\(formatCurrency(viewModel.interestAmount)) KES", at: &currentY, leftMargin: margin)
        drawLabelValue("Loan Amount:", value: "\(formatCurrency(Double(viewModel.loanAmount.replacingOccurrences(of: ",", with: "")) ?? 0)) KES", at: &currentY, leftMargin: margin)
        drawLabelValue("Loan Period (months):", value: "\(viewModel.selectedLoanType?.title ?? "--") Months", at: &currentY, leftMargin: margin)
        
        currentY += 20
        
        // Transaction Reference Section
        drawSectionHeader("Transaction Reference", at: &currentY, leftMargin: margin)
        
        let transactionRef = generateTransactionRef()
        let currentDate = formatDate(Date())
        let currentTime = formatTime(Date())
        
        drawLabelValue("Transaction Ref:", value: transactionRef, at: &currentY, leftMargin: margin)
        drawLabelValue("Date:", value: currentDate, at: &currentY, leftMargin: margin)
        drawLabelValue("Time:", value: currentTime, at: &currentY, leftMargin: margin)
        
        currentY += 20
        
        // Repayment Schedule
        drawSectionHeader("Repayment Schedule", at: &currentY, leftMargin: margin)
        
        for instalment in viewModel.repaymentSchedule {
            let instalmentText = "\(ordinal(instalment.instalmentNumber)) instalment - \(instalment.dueDate)"
            drawLabelValue(instalmentText, value: "\(formatCurrency(instalment.amount)) KES", at: &currentY, leftMargin: margin)
        }
        
        currentY += 30
        
        // Note Section
        let noteRect = CGRect(x: margin, y: currentY, width: pageRect.width - (2 * margin), height: 60)
        UIColor(red: 0.9, green: 0.95, blue: 0.9, alpha: 1.0).setFill()
        UIBezierPath(rect: noteRect).fill()
        
        // Left border for note
        let borderRect = CGRect(x: margin, y: currentY, width: 4, height: 60)
        UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1.0).setFill()
        UIBezierPath(rect: borderRect).fill()
        
        let noteTitle = "Note:"
        let noteTitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor: UIColor.darkGray
        ]
        noteTitle.draw(at: CGPoint(x: margin + 15, y: currentY + 10), withAttributes: noteTitleAttributes)
        
        let noteText = "This document is computer generated and therefore not signed."
        let noteAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11),
            .foregroundColor: UIColor.darkGray
        ]
        let noteTextRect = CGRect(x: margin + 15, y: currentY + 28, width: pageRect.width - (2 * margin) - 30, height: 25)
        noteText.draw(in: noteTextRect, withAttributes: noteAttributes)
    }
    
    func drawCenteredText(_ text: String, at currentY: inout CGFloat, fontSize: CGFloat, bold: Bool, color: UIColor) {
        let font = bold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color
        ]
        let textSize = text.size(withAttributes: attributes)
        let x = (8.5 * 72.0 - textSize.width) / 2
        text.draw(at: CGPoint(x: x, y: currentY), withAttributes: attributes)
        currentY += textSize.height + 10
    }
    
    func drawSectionHeader(_ text: String, at currentY: inout CGFloat, leftMargin: CGFloat) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ]
        text.draw(at: CGPoint(x: leftMargin, y: currentY), withAttributes: attributes)
        currentY += 30
    }
    
    func drawLabelValue(_ label: String, value: String, at currentY: inout CGFloat, leftMargin: CGFloat) {
        let labelAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor.gray
        ]
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor.darkGray
        ]
        
        label.draw(at: CGPoint(x: leftMargin, y: currentY), withAttributes: labelAttributes)
        
        let valueSize = value.size(withAttributes: valueAttributes)
        let rightMargin = 8.5 * 72.0 - 40
        value.draw(at: CGPoint(x: rightMargin - valueSize.width, y: currentY), withAttributes: valueAttributes)
        
        currentY += 25
    }
    
    func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: amount)) ?? "0.00"
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss a"
        return formatter.string(from: date)
    }
    
    func generateTransactionRef() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<12).map { _ in letters.randomElement()! })
    }
    
    func ordinal(_ number: Int) -> String {
        switch number {
        case 1: return "1st"
        case 2: return "2nd"
        case 3: return "3rd"
        default: return "\(number)th"
        }
    }
}

// MARK: - Document Picker for PDF Export
struct DocumentPicker: UIViewControllerRepresentable {
    let pdfData: Data
    let fileName: String
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        // Create a temporary file
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try pdfData.write(to: tempURL)
        } catch {
            print("Error writing PDF: \(error)")
        }
        
        let picker = UIDocumentPickerViewController(forExporting: [tempURL], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
