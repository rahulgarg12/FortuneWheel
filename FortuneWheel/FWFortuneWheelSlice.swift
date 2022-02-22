//
//  FWFortuneWheelSlice.swift
//  FortuneWheel
//
//  Created by Rahul Garg on 22/02/22.
//

import UIKit

class FWFortuneWheelSlice: CALayer {
    private var startAngle: CGFloat!
    
    private var sectorAngle: CGFloat = -1
    
    private var slice: FWSlice!
    
    init(frame: CGRect, startAngle: CGFloat, sectorAngle: CGFloat, slice: FWSlice) {
        super.init()
        
        self.startAngle = startAngle
        self.sectorAngle = sectorAngle
        self.slice = slice
        
        frame = frame.inset(by: UIEdgeInsets(top: -10, left: 0, bottom: -10, right: 0))
        
        contentsScale = UIScreen.main.scale
        masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(in ctx: CGContext) {
        guard let image = slice.image.rotateImage(angle: startAngle) else { return }
        
        let radius = frame.width/2 - slice.borderWidth
          
        let center = CGPoint(x: frame.width/2, y: frame.height/2)
        
        let lineLegth = CGFloat((2 * radius * sin(sectorAngle/2)))
        
        let s = (radius + radius + lineLegth)/2
        
        let size = ((s * (s - radius) * (s - radius) * (s - lineLegth)).squareRoot()/s)
        
        let height = 2 * (1 - cos(sectorAngle/2))
        
        let xIncenter = ((radius * radius) + ((radius * cos(sectorAngle)) * radius))/(radius + radius + lineLegth) + (size * 0.07)
        
        let yIncenter = ((radius * sin(sectorAngle)) * radius)/(radius + radius + lineLegth)
        
        let xPosition : CGFloat = sectorAngle == CGFloat(180).toRadians() ? (-size/2) : sectorAngle == CGFloat(120).toRadians() ? (radius/2.7 - size/2) : sectorAngle == CGFloat(90).toRadians() ? (radius/2.4 - size/2) : ((xIncenter - size/2) + height)
        
        let yPosition : CGFloat = sectorAngle == CGFloat(180).toRadians() ? size/1.6 : sectorAngle == CGFloat(120).toRadians() ? (radius/2 - size/2) : sectorAngle == CGFloat(90).toRadians() ? (radius/2.4 - size/2) : (yIncenter - size/2)
        
        
        UIGraphicsPushContext(ctx)
        
        let path = UIBezierPath()
        path.lineWidth = slice.borderWidth
        path.move(to: center)
        path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: startAngle + sectorAngle, clockwise: true)
        path.close()
        slice.color.setFill()
        path.fill()
        slice.borderColour.setStroke()
        path.stroke()
        
        ctx.saveGState()
        ctx.translateBy(x: center.x, y: center.y)
        ctx.rotate(by: startAngle)
        image.draw(in: CGRect(x: xPosition, y: yPosition , width: size, height: size))
        ctx.restoreGState()
        
        UIGraphicsPopContext()
    }
}
