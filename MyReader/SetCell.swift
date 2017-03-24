//
//  SetCell.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/21.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class SetCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLbl.text = nil
    }
}
