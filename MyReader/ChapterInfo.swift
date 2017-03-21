//
//  ChapterInfo.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/28.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation

class ChapterInfo {
    var chapterNumber : Int
    var chapterName : String
    var startPage: Int
    var endPage: Int
    
    init(chapterNumber: Int, chapterName: String, startPage: Int, endPage: Int) {
        self.chapterNumber = chapterNumber
        self.chapterName = chapterName
        self.startPage = startPage
        self.endPage = endPage
    }
}
