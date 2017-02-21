//
//  BooksCell.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/20.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class BooksCell: UICollectionViewCell {
    @IBOutlet weak var bookImgView : UIImageView!
    @IBOutlet weak var bookNameLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bookImgView.image = nil
        bookNameLbl.text = nil
        authorLbl.text = nil
    }
}
