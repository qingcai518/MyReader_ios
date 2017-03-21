

//
//  SetMore.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/21.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation

class SetMoreModel {
    var section1Infos = [SetMoreInfo]()
    var section2Infos = [SetMoreInfo]()
    var section3Infos = [SetMoreInfo]()
    var section4Infos = [SetMoreInfo]()
    
    func getSetInfos(completion: @escaping (String?) -> Void) {
        let info1 = SetMoreInfo(name: "护眼模式", type: SetType.Switch)
        let info2 = SetMoreInfo(name: "翻页动画", type: SetType.Right)
        let info3 = SetMoreInfo(name: "阅读背景", type: SetType.Right)
        let info4 = SetMoreInfo(name: "行间距", type: SetType.Right)
        let info5 = SetMoreInfo(name: "页边距", type: SetType.Right)
        let info6 = SetMoreInfo(name: "字体", type: SetType.Right)
        let info7 = SetMoreInfo(name: "简体繁体切换", type: SetType.Right)
        let info8 = SetMoreInfo(name: "初始设置", type: SetType.Normal)
        let info9 = SetMoreInfo(name: "清楚阅读进度", type: SetType.Normal)
        
        section1Infos.append(info1)
        section2Infos.append(info2)
        section2Infos.append(info3)
        section2Infos.append(info4)
        section2Infos.append(info5)
        section3Infos.append(info6)
        section3Infos.append(info7)
        section4Infos.append(info8)
        section4Infos.append(info9)
        
        return completion(nil)
    }
}
