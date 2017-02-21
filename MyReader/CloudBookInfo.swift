//
//  CloudInfo.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/20.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation

class CloudBookInfo : AnyObject {
    var bookId: String
    var bookName : String
    var authorName : String
    var detail : String
    var bookUrl : String
    var fileSize : String
    var rating :Double
    var uploadTime : String
    var bookImgUrl : String
    
    init? (dic: NSDictionary) {
        if let id = dic["id"] as? String {
            bookId = id
        } else {
            return nil
        }
        
        if let name = dic["name"] as? String {
            bookName = name
        } else {
            return nil
        }
        
        if let author = dic["author"] as? String {
            authorName = author
        } else {
            return nil
        }
        
        if let detailStr = dic["detail"] as? String {
            detail = detailStr
        } else {
            return nil
        }
        
        if let subUrl = dic["sub_url"] as? String {
            bookUrl = baseUrl + subUrl
        } else {
            return nil
        }
        
        if let size = dic["size"] as? String {
            fileSize = size
        } else {
            return nil
        }
        
        if let score = dic["score"] as? NSString {
            rating = score.doubleValue
        } else {
            return nil
        }
        
        if let time = dic["create_time"] as? String {
            uploadTime = time
        } else {
            return nil
        }
        
        if let imageUrl = dic["image_url"] as? String {
            bookImgUrl = imageUrl
        } else {
            return nil
        }
    }
}
