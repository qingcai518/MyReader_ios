

//
//  SetMore.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/21.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation

class SetMoreModel {
    var sections = [[SetMoreInfo]]()
    
    func getSetInfos(completion: @escaping (String?) -> Void) {
        let info1 = SetMoreInfo(title: "护眼模式")
        
        var animationMode = "经典"
        if let mode1 = UserDefaults.standard.object(forKey: UDKey.AnimationMode) as? String {
            animationMode = mode1
        }
        
        let info2 = SetMoreInfo(title: "翻页动画", rightText: animationMode)
        let info3 = SetMoreInfo(title: "阅读背景", rightText: "默认")
        let info4 = SetMoreInfo(title: "行间距", rightText: "默认")
        let info5 = SetMoreInfo(title: "页边距", rightText: "默认")
        let info6 = SetMoreInfo(title: "字体", rightText: "默认")
        let info7 = SetMoreInfo(title: "简体繁体切换", rightText: "默认")
        let info8 = SetMoreInfo(title: "初始设置")
        let info9 = SetMoreInfo(title: "清楚阅读进度")
        
        var section1Infos = [SetMoreInfo]()
        var section2Infos = [SetMoreInfo]()
        var section3Infos = [SetMoreInfo]()
        var section4Infos = [SetMoreInfo]()
        
        section1Infos.append(info1)
        
        section2Infos.append(info2)
        section2Infos.append(info3)
        section2Infos.append(info4)
        section2Infos.append(info5)
        
        section3Infos.append(info6)
        section3Infos.append(info7)
        
        section4Infos.append(info8)
        section4Infos.append(info9)
        
        sections.append(section1Infos)
        sections.append(section2Infos)
        sections.append(section3Infos)
        sections.append(section4Infos)
        
        return completion(nil)
    }
}
