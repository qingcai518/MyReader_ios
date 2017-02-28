//
//  LeavesViewController.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/23.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class LeavesViewController: UIViewController {
    private(set) var leavesView = LeavesView(frame: CGRect.zero)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initCommon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initCommon()
    }
    
    private func initCommon() {
        leavesView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        leavesView.dataSource = self
        leavesView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        leavesView.frame = self.view.bounds
        self.view.addSubview(leavesView)
        leavesView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension LeavesViewController : LeavesViewDelegate {
    func leavesView(leavesView: LeavesView, willTurnToPageAtIndex pageIndex: Int) {
    }
    
    func leavesView(leavesView: LeavesView, didTurnToPageAtIndex pageIndex: Int) {
    }
}

//extension LeavesViewController : LeavesViewDelegate {
//    func leavesView(leavesView: LeavesView, didTurnToPageAtIndex pageIndex: Int) {
//        print("did turn to page at index \(pageIndex)")
//    }
//    
//    func leavesView(leavesView: LeavesView, willTurnToPageAtIndex pageIndex: Int) {
//        print("will trun to page at index \(pageIndex)")
//    }
//}

extension LeavesViewController : LeavesViewDataSource {
    func numberOfPagesInLeavesView(leavesView: LeavesView) -> Int {
        return 0
    }
    
    func renderPageAtIndex(index: Int, inContext context: CGContext) {
    }
}
