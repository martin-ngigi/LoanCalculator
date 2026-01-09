//
//  DialogEntity.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import Foundation

struct DialogEntity {
    let title: String
    let message: String
    let icon: String
    let confirmButtonText: String
    let dismissButtonText: String
    var onConfirm: (() -> Void)?
    var onDismiss: (() -> Void)?
    
    init(
        title: String = "",
        message: String = "",
        icon: String = "",
        confirmButtonText: String = "",
        dismissButtonText: String = "",
        onConfirm: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.confirmButtonText = confirmButtonText
        self.dismissButtonText = dismissButtonText
        self.onConfirm = onConfirm
        self.onDismiss = onDismiss
    }
}
