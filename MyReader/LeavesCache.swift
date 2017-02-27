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
    var pageCache : NSMutableDictionary!
    var dataSource : LeavesViewDataSource!
    var pageSize = CGSize(width: 0, height : 0) {
        didSet {
            self.flush()
        }
    }
    
    init(aPageSize: CGSize) {
        super.init()
        pageSize = aPageSize
        pageCache = NSMutableDictionary()
    }
    
    func imageForPageIndex(pageIndex: Int) -> CGImage? {
        if (__CGSizeEqualToSize(self.pageSize, CGSize.zero)) {
            return nil
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        
        guard let context = CGContext(data: nil, width: Int(self.pageSize.width), height: Int(self.pageSize.height), bitsPerComponent: 8, bytesPerRow: Int(self.pageSize.width) * 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            print("can not create context")
            return nil
        }
        context.clip(to: CGRect(x : 0, y: 0, width : self.pageSize.width, height : self.pageSize.height))
        
        print("self.dataSource.renderPageAtIndex")
        self.dataSource.renderPageAtIndex(index: pageIndex, inContext: context)
        
        guard let image = context.makeImage() else {
            print("can not create image.")
            return nil
        }
        
        _ = UIImage(cgImage: image)
        return image
    }
    
    func cachedImageForPageIndex(pageIndex : Int) -> CGImage? {
        let pageIndexNumber = NSNumber(value: pageIndex)
        if let pageImage = pageCache.object(forKey: pageIndexNumber) as? UIImage {
            return pageImage.cgImage
        }
        
        if let pageCGImage = self.imageForPageIndex(pageIndex: pageIndex) {
            let image = UIImage(cgImage: pageCGImage)
            self.pageCache.setObject(image, forKey: pageIndexNumber)
            
            return image.cgImage
        }
        
        return nil
    }

    func precacheImageForPageIndexNumber(pageIndexNumber : NSNumber) {
        _ = cachedImageForPageIndex(pageIndex: pageIndexNumber.intValue)
    }
    
    func precacheImageForPageIndex(pageIndex : Int) {
        performSelector(inBackground: #selector(LeavesCache.precacheImageForPageIndexNumber(pageIndexNumber:)), with: NSNumber(integerLiteral: pageIndex))
    }
    
    func minimizeToPageIndex(pageIndex: Int) {
        for key in self.pageCache.allKeys {
            guard let numberKey = key as? NSNumber else {
                print("11111")
                continue
            }
            
            if (abs(numberKey.intValue - pageIndex) > 2) {
                self.pageCache.removeObject(forKey: key)
            }
        }
    }
    
    func flush() {
        self.pageCache.removeAllObjects()
    }
}
