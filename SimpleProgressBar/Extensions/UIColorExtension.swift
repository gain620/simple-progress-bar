//
//  UIColorExtension.swift
//  SimpleProgressBar
//
//  Created by Gain Chang on 21/04/2019.
//  Copyright © 2019 Gain Chang. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(r: CGFloat, g: CGFloat, b:CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let backgroundColor = UIColor.rgb(r: 21, g: 22, b: 33)
    static let outlineStrokeColor = UIColor.rgb(r: 10, g: 80, b: 180)
    static let trackStrokeColor = UIColor.rgb(r: 31, g: 68, b: 95)
    static let pulseFillColor = UIColor.rgb(r: 30, g: 100, b: 155)
}
