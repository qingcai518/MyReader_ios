//
//  TempBookController.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/06.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit
import RxSwift

class BookController: UIPageViewController {
    var settingView: SettingView!
    
    // 現在の章の情報.
    let disposeBag = DisposeBag()
    var controllers = [PageController]()
    
    // params.
    var bookInfo : LocalBookInfo!
    var pageContents = [NSMutableAttributedString]()
    var chapterInfos = [ChapterInfo]()
    
    init(bookInfo: LocalBookInfo, pageContents: [NSMutableAttributedString], chapterInfos: [ChapterInfo]) {
        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        self.bookInfo = bookInfo
        self.pageContents = pageContents
        self.chapterInfos = chapterInfos
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setRecognizer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setView() {
        for content in pageContents {
            let storyboard = UIStoryboard(name: "Page", bundle: nil)
            guard let controller = storyboard.instantiateInitialViewController() as? PageController else {
                continue
            }
            
            controller.content = content
            self.controllers.append(controller)
        }
        
        if let firstController = controllers.first {
            self.setViewControllers([firstController], direction: .forward, animated: true, completion: nil)
        }
        
        self.dataSource = self
        self.delegate = self
        
        // setting view.
        let nib = UINib(nibName: "SettingView", bundle: nil)
        
        guard let setView = nib.instantiate(withOwner: self, options: nil).first as? SettingView else {
            return
        }
        
        settingView = setView
        settingView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        settingView.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        settingView.topView.transform = settingView.topView.transform.translatedBy(x: 0, y: -settingView.topView.bounds.height)
        settingView.bottomView.transform = settingView.bottomView.transform.translatedBy(x: 0, y: settingView.bottomView.bounds.height)
        settingView.isHidden = true
        
        // タイトル.
        settingView.titleLbl.text = bookInfo.bookName
        
        // bookmark追加ボタン.
        settingView.addBookmarkBtn.rx.tap.asObservable().bindNext { [weak self] in
            guard let info = self?.bookInfo else {return}
            
            let storyboard = UIStoryboard(name: "AddBookmark", bundle: nil)
            guard let next = storyboard.instantiateInitialViewController() as? AddBookmarkController else {
                return
            }
            
            next.modalPresentationStyle = .custom
            let currentPageNumber = AppUtility.getCurrentPage(bookId: info.bookId)
            next.pageNumber = AppUtility.getCurrentPage(bookId: info.bookId)
            if let contents = self?.pageContents {
                next.content = contents[currentPageNumber].string
            }
            next.bookId = info.bookId
            self?.present(next, animated: true, completion: nil)
        }.addDisposableTo(disposeBag)
        
        // close button.
        settingView.backBtn.rx.tap.asObservable().bindNext { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }.addDisposableTo(disposeBag)
        
        // bookmark表示ボタン.
        settingView.bookmarkBtn.rx.tap.asObservable().bindNext { [weak self] in
            let storyboard = UIStoryboard(name: "Bookmark", bundle: nil)
            guard let next = storyboard.instantiateInitialViewController() else {
                return
            }
            self?.present(next, animated: true, completion: nil)
        }.addDisposableTo(disposeBag)
        
        // 章の一覧を表示するボタン.
        settingView.listBtn.rx.tap.asObservable().bindNext { [weak self] in
            let storyboard = UIStoryboard(name: "Chapter", bundle: nil)
            guard let next = storyboard.instantiateInitialViewController() as? NavigationController else {
                return
            }
            
            guard let chapterController = next.viewControllers.first as? ChapterController else {
                return
            }
            
            guard let chapterInfos = self?.chapterInfos else {
                return
            }
            chapterController.chapterInfos = chapterInfos
            self?.present(next, animated: true, completion: nil)
        }.addDisposableTo(disposeBag)
        
        // bookmark一覧表示ボタン.
        settingView.bookmarkBtn.rx.tap.asObservable().bindNext { [weak self] in
            let storyboard = UIStoryboard(name: "Bookmark", bundle: nil)
            guard let next = storyboard.instantiateInitialViewController() else {
                return
            }
            
            self?.present(next, animated: true, completion: nil)
        }.addDisposableTo(disposeBag)
        self.view.addSubview(settingView)
    }
    
    private func setRecognizer() {
        let recognizer = UITapGestureRecognizer()
        recognizer.rx.event.bindNext { [weak self] sender in
            guard let setView = self?.settingView else {return}
            if (setView.isHidden) {
                self?.showSettingView()
            } else {
                self?.hideSettingView()
            }
        }.addDisposableTo(disposeBag)
        
        let tapView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: screenHeight))
        tapView.center = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        tapView.backgroundColor = UIColor.clear
        self.view.addSubview(tapView)
        tapView.addGestureRecognizer(recognizer)
    }
    
    private func showSettingView() {
        self.setChapterInfo()
        
        settingView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let setView = self?.settingView else {return}
            setView.topView.transform = setView.topView.transform.translatedBy(x: 0, y: setView.topView.bounds.height)
            setView.bottomView.transform = setView.bottomView.transform.translatedBy(x: 0, y: -setView.bottomView.bounds.height)
        }, completion: nil)
    }
    
    private func hideSettingView() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let setView = self?.settingView else {return}
            setView.topView.transform = setView.topView.transform.translatedBy(x: 0, y: -setView.topView.bounds.height)
            setView.bottomView.transform = setView.bottomView.transform.translatedBy(x: 0, y: setView.bottomView.bounds.height)
        }) { [weak self] isFinished in
            if (isFinished) {
                self?.settingView.isHidden = true
            }
        }
    }
    
    private func setChapterInfo() {
        let currentIndex = AppUtility.getCurrentPage(bookId: bookInfo.bookId)
        
        var chapterNumber : Int!
        for chapterInfo in chapterInfos {
            let chapterName = chapterInfo.chapterName
            let startIndex = chapterInfo.startPage
            let endIndex = chapterInfo.endPage
            
            if (currentIndex >= startIndex && currentIndex <= endIndex) {
                self.settingView.chapterLbl.text = chapterName
                chapterNumber = chapterInfo.chapterNumber
                
                // slideの内容を設定する.
                if (endIndex > startIndex) {
                    settingView.slider.maximumValue = Float(endIndex - startIndex)
                    settingView.slider.value = Float(currentIndex - startIndex)
                } else {
                    settingView.slider.value = 1.0
                }
                
                break
            }
        }
        
        if (chapterNumber == nil) {
            return
        }
        
        settingView.preBtn.isEnabled = chapterNumber != 0
        settingView.nextBtn.isEnabled = chapterNumber != chapterInfos.count - 1
    }
}

extension BookController : UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print("finish change page.")
    }
}

extension BookController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageController = viewController as? PageController else {return nil}
        guard let index = self.controllers.index(of: pageController) else {return nil}
        if (index > 0) {
            return self.controllers[index - 1]
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageController = viewController as? PageController else {return nil}
        guard let index = self.controllers.index(of: pageController) else {return nil}
        if (index < self.controllers.count - 1) {
            return self.controllers[index + 1]
            
        } else {
            return nil
        }
    }
}
