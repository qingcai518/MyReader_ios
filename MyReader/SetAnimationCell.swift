//
//  SetAnimationCell.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/21.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class SetAnimationCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var checkImgView: UIImageView!
    
    override func prepareForReuse() {
        titleLbl.text = nil
        checkImgView.image = nil
    }
}
