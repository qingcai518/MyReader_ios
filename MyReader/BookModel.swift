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
                let text = try String(contentsOfFile: bookInfo.localPath, encoding: String.Encoding.shiftJIS)
                DispatchQueue.main.async {
                    return completion(text)
                }

                return completion(text)
            } catch let error as NSError {
                print("error = \(error.localizedDescription)")
                DispatchQueue.main.async {
                    return completion(nil)
                }
            }
        }
    }
}
