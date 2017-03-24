//
//  ColorSetCell.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/24.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class ColorSetCell: UITableViewCell {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var checkImgView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLbl.text = nil
    }
}
