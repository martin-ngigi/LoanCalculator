//
//  CommonUtils.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import Foundation
import UIKit
import PDFKit

struct CommonUtils{
    static let shared = CommonUtils()
    
    func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: amount)) ?? "0.00"
    }
    
    func sharePDF(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
    
    func setUpAppNavigationHeaderImage() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundImage = UIImage(named: "Header2")

        // Regular title font
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Gilroy-Regular", size: 18)!
        ]

        // Large title font (if used)
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Gilroy-Regular", size: 34)!
        ]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}
