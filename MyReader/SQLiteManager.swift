//
//  SQLiteManager.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/21.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation
import SQLite

class SQLiteManager {
    var db : Connection!
    var table_books: Table!
    var table_bookmarks: Table!
    
    class var sharedInstance : SQLiteManager {
        struct Static {
            static let instance : SQLiteManager = SQLiteManager()
        }
        
        return Static.instance
    }

    func createDB() {
        if db != nil {
            return
        }
        
        guard let sqlitePath = AppUtility.getSQLitePath() else {
            return
        }
        
        do {
            db = try Connection(sqlitePath)
            
            // books tableを作成する.
            table_books = Table("Books")
            let id = Expression<String>("id")
            let bookName = Expression<String>("name")
            let author = Expression<String>("author")
            let bookUrl = Expression<String>("url")
            let imageUrl = Expression<String>("imageUrl")
            
            try db?.run(table_books!.create{ table in
                table.column(id, primaryKey: true)
                table.column(bookName)
                table.column(author)
                table.column(bookUrl, unique: true)
                table.column(imageUrl)
            })
            
            
            // bookmark tableを作成する.
            table_bookmarks = Table("Bookmarks")
            let bookmarkId = Expression<Int>("id")
            let bookmarkName = Expression<String>("name")
            let bookId = Expression<String>("bookId")
            let content = Expression<String>("content")
            let time = Expression<String>("time")
            let pageNumber = Expression<Int>("pageNumber")
            
            try db.run(table_bookmarks.create{ table in
                table.column(bookmarkId, primaryKey: PrimaryKey.autoincrement)
                table.column(bookId)
                table.column(bookmarkName)
                table.column(content)
                table.column(time)
                table.column(pageNumber)
            })
            
        } catch {
            print("11111")
        }
    }
    
    func insertBook(localPath : String, bookInfo: CloudBookInfo) {
        if (table_books == nil) {
            return
        }
        
        let bookId = bookInfo.bookId
        let bookName = bookInfo.bookName
        let author = bookInfo.authorName
        let bookUrl = localPath
        let imageUrl = bookInfo.bookImgUrl
        
        do {
            let statement = try db.prepare("insert into Books (id, name, author, url, imageUrl) values (?, ?, ?, ?, ?)")
            try statement.run([bookId, bookName, author, bookUrl, imageUrl])
            
            let totalChanges = db.totalChanges
            let changes = db.changes
            let lastInsertRowId = db.lastInsertRowid
            
            print("total changes = \(totalChanges), changes = \(changes), last insert row id = \(lastInsertRowId)")
        } catch {
            print("fail to insert table_books.")
        }
    }

    func selectBooks() -> [LocalBookInfo] {
        var infos = [LocalBookInfo]()
        if (table_books == nil) {
            return infos
        }
        
        do {
            for row in try db.prepare("select * from Books") {
                guard let bookId = row[0] as? String else {continue}
                guard let bookName = row[1] as? String else {continue}
                guard let authorName = row[2] as? String else {continue}
                guard let localPath = row[3] as? String else {continue}
                guard let bookImgUrl = row[4] as? String else {continue}
                
                let info = LocalBookInfo(bookId: bookId, bookName: bookName, authorName: authorName, localPath: localPath, bookImgUrl: bookImgUrl)
                infos.append(info)
            }
        } catch {
            print("fail to select table_books.")
        }
        
        return infos
    }
    
    func deleteBook(bookId: String) {
        if (table_books == nil) {
            return
        }
        
        do {
            let statement = try db.prepare("delete from Books where id = ?")
            try statement.run(bookId)
            
            let total = db.totalChanges
            let changes = db.changes
            
            print("total = \(total), changes = \(changes)")
            
        } catch {
            print("fail to delete data.")
        }
    }
    
    func selectBookById(bookId: String) -> LocalBookInfo? {
        do {
            for row in try db.prepare("select * from Books where id = \(bookId)") {
                guard let bookId = row[0] as? String else {continue}
                guard let bookName = row[1] as? String else {continue}
                guard let authorName = row[2] as? String else {continue}
                guard let localPath = row[3] as? String else {continue}
                guard let bookImgUrl = row[4] as? String else {continue}
                
                let info = LocalBookInfo(bookId: bookId, bookName: bookName, authorName: authorName, localPath: localPath, bookImgUrl: bookImgUrl)
                
                return info
            }
        } catch {
            print("fail to get book.")
        }
        
        return nil
    }
    
    func insertBookmark(name: String, bookId: String, time: String, content: String, pageNumber: Int) -> Int {
        if (table_bookmarks == nil) {
            print("no table exists.")
            return -1
        }
        
        do {
            let statement = try db.prepare("insert into Bookmarks (name, bookId, content, time, pageNumber) values (?, ?, ?, ?, ?)")
            
            try statement.run([name, bookId, content, time, pageNumber])
            let totalChanges = db.totalChanges
            let changes = db.changes
            let lastInsertRowId = db.lastInsertRowid
            
            print("total changes = \(totalChanges), changes = \(changes), last row id = \(lastInsertRowId)")
            
            return Int(lastInsertRowId)
        } catch {
            print("fail to insert table_bookmarks")
        }
        
        return -1
    }
    
    func selectBookmarks() -> [BookmarkInfo] {
        var infos = [BookmarkInfo]()
        if (table_bookmarks == nil) {
            return infos
        }
        
        do {
            for row in try db.prepare("select * from Bookmarks") {
                guard let bookmarkId = row[0] as? Int else {continue}
                guard let bookId = row[1] as? String else {continue}
                guard let bookmarkName = row[2] as? String else {continue}
                guard let content = row[3] as? String else {continue}
                guard let bookmarkTime = row[4] as? String else {continue}
                guard let pageNumber = row[5] as? Int else {continue}
                
                let info = BookmarkInfo(bookmarkId: bookmarkId, bookmarkName: bookmarkName, bookmarkTime: bookmarkTime, contents: content, bookId: bookId, pageNumber: pageNumber)
                
                infos.append(info)
            }
        } catch {
            print("fail to get bookmark infos.")
        }
        
        return infos
    }
    
    func deleteBookmark(bookmarkId: Int) {
        if (table_bookmarks == nil) {
            return
        }
        
        do {
            let statement = try db.prepare("delete from Bookmarks where id = ?")
            try statement.run(bookmarkId)
            
            let total = db.totalChanges
            let changes = db.changes
            
            print("total = \(total), changes = \(changes)")
        } catch {
            print("fail to delete bookmark.")
        }
    }
}
