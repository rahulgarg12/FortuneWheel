//
//  FWFortuneWheel.swift
//  FortuneWheel
//
//  Created by Rahul Garg on 22/02/22.
//

import UIKit

protocol FWFortuneWheelDelegate: AnyObject {
    func wheelLoaderStopped()
}

final class FWFortuneWheel: UIView {
    weak var delegate: FWFortuneWheelDelegate?
    
    private lazy var indicatorSize : CGSize = {
        let size = CGSize(width: self.bounds.width * 0.12, height: self.bounds.height * 0.12)
        return size
    }()
    
    private var slices: [FWSlice]?
    
    private var indicator = UIImageView()
    
    private var spinButton = UIButton()
    
    private var sectorAngle: CGFloat = 0
    
    private var wheelView: UIView!
    
    private var timer: Timer?
    
    
    init(center: CGPoint, diameter: CGFloat, slices: [FWSlice]?) {
        super.init(frame: CGRect(origin: CGPoint(x: center.x - diameter/2, y: center.y - diameter/2), size: CGSize(width: diameter, height: diameter)))
        self.slices = slices
        
        initialSetUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetUp() {
        addWheelView()
        addPlayBtn()
        addArrowIndicator()
    }
    
    private func addWheelView() {
        let width = bounds.width - indicatorSize.width
        let height = bounds.height - indicatorSize.height
        
        let xPosition = (bounds.width - width) / 2
        let yPosition = (bounds.height - height) / 2
        
        wheelView = UIView(frame: CGRect(x: xPosition, y: yPosition, width: width, height: height))
        wheelView.backgroundColor = .darkGray
        wheelView.layer.cornerRadius = width / 2
        wheelView.clipsToBounds = true
        addSubview(wheelView)
        
        addWheelLayer()
    }
    
    private func addArrowIndicator() {
        let position = CGPoint(x: wheelView.frame.origin.x - (indicatorSize.width/2), y: (bounds.height - indicatorSize.height) / 2)
        indicator.frame = CGRect(origin: position, size: indicatorSize)
        indicator.image = UIImage(named: "arrow_indicator")
        
        if indicator.superview == nil {
            addSubview(indicator)
        }
    }
    
    private func addPlayBtn() {
        let size = CGSize(width: bounds.width * 0.15, height: bounds.height * 0.15)
        let point = CGPoint(x: (frame.width - size.width) / 2, y: (frame.height - size.height) / 2)
        
        spinButton.setTitle(Constants.Title.spinButton, for: .normal)
        spinButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        spinButton.frame = CGRect(origin: point, size: size)
        
        spinButton.addTarget(self, action: #selector(startAction(_:)), for: .touchUpInside)
        spinButton.layer.cornerRadius = spinButton.frame.height / 2
        spinButton.clipsToBounds = true
        spinButton.backgroundColor = .purple
        spinButton.layer.borderWidth = 1
        spinButton.layer.borderColor = UIColor.white.cgColor
        addSubview(spinButton)
    }
    
    private func addWheelLayer() {
        guard let slices = slices else { return }
            
        wheelView.layer.sublayers?.forEach( { $0.removeFromSuperlayer() } )
        
        sectorAngle = (2 * CGFloat.pi) / CGFloat(slices.count)
        
        for (index, slice) in slices.enumerated() {
            let sector = FWFortuneWheelSlice(frame: wheelView.bounds,
                                             startAngle: sectorAngle * CGFloat(index),
                                             sectorAngle: sectorAngle,
                                             slice: slice)
            wheelView.layer.addSublayer(sector)
            sector.setNeedsDisplay()
        }
    }
    
    private func startTimer() {
        var timerCount = Constants.spinDuration
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            timerCount -= 1
            
            if timerCount <= 0 {
                return
            }
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
                self.spinButton.transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2)
                self.wheelView?.transform = CGAffineTransform.identity.scaledBy(x: 1.05, y: 1.05)
            }) { (finished) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.spinButton.transform = CGAffineTransform.identity
                    self.wheelView?.transform = CGAffineTransform.identity
                })
            }
        })
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func startAction(_ sender: UIButton) {
        sender.isEnabled = false
        
        spinWheel()
    }
    
    private func spinWheel() {
        
        let half = CGFloat.pi
        let diff = half - (sectorAngle * Constants.winningIndex) + (sectorAngle / 2)
        
        let spinAnimation = CABasicAnimation(keyPath: "transform.rotation")
        spinAnimation.fromValue = NSNumber(floatLiteral: 0)
        spinAnimation.toValue = NSNumber(floatLiteral: (half * 2 * Constants.spinRotationsCount) + diff)
        spinAnimation.duration = Constants.spinDuration
        spinAnimation.beginTime = CACurrentMediaTime()
        spinAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        spinAnimation.fillMode = .forwards
        spinAnimation.isCumulative = true
        spinAnimation.isRemovedOnCompletion = false
        spinAnimation.delegate = self

        wheelView.layer.add(spinAnimation, forKey: "fastAnimation")
    }
}

//MARK:- CAAnimationDelegate
extension FWFortuneWheel: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        startTimer()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        spinButton.isEnabled = true
        stopTimer()
        
        delegate?.wheelLoaderStopped()
    }
}
