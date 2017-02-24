//
//  TempController.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/23.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class TempController: LeavesViewController {
    
    let images = [ UIImage(named : "icon_book_pause")!,
                   UIImage(named: "icon_book_pull")!,
                   UIImage(named: "icon_book1")!,
                   UIImage(named: "icon_book2")!,
                   UIImage(named: "icon_book3")!,
                   UIImage(named: "icon_book4")!]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // #program mark
    override func numberOfPagesInLeavesView(leavesView: LeavesView) -> Int {
        return images.count
    }
    
    override func renderPageAtIndex(index: Int, inContext context: CGContext) {
        let image = images[index]
        let imageRect = CGRect(x: 0, y: 0, width: screenWidth
            , height: screenHeight)
        
        let transform = AppUtility.aspectFit(innerRect: imageRect, outerRect: context.boundingBoxOfClipPath)
        context.concatenate(transform)
        
        guard let cgImage = image.cgImage else {
            return
        }
        
        context.draw(cgImage, in: imageRect)
    }
}
