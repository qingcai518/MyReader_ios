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
    @IBOutlet weak var chapterLbl: UILabel!
    @IBOutlet weak var preBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var tapView: UIView!
    
    var disposeBag = DisposeBag()
    var bookInfo : LocalBookInfo!
    let model = BookModel()
    
    @IBAction func doClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toPreChapter() {
        let currentIndex = UserDefaults.standard.integer(forKey: UDKey.CurrentPage)
        var preInfo : ChapterInfo!
        
        for chapterInfo in model.chapterInfos {
            let startIndex = chapterInfo.startPage
            let endIndex = chapterInfo.endPage
            
            if (currentIndex >= startIndex && currentIndex <= endIndex) {
                break
            }
            preInfo = chapterInfo
        }
        
        if (preInfo != nil) {
            let startIndex = preInfo.startPage
            self.leavesView.reloadData()
            self.leavesView.currentPageIndex = startIndex
            
            // 現在のページを設定する.
            UserDefaults.standard.set(startIndex, forKey: UDKey.CurrentPage)
            UserDefaults.standard.synchronize()
            
            // 章の名前を設定する.
            self.chapterLbl.text = preInfo.chapterName
            
            // slideの値を設定する.
            
            // ボタンの活性非活性を設定する.
            self.preBtn.isEnabled = preInfo.chapterNumber != 0
            self.nextBtn.isEnabled = preInfo.chapterNumber != model.chapterInfos.count - 1
        }
    }
    
    @IBAction func toNextChapter() {
        
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
            
            // 前回読み込んだページ数を取得する.
            let currentIndex = UserDefaults.standard.integer(forKey: UDKey.CurrentPage)
            self?.leavesView.reloadData()
            self?.leavesView.currentPageIndex = currentIndex
            
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
                self?.setChapterInfo()
                
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
    
    private func setChapterInfo() {
        let currentIndex = UserDefaults.standard.integer(forKey: UDKey.CurrentPage)

        var chapterNumber : Int!
        for chapterInfo in model.chapterInfos {
            let chapterName = chapterInfo.chapterName
            let startIndex = chapterInfo.startPage
            let endIndex = chapterInfo.endPage
            
            
            if (currentIndex >= startIndex && currentIndex <= endIndex) {
                self.chapterLbl.text = chapterName
                chapterNumber = chapterInfo.chapterNumber
                break
            }
        }
        
        if (chapterNumber == nil) {
            return
        }
        
        preBtn.isEnabled = chapterNumber != 0
        nextBtn.isEnabled = chapterNumber != model.chapterInfos.count - 1
    }

    // #program mark  delegate.
    override func leavesView(leavesView: LeavesView, willTurnToPageAtIndex pageIndex: Int) {
    }
    
    override func leavesView(leavesView: LeavesView, didTurnToPageAtIndex pageIndex: Int) {
        // 現在のページ数を保存する.
        UserDefaults.standard.set(pageIndex, forKey: UDKey.CurrentPage)
        UserDefaults.standard.synchronize()
    }

    // #program mark  dataSource.
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
