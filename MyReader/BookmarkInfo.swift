//
//  BookmarkInfo.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/01.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation

class BookmarkInfo {
    var bookmarkName: String
    var bookmarkTime: String
    var bookmarkPage: Int
    var bookmarkContents: String
    
    init(bookmarkName: String, bookmarkTime: String, bookmarkPage: Int, bookmarkContents: String) {
        self.bookmarkName = bookmarkName
        self.bookmarkTime = bookmarkTime
        self.bookmarkPage = bookmarkPage
        self.bookmarkContents = bookmarkContents
        
    }
}
