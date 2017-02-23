//
//  LeavesCache.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/23.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation
import UIKit

class LeavesCache : NSObject {
    var pageSize : CGSize!
    var pageCache : NSMutableDictionary!
    var dataSource : LeavesViewDataSource!
    
    init(aPageSize: CGSize) {
        super.init()
        pageSize = aPageSize
        pageCache = NSMutableDictionary()
    }
    
    func imageForPageIndex(pageIndex : Int) -> CGImage? {
        if (__CGSizeEqualToSize(pageSize, CGSize.zero)) {
            print("11111111")
            return nil
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

        guard let context = CGContext(data: nil, width: Int(pageSize.width), height: Int(pageSize.height), bitsPerComponent: 8, bytesPerRow: Int(pageSize.width) * 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            print("22222")
            return nil
        }
        
        context.clip(to: CGRect(x: 0, y: 0, width: pageSize.width, height: pageSize.height))
        self.dataSource.renderPageAtIndex(index: pageIndex, inContext: context)
        
        guard let image = context.makeImage() else {return nil}
        return image
    }
    
    func cachedImageForPageIndex(pageIndex : Int) {
        let pageIndexNumber = NSNumber(integerLiteral: pageIndex)
        var pageImage : UIImage!
        
        let queue = DispatchQueue(label: "cachedImageForPageIndex")
        queue.sync {
            if let image = pageCache.object(forKey: pageIndexNumber) as? UIImage {
                pageImage = image
            }
        }
        
        if (pageImage == nil) {
            if let pageCGImage = imageForPageIndex(pageIndex: pageIndex) {
                pageImage = UIImage(cgImage: pageCGImage)
                
                queue.sync {
                    pageCache.setObject(pageImage, forKey: pageIndexNumber)
                }
            }
        }
    }
    
    func precacheImageForPageIndexNumber(pageIndexNumber : NSNumber) {
        cachedImageForPageIndex(pageIndex: pageIndexNumber.intValue)
    }
    
    func precacheImageForPageIndex(pageIndex : Int) {
        performSelector(inBackground: #selector(LeavesCache.precacheImageForPageIndexNumber(pageIndexNumber:)), with: NSNumber(integerLiteral: pageIndex))
    }
    
    func minimizeToPageIndex(pageIndex : Int) {
        let queue = DispatchQueue(label: "minimizeToPageIndex")
        queue.sync {
            for key in pageCache.allKeys {
                guard let keyNumber = key as? NSNumber else {
                    continue
                }
                
                if (abs(keyNumber.intValue - pageIndex) > 2) {
                    pageCache.removeObject(forKey: key)
                }
            }
        }
    }
    
    func flush() {
        let queue = DispatchQueue(label: "flush")
        queue.sync {
            pageCache.removeAllObjects()
        }
    }
    
    func setPageSize(value : CGSize) {
        pageSize = value
        flush()
    }
}
