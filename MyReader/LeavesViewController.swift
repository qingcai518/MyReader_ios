//
//  LeavesViewController.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/23.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class LeavesViewController: UIViewController {
    var leavesView : LeavesView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leavesView.frame = self.view.bounds
        self.view.addSubview(leavesView)
        leavesView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        leavesView = LeavesView(frame : CGRect.zero)
        leavesView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        leavesView.dataSource = self
        leavesView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LeavesViewController : LeavesViewDelegate {
    func leavesView(leavesView: LeavesView, willTurnToPageAtIndex pageIndex: Int) {
    }
    
    func leavesView(leavesView: LeavesView, didTurnToPageAtIndex pageIndex: Int) {
    }
}

extension LeavesViewController : LeavesViewDataSource {
    func numberOfPagesInLeavesView(leavesView: LeavesView) -> Int {
        return 0
    }
    
    func renderPageAtIndex(index: Int, inContext context: CGContext) {
    }
}
