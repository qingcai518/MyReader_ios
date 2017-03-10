//
//  SettingController.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/08.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class SettingController: ViewController {
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
    @IBOutlet weak var addBookmarkBtn: UIButton!
    
    // params.
    var bookInfo : LocalBookInfo!
    var chapterInfos = [ChapterInfo]()
    var pageContents = [NSMutableAttributedString]()
    
    @IBAction func doClose() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doAddBookmark() {
        let storyboard = UIStoryboard(name: "AddBookmark", bundle: nil)
        guard let next = storyboard.instantiateInitialViewController() as? AddBookmarkController else {
            return
        }
        
        next.bookId = bookInfo.bookId
        let pageNumber = AppUtility.getCurrentPage(bookId: bookInfo.bookId)
        next.pageNumber = pageNumber
        next.content = self.pageContents[pageNumber].string
        
        self.present(next, animated: true, completion: nil)
    }
    
    @IBAction func doShowChapters() {
        let storyboard = UIStoryboard(name: "Chapter", bundle: nil)
        guard let next = storyboard.instantiateInitialViewController() as? NavigationController else {
            return
        }
        
        guard let chapterController = next.viewControllers.first as? ChapterController else {
            return
        }
        
        chapterController.chapterInfos = self.chapterInfos
        chapterController.bookInfo = self.bookInfo
        self.present(next, animated: true, completion: nil)
    }
    
    @IBAction func doShowBookmarks() {
        let storyboard = UIStoryboard(name: "Bookmark", bundle: nil)
        guard let next = storyboard.instantiateInitialViewController() else {
            return
        }
        
        self.present(next, animated: true, completion: nil)
    }
    
    @IBAction func itemSlider(slider: UISlider, event: UIEvent) {
        guard let touch = event.allTouches?.first else {return}
        if (touch.phase != .moved && touch.phase != .began) {
            guard let currentChapter = AppUtility.getCurrentChapter(bookId: bookInfo.bookId, chapterInfos: chapterInfos) else {
                return
            }
            
            let pageIndex = currentChapter.startPage + Int(ceil(slider.value))
            AppUtility.saveCurrentPage(bookId: bookInfo.bookId, pageIndex: pageIndex)
            
            // 画面の通知を実施する.
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.ChangeChapter), object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func toNext(_ sender: UIButton) {
        guard let currentChapter = AppUtility.getCurrentChapter(bookId: bookInfo.bookId, chapterInfos: chapterInfos) else {
            return
            
        }
        
        let currentChapterNumber = currentChapter.chapterNumber
        let nextChapterNumber = currentChapterNumber + 1
        if (nextChapterNumber >= self.chapterInfos.count) {
            return
        }
        
        let nextChapter = self.chapterInfos[nextChapterNumber]
        let pageNumber = nextChapter.startPage
        AppUtility.saveCurrentPage(bookId: bookInfo.bookId, pageIndex: pageNumber)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.ChangeChapter), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toPre(_ sender: UIButton) {
        guard let currentChapter = AppUtility.getCurrentChapter(bookId: bookInfo.bookId, chapterInfos: chapterInfos) else {
            return
        }
        
        let currentChapterNumber = currentChapter.chapterNumber
        let preChapterNumber = currentChapterNumber - 1
        
        if (preChapterNumber < 0 ) {
            return
        }
        
        let preChapter = self.chapterInfos[preChapterNumber]
        let pageNumber = preChapter.startPage
        
        AppUtility.saveCurrentPage(bookId: bookInfo.bookId, pageIndex: pageNumber)

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.ChangeChapter), object: nil)
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setChapterInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTopAndBottomViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideTopAndBottomViews()
    }
    
    private func setView() {
        self.titleLbl.text = bookInfo.bookName
        
        self.view.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        topView.transform = topView.transform.translatedBy(x: 0, y: -topView.bounds.height)
        bottomView.transform = bottomView.transform.translatedBy(x: 0, y: bottomView.bounds.height)
        
        let recognizer = UITapGestureRecognizer()
        recognizer.rx.event.bindNext { [weak self] sender in
            self?.dismiss(animated: true, completion: nil)
        }.addDisposableTo(disposeBag)
        recognizer.delegate = self
        self.view.addGestureRecognizer(recognizer)
    }
    
    private func showTopAndBottomViews() {
        topView.isHidden = false
        bottomView.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let top = self?.topView else {return}
            guard let bottom = self?.bottomView else {return}
            top.transform = top.transform.translatedBy(x: 0, y: top.bounds.height)
            bottom.transform = bottom.transform.translatedBy(x: 0, y: -bottom.bounds.height)
        }, completion: nil)
    }
    
    private func hideTopAndBottomViews() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let top = self?.topView else {return}
            guard let bottom = self?.bottomView else {return}
            top.transform = top.transform.translatedBy(x: 0, y: -top.bounds.height)
            bottom.transform = bottom.transform.translatedBy(x: 0, y: bottom.bounds.height)
        }) { [weak self] isFinished in
            if (isFinished) {
                self?.topView.isHidden = true
                self?.bottomView.isHidden = true
            }
        }
    }
    
    private func setChapterInfo() {
        guard let currentChapter = AppUtility.getCurrentChapter(bookId: bookInfo.bookId, chapterInfos: chapterInfos) else {
            return
        }
        
        let currentPage = AppUtility.getCurrentPage(bookId: bookInfo.bookId)
        let chapterName = currentChapter.chapterName
        let chapterNumber = currentChapter.chapterNumber
        let startPage = currentChapter.startPage
        let endPage = currentChapter.endPage
        
        self.chapterLbl.text = chapterName
        
        if (endPage > startPage) {
            slider.maximumValue = Float(endPage - startPage)
            slider.value = Float(currentPage - startPage)
        } else {
            slider.value = 1.0
        }

        preBtn.isEnabled = chapterNumber != 0
        nextBtn.isEnabled = chapterNumber != chapterInfos.count - 1
    }
}

extension SettingController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view == topView || touch.view == bottomView) {
            return false
        }
        
        return true
    }
}
