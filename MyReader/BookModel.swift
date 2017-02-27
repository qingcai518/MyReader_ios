//
//  BookModel.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/22.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation

class BookModel {
    func readFile(bookInfo: LocalBookInfo, completion : @escaping (String?) -> Void) {
        DispatchQueue.main.async {
            let fileHandle = FileHandle(forReadingAtPath: bookInfo.localPath)
            fileHandle?.seek(toFileOffset: 0)
            
            // 文字コードをチェックする.
            guard let tempData = fileHandle?.readData(ofLength: 1024) else {
                print("read no temp data.")
                return completion(nil)
            }
            
            let encode = AppUtility.getEncoding(tempData: tempData)
            
            
            fileHandle?.seek(toFileOffset: 0)
            
//            guard let data = fileHandle?.readData(ofLength: 10240) else {
//                print("read no data.")
//                return completion(nil)
//            }
            guard let data = fileHandle?.readDataToEndOfFile() else {
                print("read no data.")
                return completion(nil)
            }
            
            let readStr = String.init(data: data, encoding: String.Encoding(rawValue: encode))
            
            DispatchQueue.main.async {
                print("read str = \(readStr)")
                
                return completion(readStr)
            }
        }
    }
    
//    func readFile(bookInfo: LocalBookInfo, completion : @escaping (String?) -> Void) {
//        DispatchQueue.main.async {
//            let fileHandle = FileHandle(forReadingAtPath: bookInfo.localPath)
//            fileHandle?.seek(toFileOffset: 0)
//            
//            // 文字コードをチェックする.
//            guard let tempData = fileHandle?.readData(ofLength: 1024) else {
//                print("read no temp data.")
//                return completion(nil)
//            }
//            
//            let encode = AppUtility.getEncoding(tempData: tempData)
//            
//            
//            fileHandle?.seek(toFileOffset: 0)
//            guard let data = fileHandle?.readDataToEndOfFile() else {
//                print("read no data.")
//                return completion(nil)
//            }
//            
//            let readStr = String.init(data: data, encoding: String.Encoding(rawValue: encode))
//            
//            DispatchQueue.main.async {
//                return completion(readStr)
//            }
//        }
//    }
}
