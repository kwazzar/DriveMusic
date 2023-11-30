//
//  Nib.swift
//  DriveMusic
//
//  Created by Quasar on 29.11.2023.
//

import UIKit

extension UIView {

    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil)![0]
        as! T
    }
}
