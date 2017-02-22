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
import RxSwift

class CloudDetailModel {
    var isDownloaded = Variable(DLStatus.before)
    var progressValue = Variable(0.0)
    
    func isDownloaded(bookId: String) {
        if let _ = SQLiteManager.sharedInstance.selectBookById(bookId: bookId) {
            isDownloaded.value = .after
        } else {
            isDownloaded.value = .before
        }
    }
    
    func downloadFile(bookInfo: CloudBookInfo) {
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        let fileSize = AppUtility.getFileSize(fileSize: bookInfo.fileSize)
        isDownloaded.value = DLStatus.downloading
        
        Alamofire.download(
            bookInfo.bookUrl,
            method: .get,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                
                let completed = progress.completedUnitCount
                self.progressValue.value = 100 * Double(completed) / Double(fileSize)
                
                print("progress value = \(self.progressValue.value)")
                
            }).response(completionHandler: { [weak self] response in
                guard var localPath = response.destinationURL?.absoluteString else {return}
                if (localPath.contains("file://")) {
                    let index = localPath.index(localPath.startIndex, offsetBy: 7)
                    localPath = localPath.substring(from: index)
                }
                
                SQLiteManager.sharedInstance.insertBook(localPath: localPath, bookInfo: bookInfo)
                
                // 通知する.
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.FinishDownload), object: nil)
                
                // ダウンロード完了のフラグを設定する.
                self?.isDownloaded.value = DLStatus.after
            })
    }
}
