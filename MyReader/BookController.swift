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
        
        self.title = bookInfo.bookName
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
            self?.setContents(text: text)
        }
    }

    private func setContents(text: String) {
        let letterSpacing = 10.0
        
        
        // 文字間間隔を設定.
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSKernAttributeName, value: letterSpacing, range: NSMakeRange(0, attributedText.length))
        
        // 行間隔を設定.
        
        
        contentLbl.text = text
    }
}
