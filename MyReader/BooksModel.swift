//
//  BooksModel.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/21.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation

class BooksModel {
    var bookInfos = [LocalBookInfo]()
    
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
}
