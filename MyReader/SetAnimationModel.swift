//
//  SetAnimationModel.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/21.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SetAnimationModel {
    var infos = [SetAnimationInfo]()
    
    func getInfos(completion : @escaping (String?) -> Void) {
        let info1 = SetAnimationInfo(title: "经典")
        let info2 = SetAnimationInfo(title: "左右")
        
        infos.append(info1)
        infos.append(info2)
        
        return completion(nil)
    }
}
