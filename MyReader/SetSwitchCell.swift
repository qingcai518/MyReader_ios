//
//  SetSwitchCell.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/21.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class SetSwitchCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    
    @IBAction func doChangeValue() {
        let value = switchBtn.isOn
        print("value = \(value)")
        
        UserDefaults.standard.set(value, forKey: UDKey.IsSafeMode)
        UserDefaults.standard.synchronize()

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLbl.text = nil
    }
}
