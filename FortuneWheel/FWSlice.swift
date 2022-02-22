//
//  FWSlice.swift
//  FortuneWheel
//
//  Created by Rahul Garg on 22/02/22.
//

import UIKit

struct FWSlice {
    var image: UIImage
    
    var color = UIColor.clear
    var borderColour = UIColor.white
    var borderWidth: CGFloat = 1
    
    init(image: UIImage) {
        self.image = image
    }
}
