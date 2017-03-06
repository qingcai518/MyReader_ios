//
//  AddBookmarkController.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/01.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class AddBookmarkController: ViewController {
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var content : String? // params.
    var pageNumber : Int? // params.
    var bookId: String? //params.
    
    @IBAction func doConfirm() {
        guard let name = nameTf.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else {
            return
        }
        self.setBookmarkInfo(bookmarkName: name)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doCancel() {
        let name = "我的书签"
        self.setBookmarkInfo(bookmarkName: name)
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ビューを半透明に設定する.
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        
        // recognizerを設定する.
        let recognizer = UITapGestureRecognizer()
        recognizer.rx.event.bindNext { sender in
            self.dismiss(animated: true, completion: nil)
        }.addDisposableTo(disposeBag)
        recognizer.cancelsTouchesInView = false
        recognizer.delegate = self
        self.view.addGestureRecognizer(recognizer)
        
        // ボタンの活性・非活性を設定する
        self.nameTf.rx.text.asObservable().map{$0?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != ""}.bindTo(self.confirmBtn.rx.isEnabled).addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setBookmarkInfo(bookmarkName: String) {
        print("content = \(content), pageNumber = \(pageNumber), bookId = \(bookId)")
        if (content == nil || pageNumber == nil || bookId == nil) {
            return
        }
        
        // 現在の時間を取得する.
        let timeString = AppUtility.getCurrentTimeString()
        let id = SQLiteManager.sharedInstance.insertBookmark(name: bookmarkName, bookId: bookId!, time: timeString, content: content!, pageNumber: pageNumber!)
        
        print("id = \(id)")
    }
}

extension AddBookmarkController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: nameView))! {
            return false
        }
        
        return true
    }
}
