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

let baseUrl = "https://main-myreader.ssl-lolipop.jp"
let bookService = baseUrl + "/Books"

let readLength = 2048

struct NotificationName {
    static let FinishDownload = "FinishDownload"
}

enum DLStatus : Int {
    case downloading = 0
    case before = 1
    case after = 2
}
