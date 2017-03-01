//
//  BookmarkCell.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/01.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class BookmarkCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timeLbl.text = nil
        contentLbl.text = nil
    }
}
