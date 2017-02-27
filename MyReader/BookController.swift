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
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bottomView : UIView!
    @IBOutlet weak var tapView: UIView!
    
    var disposeBag = DisposeBag()
    var bookInfo : LocalBookInfo!
    let model = BookModel()

    @IBAction func doClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        addGestureRecognizer()
        setPopupView()
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
    
    private func setPopupView() {
        titleLbl.text = bookInfo.bookName
        topView.transform = topView.transform.translatedBy(x: 0, y: -topView.bounds.height)
        bottomView.transform = bottomView.transform.translatedBy(x: 0, y: bottomView.bounds.height)
    }
    
    private func addGestureRecognizer() {
        let recognizer = UITapGestureRecognizer()
        recognizer.rx.event.asObservable().bindNext { [weak self] sender in
            guard let top = self?.topView else {
                return
            }
            
            guard let bottom = self?.bottomView else {
                return
            }
            
            self?.view.bringSubview(toFront: top)
            self?.view.bringSubview(toFront: bottom)
            
            if (top.isHidden) {
                top.isHidden = false
                bottom.isHidden = false
                
                UIView.animate(withDuration: 0.3, animations: {
                    top.transform = top.transform.translatedBy(x: 0, y: top.bounds.height)
                    bottom.transform = bottom.transform.translatedBy(x: 0, y: -bottom.bounds.height)
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    top.transform = top.transform.translatedBy(x: 0, y: -top.bounds.height)
                    bottom.transform = bottom.transform.translatedBy(x: 0, y: bottom.bounds.height)
                }, completion: { isFinished in
                    if (isFinished) {
                        top.isHidden = true
                        bottom.isHidden = true
                    }
                })
            }
            
        }.addDisposableTo(disposeBag)
        self.tapView.addGestureRecognizer(recognizer)
        self.view.bringSubview(toFront: tapView)
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
