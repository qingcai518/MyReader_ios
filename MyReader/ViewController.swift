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
import NVActivityIndicatorView

class ViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    // indicator.
    var indicator : NVActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator = NVActivityIndicatorView(frame: CGRect(x: 100, y: 100, width: 200, height: 150), type: NVActivityIndicatorType.ballGridBeat, color: UIColor.brown, padding: 10)
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
    
    func startIndicator() {
        self.view.bringSubview(toFront: indicator)
        indicator.startAnimating()
    }
    
    func stopIndicator() {
        indicator.stopAnimating()
    }
}

