//
//  AppConstants.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/20.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation
import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

let textWidth = screenWidth - 2 * 16
let textHeight = screenHeight - UIApplication.shared.statusBarFrame.size.height - 2 * 24

let baseUrl = "https://main-myreader.ssl-lolipop.jp"
let bookService = baseUrl + "/Books"

// 毎回リードするテキストファイルのサイズを指定する.
let readLength = 4096

struct NotificationName {
    static let FinishDownload = "FinishDownload"
}

enum DLStatus : Int {
    case downloading = 0
    case before = 1
    case after = 2
}
