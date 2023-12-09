//
//  Color + Extension.swift
//  DriveMusic
//
//  Created by Quasar on 08.12.2023.
//
import SwiftUI

extension Color {
    init(hexValue: String) {
        var hexValue = hexValue

        if hexValue.hasPrefix("#") {
            hexValue.remove(at: hexValue.startIndex)
        }

        if let rgbValue = UInt64(hexValue, radix: 16) {
            let redd = Double((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = Double(rgbValue & 0x0000FF) / 255.0

            self.init(red: redd, green: green, blue: blue)
            return
        }

        self.init(red: 0, green: 0, blue: 0) // Return black color if the hex string is invalid
    }
}

