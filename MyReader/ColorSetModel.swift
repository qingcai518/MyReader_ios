//
//  SetBackgroundModel.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/24.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation
import UIKit

class ColorSetModel {
    var colorSets = [ColorSetInfo]()
    
    func setColorSets(completion : () -> Void) {
        let set1 = ColorSetInfo(color: UIColor.Read1(), name: "默认")
        let set2 = ColorSetInfo(color: UIColor.Read2(), name: "书香")
        let set3 = ColorSetInfo(color: UIColor.Read3(), name: "怀旧")
        let set4 = ColorSetInfo(color: UIColor.Read4(), name: "柔和")
        let set5 = ColorSetInfo(color: UIColor.Read5(), name: "羊皮纸")
        let set6 = ColorSetInfo(color: UIColor.Read6(), name: "护眼1")
        let set7 = ColorSetInfo(color: UIColor.Read7(), name: "护眼2")
        let set8 = ColorSetInfo(color: UIColor.Read8(), name: "护眼3")
        let set9 = ColorSetInfo(color: UIColor.Read9(), name: "护眼4")
        let set10 = ColorSetInfo(color: UIColor.Read10(), name: "护眼5")
        
        colorSets.append(set1)
        colorSets.append(set2)
        colorSets.append(set3)
        colorSets.append(set4)
        colorSets.append(set5)
        colorSets.append(set6)
        colorSets.append(set7)
        colorSets.append(set8)
        colorSets.append(set9)
        colorSets.append(set10)
        
        return completion()
    }
}
