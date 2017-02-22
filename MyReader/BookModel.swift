//
//  BookModel.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/22.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation

class BookModel {
    func readFile(bookInfo : LocalBookInfo, completion : @escaping (String?) -> Void) {
        print("file path = \(bookInfo.localPath)")
        DispatchQueue.global().async {
            do {
                let encode = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
                let text = try String(contentsOfFile: bookInfo.localPath, encoding : String.Encoding(rawValue: encode))
                
//                let text = try String(contentsOfFile: bookInfo.localPath, usedEncoding: &String.Encoding(rawValue: encode))
                
                DispatchQueue.main.async {
                    return completion(text)
                }
            } catch let error as NSError {
                print("error = \(error.localizedDescription)")
                DispatchQueue.main.async {
                    return completion(nil)
                }
            }
        }
    }
}
