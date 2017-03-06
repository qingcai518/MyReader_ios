//
//  SettingController.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/06.
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
    
    // param.
    var bookInfo: LocalBookInfo!
    var pageNumber: Int!
    var content: String!
    
    @IBAction func doClose() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBookmark() {
        let storyboard = UIStoryboard(name: "AddBookmark", bundle: nil)
        guard let next = storyboard.instantiateInitialViewController() as? AddBookmarkController else {
            print("can not find next.")
            return
        }
        
        next.bookId = bookInfo.bookId
        next.content = content
        next.pageNumber = pageNumber
        
        self.present(next, animated: true, completion: nil)
    }
    
    @IBAction func showChapters() {
        print("show chapter infos.")
    }
    
    @IBAction func showBookmarks() {
        print("show bookmark infos.")
    }
    
    @IBAction func setFont() {
        print("set font infos.")
    }
    
    @IBAction func setLight() {
        print("set light infos.")
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
        showTopAndBottom()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideTopAndBottom()
    }
    
    private func setView() {
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        titleLbl.text = bookInfo.bookName
        topView.transform = topView.transform.translatedBy(x: 0, y: -topView.bounds.height)
        bottomView.transform = bottomView.transform.translatedBy(x: 0, y: bottomView.bounds.height)
        
        let recognizer = UITapGestureRecognizer()
        recognizer.rx.event.bindNext { sender in
            self.dismiss(animated: true, completion: nil)
        }.addDisposableTo(disposeBag)
        
        recognizer.delegate = self
        self.view.addGestureRecognizer(recognizer)
    }
    
    private func showTopAndBottom() {
        topView.isHidden = false
        bottomView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.topView.transform = self.topView.transform.translatedBy(x: 0, y: self.topView.bounds.height)
            self.bottomView.transform = self.bottomView.transform.translatedBy(x: 0, y: -self.bottomView.bounds.height)
        }, completion: nil)
    }
    
    private func hideTopAndBottom() {
        UIView.animate(withDuration: 0.3, animations: {
            self.topView.transform = self.topView.transform.translatedBy(x: 0, y: -self.topView.bounds.height)
            self.bottomView.transform = self.bottomView.transform.translatedBy(x: 0, y: self.bottomView.bounds.height)
        }) { isFinished in
            if (isFinished) {
                self.topView.isHidden = true
                self.bottomView.isHidden = true
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
