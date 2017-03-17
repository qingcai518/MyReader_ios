//
//  UIColor.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/17.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func getRGB(color: UIColor) -> (r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) {
        var r = CGFloat(1.0)
        var g = CGFloat(1.0)
        var b = CGFloat(1.0)
        var alpha = CGFloat(1.0)
        
        color.getRed(&r, green: &g, blue: &b, alpha: &alpha)
        
        return (r, g, b, alpha)
    }
}
