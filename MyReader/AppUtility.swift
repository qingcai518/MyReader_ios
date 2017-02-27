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
    
    static func String2Image(imageString: String) -> UIImage? {
        guard  let decodeBase64 = NSData(base64Encoded: imageString, options: .ignoreUnknownCharacters) else {
            return nil
        }
        
        let image = UIImage(data: decodeBase64)
        
        return image
    }
    
//    //StringをUIImageに変換する
//    func String2Image(imageString:String) -> UIImage?{
//        
//        //空白を+に変換する
//        var base64String = imageString.stringByReplacingOccurrencesOfString(" ", withString:"+",options: nil, range:nil)
//        
//        //BASE64の文字列をデコードしてNSDataを生成
//        let decodeBase64:NSData? =
//            NSData(base64EncodedString:base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
//        
//        //NSDataの生成が成功していたら
//        if let decodeSuccess = decodeBase64 {
//            
//            //NSDataからUIImageを生成
//            let img = UIImage(data: decodeSuccess)
//            
//            //結果を返却
//            return img
//        }
//        
//        return nil
//        
//    }
}
