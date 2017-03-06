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
    // 現在の章の情報.
    let disposeBag = DisposeBag()
    var currentChapter = Variable("")
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
//        setRecognizer()
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
        
        print("controllers =\(controllers.count) ")
        
        self.dataSource = self
    }
    
//    private func setRecognizer() {
//        let recognizer = UITapGestureRecognizer()
//        recognizer.rx.event.bindNext { sender in
//            let storyboard = UIStoryboard(name: "Setting", bundle: nil)
//            guard let next = storyboard.instantiateInitialViewController() as? SettingController else {
//                return
//            }
//            
//            let currentPage = AppUtility.getCurrentPage(bookId: self.bookInfo.bookId)
//            let currentContent = self.pageContents[currentPage].string
//            
//            next.modalPresentationStyle = .custom
//            next.bookInfo = self.bookInfo
//            next.content = currentContent
//            next.pageNumber = currentPage
//            next.chapterInfos = self.chapterInfos
//            self.present(next, animated: true, completion: nil)
//        }.addDisposableTo(disposeBag)
//        recognizer.delegate = self
//        self.view.addGestureRecognizer(recognizer)
//    }
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

//extension BookController : UIGestureRecognizerDelegate {
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        let location = touch.location(in: self.view)
//        
//        if ((location.x < (screenWidth - 44) / 2) || (location.x > (screenWidth + 44) / 2)) {
//            return false
//        }
//        
//        return true
//    }
//}
