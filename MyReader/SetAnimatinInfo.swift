//
//  SetAnimatinInfo.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/21.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SetAnimationInfo {
    var title: String
    var isChecked = Variable(false)
    
    init(title: String) {
        self.title = title
    }
}
