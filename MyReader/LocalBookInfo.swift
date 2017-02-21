//
//  LocalBookInfo.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/21.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation

class LocalBookInfo {
    var bookId: String
    var bookName : String
    var authorName : String
    var localPath : String
    var bookImgUrl: String
    
    init(bookId: String, bookName: String, authorName: String, localPath: String, bookImgUrl: String) {
        self.bookId = bookId
        self.bookName = bookName
        self.authorName = authorName
        self.localPath = localPath
        self.bookImgUrl = bookImgUrl
    }
}
