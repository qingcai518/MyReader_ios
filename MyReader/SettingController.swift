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
    var chapterInfos = [ChapterInfo]()
    
    @IBAction func doClose() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doAddBookmark() {
        
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
        self.present(next, animated: true, completion: nil)
    }
    
    @IBAction func doShowBookmarks() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
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
}

extension SettingController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view == topView || touch.view == bottomView) {
            return false
        }
        
        return true
    }
}
