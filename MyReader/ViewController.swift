//
//  ViewController.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/20.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func setEndEditing() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.doEnd(_:)))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func doEnd(_ sender: UITapGestureRecognizer?) {
        self.view.endEditing(true)
    }
}

