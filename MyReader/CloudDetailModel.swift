//
//  CloudDetailModel.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/21.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation
import Alamofire
import SQLite

class CloudDetailModel {
    func downloadFile(bookInfo: CloudBookInfo) {
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        Alamofire.download(
            bookInfo.bookUrl,
            method: .get,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                print("progress = \(progress)")
            }).response(completionHandler: { response in
                guard let localPath = response.destinationURL?.absoluteString else {return}
                SQLiteManager.sharedInstance.insertBook(localPath: localPath, bookInfo: bookInfo)
                
                // 通知する.
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.FinishDownload), object: nil)
            })
    }
}
