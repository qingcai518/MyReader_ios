//
//  BookModel.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/22.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation
import UIKit

class BookModel {
    var pageContents = [NSMutableAttributedString]()
    let letterSpacing = 1.0
    let lineSpacing = CGFloat(6.0)
    let font = UIFont.Helvetica18()

    func readFile(bookInfo: LocalBookInfo, completion : @escaping (String?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            let fileHandle = FileHandle(forReadingAtPath: bookInfo.localPath)
            
            fileHandle?.seek(toFileOffset: 0)
            guard let data = fileHandle?.readDataToEndOfFile() else {
                print("read no data.")
                return completion(nil)
            }
            
            let readStr = AppUtility.getStringFromData(data: data)
            self?.setContents(text: readStr)
            
            return completion(readStr)
        }
    }
    
//    func readFile(bookInfo: LocalBookInfo, completion: @escaping (String?) -> Void) {
//        DispatchQueue.global().async { [weak self] in
//            let fileHandler = FileHandle(forReadingAtPath: bookInfo.localPath)
//            fileHandler?.seek(toFileOffset: 0)
//            guard let data = fileHandler?.readDataToEndOfFile() else {
//                print("read no data.")
//                return completion(nil)
//            }
//            let subData = data.subdata(in: 0..<625)
//            let encoding = AppUtility.getEncoding(subData: subData)
//            
//            let readStr = String.init(data: data, encoding: String.Encoding(rawValue: encoding))
//            self?.setContents(text: readStr)
//            
//            return completion(readStr)
//        }
//    }
    
    private func setContents(text: String?) {
        guard let content = text else {
            return
        }
        
        let letersPerLine = Int(floor(Double(textWidth / (font.pointSize + CGFloat(letterSpacing)))))
        let lines = floor(Double(textHeight / (font.lineHeight + lineSpacing)))
        print("leters per line = \(letersPerLine), lines = \(lines)")
        
        let array = content.components(separatedBy: .newlines)
        
        var contents = [String]()
        for lineStr in array {
            if (lineStr.characters.count <= letersPerLine) {
                contents.append(lineStr)
            } else {
                var temp = lineStr
                while temp.characters.count > letersPerLine {
                    let subText = (temp as NSString).substring(to: letersPerLine)
                    contents.append(subText)
                    temp = (temp as NSString).substring(from: letersPerLine)
                }
                
                if (temp != "") {
                    contents.append(temp)
                }
            }
        }
        
        let count = contents.count > Int(lines) ? Int(lines) : contents.count
        
        var contentValue = ""
        for i in 0..<contents.count {
            let content = contents[i]
            
            if (i > 0 && i % count == 0) {
                self.addToPageContents(contentValue: contentValue)
                contentValue = ""
            }
            
            contentValue.append(content)
            contentValue.append("\n")
        }
        
        if (contentValue != "") {
            self.addToPageContents(contentValue: contentValue)
        }
    }
    
    private func addToPageContents(contentValue : String) {
        let attributedText = NSMutableAttributedString(string: contentValue)
        let range = NSMakeRange(0, attributedText.length)
        
        // フォント.
        attributedText.addAttribute(NSFontAttributeName, value: font, range: range)
        
        // 文字間隔.
        attributedText.addAttribute(NSKernAttributeName, value: letterSpacing, range: range)
        
        // 行間隔.
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
        
        // 背景色.
        attributedText.addAttribute(NSBackgroundColorAttributeName, value: UIColor.clear, range: range)
        
        // 文字色.
        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: range)
        
        pageContents.append(attributedText)
    }
    
}
