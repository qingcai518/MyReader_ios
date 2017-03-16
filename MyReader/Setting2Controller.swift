//
//  Setting2Controller.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/16.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Setting2Controller: UIViewController {
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var leftImgView: UIImageView!
    @IBOutlet weak var rightImgView: UIImageView!
    @IBOutlet weak var sliderView : UISlider!
    @IBOutlet weak var smallBtn: UIButton!
    @IBOutlet weak var bigBtn: UIButton!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBottomView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    private func setBottomView() {
        self.view.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        smallBtn.layer.borderColor = UIColor.blue.cgColor
        smallBtn.layer.borderWidth = 1
        
        bigBtn.layer.borderColor = UIColor.blue.cgColor
        bigBtn.layer.borderWidth = 1
        
        let recognizer = UITapGestureRecognizer()
        recognizer.rx.event.bindNext { [weak self] sender in
            self?.dismiss(animated: true, completion: nil)
        }.addDisposableTo(disposeBag)
        recognizer.delegate = self
        
        self.view.addGestureRecognizer(recognizer)
    }
}

extension Setting2Controller : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view == bottomView) {
            return false
        }
        
        return true
    }
}
