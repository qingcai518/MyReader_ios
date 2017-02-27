//
//  BookController.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/22.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit
import RxSwift

class BookController: LeavesViewController {
    @IBOutlet weak var indicator : UIActivityIndicatorView!
    
    var disposeBag = DisposeBag()
    var bookInfo : LocalBookInfo!
    var pageContents = [NSMutableAttributedString]()
    
    let model = BookModel()
    let letterSpacing = 1.0
    let lineSpacing = CGFloat(6.0)
//    let font = UIFont.Helvetica16()
    let font = UIFont.Helvetica18()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = bookInfo.bookName
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setNotificationRecivers() {
        NotificationCenter.default.rx.notification(Notification.Name.NSFileHandleReadToEndOfFileCompletion).bindNext { [weak self] sender in
            guard let data = sender.userInfo?["NSFileHandleNotificationDataItem"] as? Data else {
                return print("can not get data.")
            }
            
            let readStr = AppUtility.getStringFromData(data: data)
            self?.setContents(text: readStr)
            
        }.addDisposableTo(disposeBag)
    }
    
//    private func setNotificationRecievers() {
//        NotificationCenter.default.rx.notification(Notification.Name.NSFileHandleReadToEndOfFileCompletion).bindNext { [weak self] notification in
//            self?.indicator.stopAnimating()
//            guard let data = notification.userInfo?["NSFileHandleNotificationDataItem"] as? Data else {
//                return print("can not get data.")
//            }
//            
//            let encode = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.macChineseSimp.rawValue))
//            
//            guard let readStr = String.init(data: data, encoding: String.Encoding(rawValue: encode)) else {
//                return print("can not get string from data.")
//            }
//            
//            self?.setContents(text: readStr)
//        }.addDisposableTo(disposeBag)
//    }

//    private func getData() {
//        indicator.startAnimating()
//        model.readFile(bookInfo: bookInfo) { [weak self] value in
//            self?.indicator.stopAnimating()
//            guard let text = value else {
//                return
//            }
//            self?.setContents(text: text)
//        }
//    }
    
    private func getData() {
        indicator.startAnimating()
        model.readFile(bookInfo: bookInfo)
    }

    private func setContents(text: String?) {
        guard let content = text else {
            self.indicator.stopAnimating()
            return
        }
        
        let letersPerLine = Int(floor(Double(textWidth / (font.pointSize + CGFloat(letterSpacing)))))
        let lines = floor(Double(textHeight / (font.lineHeight + lineSpacing)))
        print("leters per line = \(letersPerLine), lines = \(lines)")

        let array = content.components(separatedBy: .newlines)
        
        var contents = [String]()
        for lineStr in array {
            if (lineStr.characters.count <= letersPerLine) {
                contents.append(lineStr)
            } else {
                var temp = lineStr
                while temp.characters.count > letersPerLine {
                    let subText = (temp as NSString).substring(to: letersPerLine)
                    contents.append(subText)
                    temp = (temp as NSString).substring(from: letersPerLine)
                }
                
                if (temp != "") {
                    contents.append(temp)
                }
            }
        }
        
        let count = contents.count > Int(lines) ? Int(lines) : contents.count
        
        var contentValue = ""
        for i in 0..<contents.count {
            let content = contents[i]

            if (i > 0 && i % count == 0) {
                self.addToPageContents(contentValue: contentValue)
                contentValue = ""
            }
            
            contentValue.append(content)
            contentValue.append("\n")
        }
        
        if (contentValue != "") {
            self.addToPageContents(contentValue: contentValue)
        }
        
        for str in pageContents {
            print("str = \(str.string)")
        }

        leavesView.reloadData()
        self.indicator.stopAnimating()
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
