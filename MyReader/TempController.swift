//
//  TempController.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/23.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class TempController: LeavesViewController {
    
//    let images = [ UIImage(named : "icon_book_pause")!,
//                   UIImage(named: "icon_book_pull"),
//                   UIImage(named: "icon_book1"),
//                   UIImage(named: "icon_book2"),
//                   UIImage(named: "icon_book3"),
//                   UIImage(named: "icon_book4")]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // #program mark
    override func numberOfPagesInLeavesView(leavesView: LeavesView) -> Int {
        return 3
    }
    
    override func renderPageAtIndex(index: Int, inContext context: CGContext) {
        print("11111")
        
        let bounds = context.boundingBoxOfClipPath
        context.setFillColor(UIColor(hue: CGFloat(index) / 10.0, saturation: 0.8, brightness: 0.8, alpha: 1.0).cgColor)
        context.fill(bounds.insetBy(dx: 100, dy: 100))
    }
}
