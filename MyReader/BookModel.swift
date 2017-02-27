//
//  BookModel.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/22.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation

class BookModel {
//    func readFile(bookInfo: LocalBookInfo, completion: @escaping (String?) -> Void) {
//        let encode = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
//
//        DispatchQueue.global().async {
//            let readHandle = FileHandle(forReadingAtPath: bookInfo.localPath)
//            guard let data = readHandle?.readData(ofLength: readLength) else {
//                print("read no data.")
//                return completion(nil)
//            }
//            
//            let readStr = NSString.init(data: data, encoding: encode)
//            
//            DispatchQueue.main.async {
//                print("read string = \(readStr)")
//                return completion(readStr as? String)
//            }
//        }
//    }
    
    func readFile(bookInfo: LocalBookInfo, completion : @escaping (String?) -> Void) {
         let encode = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.macChineseSimp.rawValue))
//        let encode = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_2312_80.rawValue))
        
        DispatchQueue.global().async {
            let readHandle = FileHandle(forReadingAtPath: bookInfo.localPath)
            guard let data = readHandle?.readData(ofLength: readLength) else {
                print("read no data.")
                return completion(nil)
            }
            
            let readStr = String.init(data: data, encoding: String.Encoding(rawValue: encode))
            
            DispatchQueue.main.async {
                print("read string = \(readStr)")
                return completion(readStr)
            }
        }
    }
}
