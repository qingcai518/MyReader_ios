//
//  BooksModel.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/21.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation
import RxSwift

class BooksModel {
    var bookInfos = [LocalBookInfo]()
    
    // 読み込みした後の本の情報.
    var pageContents = [NSMutableAttributedString]()
    
    // 読み込み後の章の情報.
    var chapterInfos = [ChapterInfo]()
    
    func getBookInfos(completion: @escaping (String?) -> Void) {
        bookInfos = SQLiteManager.sharedInstance.selectBooks()
        
        for bookInfo in bookInfos {
            let bookId = bookInfo.bookId
            let bookName = bookInfo.bookName
            let authorName = bookInfo.authorName
            let localPath = bookInfo.localPath
            let bookImgUrl = bookInfo.bookImgUrl
            
            print("book info = \(bookId), \(bookName), \(authorName), \(localPath), \(bookImgUrl)")
        }
        
        return completion(nil)
    }

    func removeBookById(bookId: String,completion: @escaping (String?) -> Void) {
        SQLiteManager.sharedInstance.deleteBook(bookId: bookId)
        
        bookInfos = SQLiteManager.sharedInstance.selectBooks()
        
        return completion(nil)
    }
    
    func readFile(bookInfo: LocalBookInfo) {
        let fileHandle = FileHandle(forReadingAtPath: bookInfo.localPath)
        fileHandle?.seek(toFileOffset: 0)
        fileHandle?.readInBackgroundAndNotify()
    }
    
    func setContents(text: String?) {
        guard let content = text else {
            return
        }
        
        let letersPerLine = Int(floor(Double(textWidth / (font.pointSize + CGFloat(letterSpacing)))))
        let lines = floor(Double(textHeight / (font.lineHeight + lineSpacing)))
        
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
        var startPage = 0
        var chapterNumber = 0
        var chapterName = "序言"
        
        self.chapterInfos.removeAll()
        
        for i in 0..<contents.count {
            let content = contents[i]
            
            // 章节分类.
            let contentTrim = content.trimmingCharacters(in: CharacterSet.whitespaces)
            if (contentTrim.hasPrefix("Chapter") || (contentTrim.hasPrefix("第") && contentTrim.contains("章"))) {
                // 把当前章添加入数组.
                let endPage = pageContents.count
                let chapterInfo = ChapterInfo(chapterNumber: chapterNumber, chapterName: chapterName, startPage: startPage, endPage: endPage)
                self.chapterInfos.append(chapterInfo)
                
                // 设置下一章的信息.
                chapterNumber = chapterNumber + 1
                chapterName = contentTrim
                startPage = endPage + 1
                
                self.addToPageContents(contentValue: contentValue)
                contentValue = ""
            }
            
            if (i > 0 && i % count == 0) {
                self.addToPageContents(contentValue: contentValue)
                contentValue = ""
            }
            
            contentValue.append(content)
            contentValue.append("\n")
        }
        
        if (chapterNumber > 0) {
            // 添加最后一章的信息.
            let chapterInfo = ChapterInfo(chapterNumber: chapterNumber, chapterName: chapterName, startPage: startPage, endPage:  self.pageContents.count)
            chapterInfos.append(chapterInfo)
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
