//
//  CGFloat+Extension.swift
//  FortuneWheel
//
//  Created by Rahul Garg on 22/02/22.
//

import UIKit

extension CGFloat {
    static func random() -> Self {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    func toRadians() -> Self {
        return (self * .pi) / 180.0
    }
}
