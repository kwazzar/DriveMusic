//
//  Extensions.swift
//  DriveMusic
//
//  Created by Quasar on 24.10.2023.
//

import UIKit

extension UIColor {
    convenience init? (hexValue: String, alpha: CGFloat) {
        if hexValue.hasPrefix("#") {
            let scanner = Scanner(string: hexValue)
            scanner.currentIndex = scanner.string.index(after: scanner.currentIndex)
            
            var hexInt64: UInt64 = 0
            if hexValue.count == 7 {
                if scanner.scanHexInt64(&hexInt64) {
                    let red = CGFloat((hexInt64 & 0xFF0000) >> 16) / 255
                    let green = CGFloat((hexInt64 & 0x00FF00) >> 8) / 255
                    let blue = CGFloat(hexInt64 & 0x0000FF) / 255
                    self.init(red: red, green: green, blue: blue, alpha: alpha)
                    return
                }
            }
        }
        return nil
    }
    
}

