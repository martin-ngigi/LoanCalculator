//
//  View.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import SwiftUI

extension View {
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func customToolbar(
        title: String,
        backIcon: String = "arrow.left",
        dismissIcon: String = "xmark",
        backAction: @escaping () -> Void,
        dismissAction: @escaping () -> Void
    ) -> some View {
        self.modifier(
            CustomToolbar(
                title: title,
                backIcon: backIcon,
                dismissIcon: dismissIcon,
                backAction: backAction,
                dismissAction: dismissAction
            )
        )
    }
    
    // Dismiss keyboard
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
    
    @ViewBuilder
    func conditionalPresentationDetents(
        minOSVersion: Double = 16.0,
        fraction: CGFloat = 0.6
    ) -> some View {
        let majorVersion = Int(minOSVersion)
        let minorVersion = Int((minOSVersion * 10).truncatingRemainder(dividingBy: 10))
        
        if ProcessInfo.processInfo.isOperatingSystemAtLeast(
            OperatingSystemVersion(majorVersion: majorVersion, minorVersion: minorVersion, patchVersion: 0)
        ) {
            if #available(iOS 16.0, *) {
                self.presentationDetents([.fraction(fraction)])
                    //.presentationDragIndicator(.visible)
                
            } else {
                self
            }
        } else {
            self
        }
    }
    
    
}
