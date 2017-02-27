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
    let model = BookModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = bookInfo.bookName
        getData()
        addGestureRecognizer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func getData() {
        self.view.bringSubview(toFront: indicator)
        indicator.startAnimating()
        model.readFile(bookInfo: bookInfo) { [weak self] value in
            self?.indicator.stopAnimating()
            self?.leavesView.reloadData()
        }
    }
    
    private func addGestureRecognizer() {
        let recognizer = UITapGestureRecognizer()
        recognizer.rx.event.asObservable().bindNext { sender in
            print("tap the screen.")
        }.addDisposableTo(disposeBag)
        self.view.addGestureRecognizer(recognizer)
    }
    
    // #program mark
    override func numberOfPagesInLeavesView(leavesView: LeavesView) -> Int {
        return model.pageContents.count
    }
    
    override func renderPageAtIndex(index: Int, inContext context: CGContext) {
        let text = model.pageContents[index]

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
