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
    
    static func imageWithText(attributedText: NSMutableAttributedString, size: CGSize) -> UIImage? {
        // イメージサイズ
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        // 文字列を描画する.
        attributedText.draw(in: CGRect(x: (screenWidth - textWidth) / 2, y: screenHeight - textHeight - 24, width: textWidth, height: textHeight))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    static func getImageWithText(text: String, size: CGSize) -> UIImage? {
        let font = UIFont.Helvetica16()
        
        if (UIGraphicsBeginImageContextWithOption != nil) {
            UIGraphicsBeginImageContextWithOptions(size, false, size)
        } else {
            UIGraphicsBeginImageContextWith(size: size)
            
            
            
        }
    }
    
//    - (UIImage *)imageWithText:(NSString *)text fontSize:(CGFloat)fontSize rectSize:(CGSize)rectSize {
//    
//    // 描画する文字列のフォントを設定。
//    UIFont *font = [UIFont systemFontOfSize:fontSize];
//    
//    // オフスクリーン描画のためのグラフィックスコンテキストを作る。
//    if (UIGraphicsBeginImageContextWithOptions != NULL)
//    UIGraphicsBeginImageContextWithOptions(rectSize, NO, 0.0f);
//    else
//    UIGraphicsBeginImageContext(rectSize);
//    
//    /* Shadowを付ける場合は追加でこの部分の処理を行う。
//     CGContextRef ctx = UIGraphicsGetCurrentContext();
//     CGContextSetShadowWithColor(ctx, CGSizeMake(1.0f, 1.0f), 5.0f, [[UIColor grayColor] CGColor]);
//     */
//    
//    // 文字列の描画領域のサイズをあらかじめ算出しておく。
//    CGSize textAreaSize = [text sizeWithFont:font constrainedToSize:rectSize];
//    
//    // 描画対象領域の中央に文字列を描画する。
//    [text drawInRect:CGRectMake((rectSize.width - textAreaSize.width) * 0.5f,
//    (rectSize.height - textAreaSize.height) * 0.5f,
//    textAreaSize.width,
//    textAreaSize.height)
//    withFont:font
//    lineBreakMode:NSLineBreakByWordWrapping
//    alignment:NSTextAlignmentCenter];
//    
//    // コンテキストから画像オブジェクトを作成する。
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    return image;
//    }
}
