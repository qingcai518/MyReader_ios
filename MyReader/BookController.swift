//
//  BookController.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/22.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class BookController: LeavesViewController {
    @IBOutlet weak var indicator : UIActivityIndicatorView!
    
    var bookInfo : LocalBookInfo!
    var pageContents = [NSMutableAttributedString]()
    
    let model = BookModel()
    let letterSpacing = 1.0
    let lineSpacing = CGFloat(6.0)
    let font = UIFont.Helvetica16()

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
        let letersPerLine = floor(Double(textWidth / (font.pointSize + CGFloat(letterSpacing))))
        let lines = floor(Double(textHeight / (font.lineHeight + lineSpacing)))
        
        print("leters per line = \(letersPerLine), lines = \(lines)")

        let array = text.components(separatedBy: .newlines)
        
        var contents = [String]()
        for lineStr in array {
            if (Double(lineStr.characters.count) <= letersPerLine) {
                contents.append(lineStr)
            }
            
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
        
        let count = contents.count > Int(lines) ? Int(lines) : contents.count
        
        var contentValue = ""
        for i in 0..<contents.count {
            let content = contents[i]

            if (i > 0 && i % count == 0) {
                self.addToPageContents(contentValue: contentValue)
                contentValue = ""
            } else {
                //
                old line.
                contentValue.append(content)
                contentValue.append("\n")
            }
        }
        
        if (contentValue != "") {
            self.addToPageContents(contentValue: contentValue)
        }
        
        for str in pageContents {
            print("str = \(str.string)")
        }

        leavesView.reloadData()
    }
    
    private func addToPageContents(contentValue : String) {
        let attributedText = NSMutableAttributedString(string: contentValue)
        let range = NSMakeRange(0, attributedText.length)
        
        // フォント.
        attributedText.addAttribute(NSFontAttributeName, value: font, range: range)
        
        // 文字間隔.
        attributedText.addAttribute(NSKernAttributeName, value: letterSpacing, range: range)
        
        // 行間隔.
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
        
        // 背景色.
        attributedText.addAttribute(NSBackgroundColorAttributeName, value: UIColor.clear, range: range)
        
        // 文字色.
        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: range)
        
        pageContents.append(attributedText)
    }
    
    // #program mark
    override func numberOfPagesInLeavesView(leavesView: LeavesView) -> Int {
        return pageContents.count
    }
    
    override func renderPageAtIndex(index: Int, inContext context: CGContext) {
        let text = pageContents[index]
        
        let imageRect = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)

        guard let image = AppUtility.imageWithText(attributedText: text, size: imageRect.size) else {
            return print("fail to get image.")
        }

        guard let cgImage = image.cgImage else {
            return
        }
        
        context.draw(cgImage, in: imageRect)
    }
}
