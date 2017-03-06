//
//  BookmarkInfo.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/01.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation

class BookmarkInfo {
    var bookmarkId : Int
    var bookmarkName : String
    var bookmarkTime : String
    var contents : String
    var bookId : String
    var pageNumber: Int
    
    init(bookmarkId: Int, bookmarkName: String, bookmarkTime: String, contents: String, bookId: String, pageNumber: Int) {
        self.bookmarkId = bookmarkId
        self.bookmarkName = bookmarkName
        self.bookmarkTime = bookmarkTime
        self.contents = contents
        self.bookId = bookId
        self.pageNumber = pageNumber
    }
}
