//
//  CloudDetailCell.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/21.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit
import Cosmos
import RxSwift

class CloudDetailCell: UITableViewCell {
    @IBOutlet weak var bookImgView : UIImageView!
    @IBOutlet weak var bookNameLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var cosmosView : CosmosView!
    @IBOutlet weak var downloadBtn : UIButton!
    @IBOutlet weak var detailLbl: UILabel!
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
