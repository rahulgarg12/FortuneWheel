//
//  FWWheelViewController.swift
//  FortuneWheel
//
//  Created by Rahul Garg on 22/02/22.
//

import UIKit

final class FWWheelViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initFortuneWheel()
    }
    
    private func initFortuneWheel() {
        var slices = [FWSlice]()
        
        for _ in 0..<Constants.sliceCount {
            guard let image = UIImage(named: "gift") else { continue }
            
            var slice = FWSlice(image: image)
            slice.color = .random()
            slices.append(slice)
        }
        
        let width = view.bounds.width - 50
        let fortuineWheel = FWFortuneWheel(center: CGPoint(x: view.frame.width/2, y: view.frame.height/2), diameter: width, slices: slices)
        fortuineWheel.delegate = self
        view.addSubview(fortuineWheel)
    }
}

//MARK:- FWFortuneWheelDelegate
extension FWWheelViewController: FWFortuneWheelDelegate {
    func wheelLoaderStopped() {
        
    }
}
