//
//  ViewController.swift
//  SimpleProgressBar
//
//  Created by Gain Chang on 17/04/2019.
//  Copyright © 2019 Gain Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    
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

    // create shape layer
    let shapeLayer = CAShapeLayer()
    
    var pulseLayer: CAShapeLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColor
        
//        let center = view.center
        
        // create track layer
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        pulseLayer = CAShapeLayer()
        pulseLayer.path = circularPath.cgPath
        pulseLayer.strokeColor = UIColor.clear.cgColor
        pulseLayer.lineWidth = 7
        pulseLayer.lineCap = CAShapeLayerLineCap.round
        pulseLayer.fillColor = UIColor.pulseFillColor.cgColor
        pulseLayer.position = view.center
        view.layer.addSublayer(pulseLayer)
        animatePulseLayer()
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.trackStrokeColor.cgColor
        trackLayer.lineWidth = 20
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.fillColor = UIColor.backgroundColor.cgColor
        trackLayer.position = view.center
        view.layer.addSublayer(trackLayer)
        
        // set shape layer
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.outlineStrokeColor.cgColor
        shapeLayer.lineWidth = 20
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.position = view.center
        shapeLayer.transform = CATransform3DMakeRotation(-.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
    }
    
    private func animatePulseLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.5
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulseLayer.add(animation, forKey: "pulse")
    }
    
    let urlString = "https://archive.org/download/youtube-oHg5SJYRHA0/RickRoll_D-oHg5SJYRHA0.mkv"
    
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
        
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(percentage * 100))%"
            
            self.shapeLayer.strokeEnd = percentage
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
        
        
//        animateCircle()
    }


}

