//
//  ChapterCell.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/01.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class ChapterCell: UITableViewCell {
    @IBOutlet weak var chapterNameLbl : UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        chapterNameLbl.text = nil
    }
}
