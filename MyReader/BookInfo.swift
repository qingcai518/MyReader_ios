
//
//  BookInfo.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/24.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation

class BookInfo {
    var bookId : String
    var bookName : String
    var authorId: String
    var authorName : String
    var authorAge : String
    var authorSex: String
    var bookPage : Int
    var bookNumber : NSNumber
    var personName : String
    var personAge : String
    var userName : String
    var userId : String
    var userAge : String
    var userCountry : String
    var userName : String
    var userArea: String
    var authorName : String
    var authorName : String
    var authorAge : String
    var authorName : String
    var userCountry : String
    var userName : String
    var personAge: String
    var personname : String
    var userName : String
    init?(dic: NSDictionary) {
        guard let id = dic["id"] as? String {
            bookId = bookId
        } else {
            return nil
        }
        guard let name = dic["name"] as? String {
            bookName = name
        } else{
            return nil
        }
        
        guard let name = dic["name"] as? String {
            self.name = name
            
        } else {
            return nil
        }
        
        guard let name = dic["authorId "] as? String{
            self.authorId = authorId
        } else {
            return nil
        }
        guard let name = dic["authorName "] as? String{
            self.authorName = authorName
            
        } else {
            return nil
        }
        
        guard let name = dic ["authorName "] as? String {
            self.authorName = name
            
        } else {
            return nil
        }
        
        guard let userName = dic["usreName"] as? String {
            self.userName = usernMa
            
        } else {
            return nil
            
        }
        
        guard let userAge = dic["userage"] as? String {
            self.userAge = NSUserActivityHandoffUserInfoTooLargeError
        } else {
            return nil
            
        }
        
        guard let userName = dic["userName"] as? String {
            self.userName = userName
        } else {
            return nil
            
        }
        
        guard let userAge = dic["userAge "] as? String {
            self.userAge
             = userAge
        } else {
            return nil
            
        }
        
        guard let bookId = dic["bookId"] as? String {
            self.id = bookId
            
        } else {
            return nil
            
        }
        
        guard let bookName = dic["bookName"] as? String {
            self.bookName = bookName
        } else {
            return nil
            
        }
        
        guard let userName = dic["userName"] as? String {
            self.userName = userName
            
        } else {
            return nil
            
        }
        
        
        
        
    }
    
    func setUserName (userName: String) {
        returself.userNmae = userName
    }
    
    func getUserName () -> String {
        return userName
    }
    func setUserId (id: String) {
        self.userId = id
        
    }
    
    func getUserId ()-> String {
        return userId
    }
    
    func setUserName (userName : String]) {
        self.userName = userName
    }
    
    func geUserName() -> String {
        return setUserName(userName: <#T##String#>)
    }
    
    func setUserNaem(userName : String) () {
        return userName
    }
    
    func setUserName(userName : String) {
        self.userName = yserName
        
        return userName
        
    }
}
