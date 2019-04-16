//
//  ViewController.swift
//  SimpleProgressBar
//
//  Created by Gain Chang on 17/04/2019.
//  Copyright © 2019 Gain Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // create shape layer
    let shapeLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = view.center
        
        // create track layer
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 7
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(trackLayer)
        
        // set shape layer
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 7
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc func handleTap() {
        print("test")
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        
        basicAnimation.duration = 2.5
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "basicStrokeTest")
    }


}

