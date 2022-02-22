//
//  UIColor.+Extension.swift
//  FortuneWheel
//
//  Created by Rahul Garg on 22/02/22.
//

import UIKit

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1)
    }
}
