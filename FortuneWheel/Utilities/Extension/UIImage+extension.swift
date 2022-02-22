//
//  UIImage+extension.swift
//  FortuneWheel
//
//  Created by Rahul Garg on 22/02/22.
//

import UIKit

extension UIImage {
    func rotateImage(angle: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        
        guard let cgImage = cgImage,
              let bitmap = UIGraphicsGetCurrentContext()
            else { return nil }
        
        bitmap.translateBy(x: size.width / 2, y: size.height / 2)
        bitmap.rotate(by: (angle * (CGFloat.pi / 90)))
        bitmap.scaleBy(x: 1.0, y: -1.0)
        
        let origin = CGPoint(x: -size.width / 2, y: -size.width / 2)
        
        bitmap.draw(cgImage, in: CGRect(origin: origin, size: size))
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
