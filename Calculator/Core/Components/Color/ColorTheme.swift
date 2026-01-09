//
//  ColorTheme.swift
//  Calculator
//
//  Created by Hummingbird on 09/01/2026.
//

import Foundation

import SwiftUI

struct ColorTheme {
    let blackAndWhite = Color("BlackAndWhite")
    let whiteAndBlack = Color("WhiteAndBlack")
    let whiteColor = Color("AppWhiteColor")
    let blackColor = Color("AppBlackColor")
    let lightBlueColor = Color("AppLightBlueColor")
    let darkBlueColor = Color("AppDarkBlueColor")
    let darkGreenColor = Color("AppDarkGreenColor")
    let lightGreenColor = Color("AppLightGreenColor")
    let grayColor1 = Color("AppGrayColor1")
    let grayColor3 = Color("AppGrayColor3")
    let grayColor4 = Color("AppGrayColor4")
    let grayColor5 = Color("AppGrayColor5")
    let greenColor = Color("AppGreenColor")
    let greenColor5 = Color("AppGreenColor5")
    let greenColor6 = Color("AppGreenColor6")
    let greenColor1 = Color("AppGreenColor1")
    let blackColor1 = Color("AppBlackColor1")
    let darkOrangeColor = Color("AppDarkOrangeColor")
    let lightOrangeColor = Color("AppLightOrangeColor")
}

extension Color {
    static var theme = ColorTheme()
}

