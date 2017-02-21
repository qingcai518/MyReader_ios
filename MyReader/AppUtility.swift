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
}
