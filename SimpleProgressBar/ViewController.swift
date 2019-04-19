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

    // create shape layer
    let shapeLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
        
//        let center = view.center
        
        // create track layer
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 7
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.position = view.center
        
        view.layer.addSublayer(trackLayer)
        
        // set shape layer
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 7
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.position = view.center
        
        shapeLayer.transform = CATransform3DMakeRotation(-.pi / 2, 0, 0, 1)
        
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
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

