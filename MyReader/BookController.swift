//
//  BookController.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/22.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class BookController: ViewController {
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var indicator : UIActivityIndicatorView!
    
    var bookInfo : LocalBookInfo!
    
    let model = BookModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func getData() {
        indicator.startAnimating()
        model.readFile(bookInfo: bookInfo) { [weak self] value in
            self?.indicator.stopAnimating()
            guard let text = value else {return}
            self?.contentLbl.text = text
        }
    }
}
