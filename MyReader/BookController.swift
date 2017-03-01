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
    @IBOutlet weak var listBtn: UIButton!
    @IBOutlet weak var bookmarkBtn: UIButton!
    @IBOutlet weak var lightBtn: UIButton!
    @IBOutlet weak var fontBtn: UIButton!
    
    @IBOutlet weak var tapView: UIView!
    
    var disposeBag = DisposeBag()
    var bookInfo : LocalBookInfo!
    let model = BookModel()
    
    var lightMode = Variable(UserDefaults.standard.integer(forKey: UDKey.LightMode))
    
    @IBAction func showList() {
        
    }
    
    @IBAction func showBookmarks() {
        
    }
    
    @IBAction func switchLight() {
        lightMode.value = abs(lightMode.value - 1)
    }
    
    @IBAction func showSettings() {
        
    }
    
    @IBAction func doClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doSlider(sender: UISlider) {
        let currentIndex = self.getCurrentPage()
        var currentChapter : ChapterInfo!
        for chapterInfo in model.chapterInfos {
            let startIndex = chapterInfo.startPage
            let endIndex = chapterInfo.endPage
            
            if (currentIndex >= startIndex && currentIndex <= endIndex) {
                currentChapter = chapterInfo
                break
            }
        }
        
        if (currentChapter == nil) {
            return
        }
        
        let pageIndex = currentChapter.startPage + Int(ceil(sender.value))
        
        leavesView.reloadData()
        leavesView.currentPageIndex = pageIndex
        
        // 現在のページを保存する.
        self.saveCurrentPage(pageIndex: pageIndex)
    }
    
    @IBAction func toPreChapter() {
        let currentIndex = self.getCurrentPage()
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
            
            // 現在のページを保存する.
            self.saveCurrentPage(pageIndex: startIndex)
            
            // 章の名前を設定する.
            self.chapterLbl.text = preInfo.chapterName
            
            // slideの値を設定する.
            slider.maximumValue = Float(preInfo.endPage - startIndex)
            slider.value = 1.0
            
            // ボタンの活性非活性を設定する.
            self.preBtn.isEnabled = preInfo.chapterNumber != 0
            self.nextBtn.isEnabled = preInfo.chapterNumber != model.chapterInfos.count - 1
        }
    }
    
    @IBAction func toNextChapter() {
        let currentIndex = self.getCurrentPage()
        var nextInfo : ChapterInfo!
        
        for i in (0..<model.chapterInfos.count).reversed() {
            let chapterInfo = model.chapterInfos[i]
            let startIndex = chapterInfo.startPage
            let endIndex = chapterInfo.endPage
            
            if (currentIndex >= startIndex && currentIndex <= endIndex) {
                break
            }
            
            nextInfo = chapterInfo
        }
        
        if (nextInfo != nil) {
            let startIndex = nextInfo.startPage
            self.leavesView.reloadData()
            self.leavesView.currentPageIndex = startIndex
            
            // 現在のページを保存する.
            self.saveCurrentPage(pageIndex: startIndex)
            
            // 章の名前を設定する.
            self.chapterLbl.text = nextInfo.chapterName
            
            // slideの値を設定する.
            slider.maximumValue = Float(nextInfo.endPage - startIndex)
            slider.value = 1.0
            
            // ボタンの活性・非活性を設定する.
            self.preBtn.isEnabled = nextInfo.chapterNumber != 0
            self.nextBtn.isEnabled = nextInfo.chapterNumber != model.chapterInfos.count - 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初期状態を設定する.
        setInitStatus()
        
        getData()
        addGestureRecognizer()
        setPopupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setInitStatus() {
        lightMode.asObservable().bindNext { [weak self] value in
            if (value == lightModeDay) {
                self?.setBackgroundColor(color: UIColor.white)
            } else {
                self?.setBackgroundColor(color: UIColor.black)
            }
            
            UserDefaults.standard.set(value, forKey: UDKey.LightMode)
            UserDefaults.standard.synchronize()
        }.addDisposableTo(disposeBag)
    }
    
    private func setBackgroundColor(color : UIColor) {
        leavesView.topPage.backgroundColor = color.cgColor
        leavesView.topPageReverse.backgroundColor = color.cgColor
        leavesView.bottomPage.backgroundColor = color.cgColor
    }

    private func getData() {
        self.view.bringSubview(toFront: indicator)
        indicator.startAnimating()
        model.readFile(bookInfo: bookInfo) { [weak self] value in
            self?.indicator.stopAnimating()
            
            // 前回読み込んだページ数を取得する.
            guard let currentIndex = self?.getCurrentPage() else {return}
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
        let currentIndex = self.getCurrentPage()

        var chapterNumber : Int!
        for chapterInfo in model.chapterInfos {
            let chapterName = chapterInfo.chapterName
            let startIndex = chapterInfo.startPage
            let endIndex = chapterInfo.endPage
            
            
            if (currentIndex >= startIndex && currentIndex <= endIndex) {
                self.chapterLbl.text = chapterName
                chapterNumber = chapterInfo.chapterNumber
                
                // slideの内容を設定する.
                if (endIndex > startIndex) {
                    slider.maximumValue = Float(endIndex - startIndex)
                    slider.value = Float(currentIndex - startIndex)
                } else {
                    slider.value = 1.0
                }

                break
            }
        }
        
        if (chapterNumber == nil) {
            return
        }
        
        // ボタンの活性・非活性を設定する.
        preBtn.isEnabled = chapterNumber != 0
        nextBtn.isEnabled = chapterNumber != model.chapterInfos.count - 1
    }
    
    private func saveCurrentPage(pageIndex: Int) {
        UserDefaults.standard.set(pageIndex, forKey: UDKey.CurrentPage + "_" + bookInfo.bookId)
        UserDefaults.standard.synchronize()
    }
    
    private func getCurrentPage() -> Int {
        return UserDefaults.standard.integer(forKey: UDKey.CurrentPage + "_" + bookInfo.bookId)
    }

    // #program mark  delegate.
    override func leavesView(leavesView: LeavesView, willTurnToPageAtIndex pageIndex: Int) {
    }
    
    override func leavesView(leavesView: LeavesView, didTurnToPageAtIndex pageIndex: Int) {
        // 現在のページ数を保存する.
        self.saveCurrentPage(pageIndex: pageIndex)
        
        if (!topView.isHidden) {
            // popViewが表示される際に、更新を実施する.
            setChapterInfo()
        }
    }

    // #program mark  dataSource.
    override func numberOfPagesInLeavesView(leavesView: LeavesView) -> Int {
        return model.pageContents.count
    }
    
    override func renderPageAtIndex(index: Int, inContext context: CGContext) {
        let text = model.pageContents[index]
        let imageRect = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        guard let image = AppUtility.imageWithText(attributedText: text, size: imageRect.size, context: context) else {
            return print("fail to get image.")
        }

        guard let cgImage = image.cgImage else {
            return
        }

        context.draw(cgImage, in: imageRect)
    }
}
