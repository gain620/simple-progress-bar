//
//  ViewController.swift
//  SimpleProgressBar
//
//  Created by Gain Chang on 17/04/2019.
//  Copyright © 2019 Gain Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    var shapeLayer: CAShapeLayer!
    var pulseLayer: CAShapeLayer!
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: NSNotification.Name.NSExtensionHostWillEnterForeground, object: nil)
    }
    
    @objc private func handleEnterForeground() {
        animatePulseLayer()
    }
    
    private func createCircleShapeLayer(_ strokeColor: UIColor, _ fillColor: UIColor) -> CAShapeLayer {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let layer = CAShapeLayer()
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 20
        layer.lineCap = CAShapeLayerLineCap.round
        layer.fillColor = fillColor.cgColor
        layer.position = view.center
        return layer
    }

    fileprivate func setupCircleLayers() {
        pulseLayer = createCircleShapeLayer(.clear, .pulseFillColor)
        view.layer.addSublayer(pulseLayer)
        animatePulseLayer()
        
        let trackLayer = createCircleShapeLayer(.trackStrokeColor, .backgroundColor)
        view.layer.addSublayer(trackLayer)
        
        shapeLayer = createCircleShapeLayer(.outlineStrokeColor, .clear)
        shapeLayer.transform = CATransform3DMakeRotation(-.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }
    
    fileprivate func setupPercentageLabel() {
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotificationObservers()
        
        view.backgroundColor = UIColor.backgroundColor
        
        setupCircleLayers()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        setupPercentageLabel()
    }
    
    private func animatePulseLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.3
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulseLayer.add(animation, forKey: "pulse")
    }
    
    let urlString = "https://archive.org/download/gnomed/beengnomed.flv"
    
    private func beginDownloadFile() {
        print("start downloading")
        shapeLayer.strokeEnd = 0
        let config = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: config, delegate: self, delegateQueue: operationQueue)
        
        guard let url = URL(string: urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: url)

        downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        //        print(totalBytesWritten, totalBytesExpectedToWrite)
        
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async { [weak self] in
            self?.percentageLabel.text = "\(Int(percentage * 100))%"
            self?.shapeLayer.strokeEnd = percentage
        }
        
        print(percentage)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        DispatchQueue.main.async { [weak self] in
            self?.percentageLabel.font = UIFont.boldSystemFont(ofSize: 18)
            self?.percentageLabel.text = "Completed"
        }
        
        print("finished downloading file")
        switchBool = true
    }
    
    fileprivate func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        
        basicAnimation.duration = 2.5
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "basicStrokeTest")
    }
    
    var switchBool: Bool? = true
    
    @objc func handleTap() {
        print("tap test")
        
        if switchBool! {
            beginDownloadFile()
            switchBool = false
        } else {
            print("already downloading")
        }
    }
}

