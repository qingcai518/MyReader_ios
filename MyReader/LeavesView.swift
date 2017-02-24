//
//  LeavesView.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/23.
//  Copyright © 2017年 RN-079. All rights reserved.
//
import Foundation
import UIKit

protocol LeavesViewDataSource : NSObjectProtocol {
    func numberOfPagesInLeavesView(leavesView : LeavesView) -> Int
    func renderPageAtIndex(index: Int, inContext context: CGContext)
}

protocol LeavesViewDelegate: NSObjectProtocol {
//    optional func leavesView(leavesView: LeavesView, willTurnToPageAtIndex pageIndex: UInt)
//    optional func leavesView(leavesView: LeavesView, didTurnToPageAtIndex pageIndex: UInt)
    func leavesView(leavesView: LeavesView, willTurnToPageAtIndex pageIndex: Int)
    func leavesView(leavesView: LeavesView, didTurnToPageAtIndex pageIndex: Int)
}

class LeavesView: UIView {
    var delegate : LeavesViewDelegate!
    var targetWidth = CGFloat(0)
    var preferredTargetWidth = CGFloat(0)
    var currentPageIndex = 0
    var backgroundRendering = false
    var topPage: CALayer!
    var topPageOverlay : CALayer!
    var topPageReverse : CALayer!
    var topPageReverseImage : CALayer!
    var topPageReverseOverlay: CALayer!
    var bottomPage: CALayer!
    var topPageShadow : CAGradientLayer!
    var topPageReverseShading : CAGradientLayer!
    var bottomPageShadow: CAGradientLayer!
    
    var numberOfPages = 0
    var leafEdge = CGFloat(1.0)
    var pageSize : CGSize!
    var touchBeganPoint : CGPoint!
    var nextPageRect: CGRect!
    var prevPageRect: CGRect!
    var touchIsActive = false
    var interactionLocked = false
    var pageCache : LeavesCache!
    
    func initCommon() {
        self.clipsToBounds = true
        topPage = CALayer()
        topPage.masksToBounds = true
        topPage.backgroundColor = UIColor.white.cgColor
        
        topPageOverlay = CALayer()
        topPageOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.2).cgColor
        
        topPageShadow = CAGradientLayer()
        topPageShadow.colors = [UIColor.black.withAlphaComponent(0.6).cgColor, UIColor.clear.cgColor]
        
        topPageShadow.startPoint = CGPoint(x: 1, y: 0.5)
        topPageShadow.endPoint = CGPoint(x: 0, y: 0.5)
        
        topPageReverse = CALayer()
        topPageReverse.backgroundColor = UIColor.white.cgColor
        topPageReverse.masksToBounds = true
        
        topPageReverseImage = CALayer()
        topPageReverseImage.masksToBounds = true
        topPageReverseImage.contentsGravity = kCAGravityRight
        
        topPageReverseOverlay = CALayer()
        topPageReverseOverlay.backgroundColor = UIColor.white.withAlphaComponent(0.8).cgColor
        
        topPageReverseShading = CAGradientLayer()
        topPageReverseShading.colors = [UIColor.black.withAlphaComponent(0.6).cgColor, UIColor.clear.cgColor]
        
        topPageReverseShading.startPoint = CGPoint(x: 1, y: 0.5)
        topPageReverseShading.endPoint = CGPoint(x: 0, y: 0.5)
        
        bottomPage = CALayer()
        bottomPage.backgroundColor = UIColor.white.cgColor
        bottomPage.masksToBounds = true
        
        bottomPageShadow = CAGradientLayer()
        bottomPageShadow.colors = [UIColor.black.withAlphaComponent(0.6).cgColor, UIColor.clear.cgColor]
 
        bottomPageShadow.startPoint = CGPoint(x: 0, y: 0.5)
        bottomPageShadow.endPoint = CGPoint(x: 1, y: 0.5)
        
        topPage.addSublayer(topPageShadow)
        topPage.addSublayer(topPageOverlay)
        
        topPageReverse.addSublayer(topPageReverseImage)
        topPageReverse.addSublayer(topPageReverseOverlay)
        topPageReverse.addSublayer(topPageReverseShading)
        
        bottomPage.addSublayer(bottomPageShadow)
        
        self.layer.addSublayer(bottomPage)
        self.layer.addSublayer(topPage)
        self.layer.addSublayer(topPageReverse)
        
        leafEdge = 1.0
        backgroundRendering = false
        pageCache = LeavesCache(aPageSize: self.bounds.size)
    }
    

}
