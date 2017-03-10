//
//  AppConstants.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/20.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

let textWidth = screenWidth - 2 * 16
let textHeight = screenHeight - UIApplication.shared.statusBarFrame.size.height - 2 * 24

let baseUrl = "https://main-myreader.ssl-lolipop.jp"
let bookService = baseUrl + "/Books"

// 阅读模式.   夜间/白天
var isNightMode = Variable(UserDefaults.standard.bool(forKey: UDKey.LightMode))

// 本の基本情報.
let letterSpacing = 1.0   // 文字間隔
let lineSpacing = CGFloat(6.0)  // 行間隔
let font = UIFont.Helvetica18()  // フォント

struct NotificationName {
    static let FinishDownload = "FinishDownload"
    static let ChangeChapter = "ChangeChapter"
}

enum DLStatus : Int {
    case downloading = 0
    case before = 1
    case after = 2
}

let lightModeDay = 0
let lightModeNight = 1

struct UDKey {
    static let CurrentPage = "CurrentPage"
    static let LightMode = "LightMode"
}
