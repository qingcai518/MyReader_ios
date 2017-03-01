//
//  BookmarkModel.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/01.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation

class BookmarkModel {
    var bookmarkInfos = [BookmarkInfo]()
    
    func getBookmarkInfos(completion : @escaping (String?) -> Void) {
        bookmarkInfos = SQLiteManager.sharedInstance.selectBookmarks()
        return completion(nil)
    }
}
