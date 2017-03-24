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
    
    class func Read1() -> UIColor {
        return UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
    }
    
    class func Read2() -> UIColor {
        return UIColor(red:0.98, green:0.94, blue:0.90, alpha:1.0)
    }
    
    class func Read3() -> UIColor {
        return UIColor(red:0.88, green:1.00, blue:1.00, alpha:1.0)
    }
    
    class func Read4() -> UIColor {
        return UIColor(red:0.90, green:0.90, blue:0.98, alpha:1.0)
    }
    
    class func Read5() -> UIColor {
        return UIColor(red:0.37, green:0.62, blue:0.63, alpha:1.0)
    }
    
    class func Read6() -> UIColor {
        return UIColor(red:0.60, green:0.60, blue:0.80, alpha:1.0)
    }
    
    class func Read7() -> UIColor {
        return UIColor(red:0.94, green:1.00, blue:1.00, alpha:1.0)
    }
    
    class func Read8() -> UIColor {
        return UIColor(red:0.74, green:0.72, blue:0.42, alpha:1.0)
    }
    
    class func Read9() -> UIColor {
        return UIColor(red:1.00, green:0.84, blue:0.00, alpha:1.0)
    }
    
    class func Read10() -> UIColor {
        return UIColor(red:0.68, green:1.00, blue:0.18, alpha:1.0)
    }
}
