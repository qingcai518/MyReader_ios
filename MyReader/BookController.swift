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
    var tapView = UIView()
    
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
        
        setRecieveNotification()
        setView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setRecieveNotification() {
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: NotificationName.ChangeChapter)).bindNext { [weak self] notification in
            guard let bookId = self?.bookInfo.bookId else {return}
            let currentPage = AppUtility.getCurrentPage(bookId: bookId)
            
            guard let viewController = self?.controllers[currentPage] else {
                return
            }

            self?.setViewControllers([viewController], direction: .reverse, animated: false, completion: nil)
        }.addDisposableTo(disposeBag)
    }
    
    private func setView() {
        self.modalTransitionStyle = .crossDissolve
        
        for i in 0..<pageContents.count {
            let content = pageContents[i]
            let storyboard = UIStoryboard(name: "Page", bundle: nil)
            guard let controller = storyboard.instantiateInitialViewController() as? PageController else {
                continue
            }
            
            controller.content = content
            controller.view.tag = i
            self.controllers.append(controller)
        }
        
        let currentPage = AppUtility.getCurrentPage(bookId: bookInfo.bookId)
        let currentController = controllers[currentPage]
        self.setViewControllers([currentController], direction: .forward, animated: true, completion: nil)
        
        self.dataSource = self
        self.delegate = self
    }
    
    fileprivate func openSettingPage() {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        guard let next = storyboard.instantiateInitialViewController() as? SettingController else {return}
        next.modalPresentationStyle = .custom
        
        // パラメータを設定する.
        next.chapterInfos = self.chapterInfos
        next.bookInfo = self.bookInfo
        next.pageContents = self.pageContents
        
        self.present(next, animated: true, completion: nil)
    }
}

extension BookController : UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let index = pageViewController.viewControllers?.first?.view.tag else {
            return
        }
        
        AppUtility.saveCurrentPage(bookId: bookInfo.bookId, pageIndex: index)
        
//        self.setChapterInfo()
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

extension BookController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let _ = gestureRecognizer as? UITapGestureRecognizer {
            let touchPoint = touch.location(in: self.view)
            
            let startX = (screenWidth - 100) / 2
            let endX = (screenWidth + 100) / 2
            let touchX = touchPoint.x
            
            if (touchX >= startX && touchX <= endX) {
                openSettingPage()
                return false
            }
        }
        
        return true
    }
}
