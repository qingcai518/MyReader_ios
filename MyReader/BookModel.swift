//
//  BookModel.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/06.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation

class BookModel {
    func saveCurrentPage(bookInfo: LocalBookInfo,pageIndex: Int) {
        UserDefaults.standard.set(pageIndex, forKey: UDKey.CurrentPage + "_" + bookInfo.bookId)
        UserDefaults.standard.synchronize()
    }
    
    func getCurrentPage(bookInfo: LocalBookInfo) -> Int {
        return UserDefaults.standard.integer(forKey: UDKey.CurrentPage + "_" + bookInfo.bookId)
    }
}
