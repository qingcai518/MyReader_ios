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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func getData() {
        indicator.startAnimating()
        model.readFile(bookInfo: bookInfo) { [weak self] value in
            self?.indicator.stopAnimating()
            guard let text = value else {
                return
            }
            self?.setContents(text: text)
        }
    }

    private func setContents(text: String) {
        let letterSpacing = 1.0
        let lineSpacing = CGFloat(6.0)
        let font = UIFont.Helvetica16()
        
        let width = screenWidth - 2 * 16
        let height = screenHeight - UIApplication.shared.statusBarFrame.size.height - 2 * 24
        
        let letersPerLine = floor(Double(width / (font.pointSize + CGFloat(letterSpacing))))
        let lines = floor(Double(height / (font.lineHeight + lineSpacing)))

        var contents = [String]()
        let array = text.components(separatedBy: .newlines)
        for lineStr in array {
            if (Double(lineStr.characters.count) <= letersPerLine) {
                contents.append(lineStr)
            } else {
                var temp = lineStr
                while temp.characters.count > 20 {
                    let subText = (temp as NSString).substring(to: 20)
                    contents.append(subText)
                    temp = (temp as NSString).substring(from: 20)
                }
                
                if (temp != "") {
                    contents.append(temp)
                }
            }
        }
        
        var contentValue = ""
        let count = contents.count > Int(lines) ? Int(lines) : contents.count

        for i in 0..<count {
            let content = contents[i]
            contentValue.append(content)
            contentValue.append("\n")
        }
        
        let attributedText = NSMutableAttributedString(string: contentValue)
        let range = NSMakeRange(0, attributedText.length)
        
        // フォントを設定.
        attributedText.addAttribute(NSFontAttributeName, value: font, range: range)
        
        // 文字間間隔を設定.
        attributedText.addAttribute(NSKernAttributeName, value: letterSpacing, range: range)
        
        // 行間隔を設定.
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
        
        contentLbl.attributedText = attributedText
    }
}
