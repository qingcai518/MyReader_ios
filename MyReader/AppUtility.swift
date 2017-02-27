//
//  AppUtility.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/20.
//  Copyright © 2017年 RN-079. All rights reserved.
//
import UIKit
import Foundation

class AppUtility {
    static func getIdleImages() -> [UIImage] {
        return [UIImage(named: "icon_book_pull")!]
    }
    
    static func getPullingImages() -> [UIImage] {
        return [UIImage(named: "icon_book_pause")!]
    }
    
    static func getRefreshingImages() -> [UIImage] {
        return [
            UIImage(named: "icon_book1")!,
            UIImage(named: "icon_book2")!,
            UIImage(named: "icon_book3")!,
            UIImage(named: "icon_book4")!
        ]
    }
    
    static func getTextHeight(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let attributedText = NSAttributedString(string: text, attributes: [NSFontAttributeName: font])
        let textRect = attributedText.boundingRect(with: CGSize(width: width, height : 2000), options: .usesLineFragmentOrigin, context: nil)
        
        return textRect.height
    }

    static func getTextWidth(text: String, height: CGFloat, font: UIFont) -> CGFloat {
        let attributedText = NSAttributedString(string: text, attributes: [NSFontAttributeName: font])
        let textRect = attributedText.boundingRect(with: CGSize(width : 2000, height : height), options: .usesLineFragmentOrigin, context: nil)
        
        return textRect.width
    }
    
    static func getSQLitePath() -> String? {
        // path document
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        guard let documentPath = paths.first else {
            return nil
        }
        
        let path = documentPath + "/MyReader.sqlite3"
        return path
    }
    
    // dummy.
    static func getFileSize(fileSize : String) -> Int {
        if (fileSize.contains("KB")) {
            let range = fileSize.range(of: "KB")!
            var value = fileSize.substring(to: range.lowerBound)
            value = value + "000"
            return (value as NSString).integerValue
        } else if (fileSize.contains("MB")) {
            let range = fileSize.range(of: "MB")!
            var value = fileSize.substring(to: range.lowerBound)
            value = value + "000000"
            return (value as NSString).integerValue
        } else {
            return (fileSize as NSString).integerValue
        }
    }
    
    static func getDigital2 (value: Double) -> String {
        var result = "".appendingFormat("%.2f", value)
        result = "\(result)%"
        
        return result
    }
    
    /*
     * 画像を文字列から取得する処理.
     */
    static func imageWithText(attributedText: NSMutableAttributedString, size: CGSize) -> UIImage? {
        let scale = UIScreen.main.scale
        
        print("scale = \(scale)")
        
        // イメージサイズ
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        // 文字列を描画する.
        attributedText.draw(in: CGRect(x: (screenWidth - textWidth) / 2, y: screenHeight - textHeight - 24, width: textWidth, height: textHeight))
        
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    static func getEncoding(tempData: Data) -> UInt {
        let encode1 = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.macChineseSimp.rawValue))
        let encode2 = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_2312_80.rawValue))
        let encode3 = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
        let encode4 = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GBK_95.rawValue))
        let encode5 = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.HZ_GB_2312.rawValue))
        
        if let _ = String.init(data: tempData, encoding: String.Encoding(rawValue: encode1)) {
            print("encoding = mac chinese simp.")
            return encode1
        }
        
        if let _ = String.init(data: tempData, encoding: String.Encoding(rawValue: encode2)) {
            print("encoding = gb 2312 80")
            return encode2
        }
        
        if let _ = String.init(data: tempData, encoding: String.Encoding(rawValue: encode3)) {
            print("encoding = gb 18030 2000")
            return encode3
        }
        
        if let _ = String.init(data: tempData, encoding: String.Encoding(rawValue: encode4)) {
            print("encoding = gbk 95")
            return encode4
        }
        
        print("encoding = hz gb 2312")
        return encode5
        
    }
}
