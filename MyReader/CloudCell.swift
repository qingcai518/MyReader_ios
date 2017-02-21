//
//  CloudCell.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/20.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit
import Cosmos

class CloudCell: UITableViewCell {
    @IBOutlet weak var bookImgView: UIImageView!
    @IBOutlet weak var bookNameLbl: UILabel!
    @IBOutlet weak var authorNameLbl: UILabel!
    @IBOutlet weak var cosmosView : CosmosView!
    @IBOutlet weak var detailLbl: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bookImgView.image = nil
        bookNameLbl.text = nil
        authorNameLbl.text = nil
        cosmosView.rating = 0.0
        cosmosView.text = nil
        detailLbl.text = nil
    }
}
