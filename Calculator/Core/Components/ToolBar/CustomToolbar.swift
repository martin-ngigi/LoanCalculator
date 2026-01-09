//
//  CustomToolbar.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import Foundation
import SwiftUI

struct CustomToolbar: ViewModifier {
    let title: String
    let backIcon: String
    let dismissIcon: String
    let backAction: () -> Void
    let dismissAction: () -> Void
    var foregroundColor: Color = Color.white

    func body(content: Content) -> some View {
        
        if #available(iOS 26.0, *) {
            content
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Group{
                            if !backIcon.isEmpty{
                                Button(action: backAction) {
                                    Image(systemName: backIcon)
                                        .foregroundColor(foregroundColor)
                                        .padding(.leading, 10)
                                        .padding(.trailing, 20)
                                        .padding(.vertical, 30)
                                }
                            }
                        }
                    }
                    .sharedBackgroundVisibility(.hidden)
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Group{
                            if !dismissIcon.isEmpty {
                                Button(action: dismissAction) {
                                    Image(systemName: dismissIcon)
                                        .foregroundColor(foregroundColor)
                                        .padding(.leading, 20)
                                        .padding(.trailing, 10)
                                        .padding(.vertical, 20)
                                }
                            }
                        }
                    }
                    .sharedBackgroundVisibility(.hidden)

                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        
                        Button {
                            UIApplication.shared.sendAction(
                                #selector(UIResponder.resignFirstResponder),
                                to: nil,
                                from: nil,
                                for: nil
                            )

                        } label: {
                            Text("Done")
                                .font(.headline)
                                .foregroundColor(Color.theme.greenColor)
                        }
                        .buttonStyle(.plain)
                        .frame(minWidth: 44, minHeight: 44)
                    }
                    
                }
        }
        else {
            content
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Group{
                            if !backIcon.isEmpty{
                                Button(action: backAction) {
                                    Image(systemName: backIcon)
                                        .foregroundColor(foregroundColor)
                                        .padding(.leading, 10)
                                        .padding(.trailing, 20)
                                        .padding(.vertical, 30)
                                }
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Group{
                            if !dismissIcon.isEmpty{
                                Button(action: dismissAction) {
                                    Image(systemName: dismissIcon)
                                        .foregroundColor(foregroundColor)
                                        .padding(.leading, 20)
                                        .padding(.trailing, 10)
                                        .padding(.vertical, 20)
                                }
                            }
                        }
                    }

                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        
                        Button {
                            UIApplication.shared.sendAction(
                                #selector(UIResponder.resignFirstResponder),
                                to: nil,
                                from: nil,
                                for: nil
                            )
                        } label: {
                            Text("Done")
                                .font(.headline)
                                .foregroundColor(Color.theme.greenColor)
                        }
                        .buttonStyle(.plain)
                        .frame(minWidth: 44, minHeight: 44)
                    }
                }
        }

    }
}
