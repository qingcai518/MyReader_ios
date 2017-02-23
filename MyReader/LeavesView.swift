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
    var dataSource : LeavesViewDataSource!
    var delegate : LeavesViewDelegate!
    var targetWidth : CGFloat!
    var preferredTargetWidth : CGFloat!
    var currentPageIndex : Int!
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
    
    var numberOfPages: Int!
    var leafEdge = CGFloat(1.0)
    var pageSize : CGFloat!
    var touchBeganPoint : CGPoint!
    var nextPageRect: CGRect!
    var prevPageRect: CGRect!
    var touchIsActive : Bool!
    var interactionLocked : Bool!
    
    var pageCache : LeavesCache!
    
    func distance (a: CGPoint, b : CGPoint) {
        
    }
    
    func initCommon() {
        self.clipsToBounds = true
        topPage = CALayer()
        topPage.masksToBounds = true
        topPage.contentsGravity = kCAGravityLeft
        topPage.backgroundColor = UIColor.white.cgColor
        
        topPageOverlay = CALayer()
        topPageOverlay.backgroundColor = UIColor(white: 0, alpha: 0.2).cgColor
        
        topPageShadow = CAGradientLayer()
        topPageShadow.colors = [UIColor(white : 0, alpha : 0.6).cgColor, UIColor.clear.cgColor]
        
        topPageShadow.startPoint = CGPoint(x: 1, y: 0.5)
        topPageShadow.endPoint = CGPoint(x: 0, y: 0.5)
        
        topPageReverse = CALayer()
        topPageReverse.backgroundColor = UIColor.white.cgColor
        topPageReverse.masksToBounds = true
        
        topPageReverseImage = CALayer()
        topPageReverseImage.masksToBounds = true
        topPageReverseImage.contentsGravity = kCAGravityRight
        
        topPageReverseOverlay = CALayer()
        topPageReverseOverlay.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        
        topPageReverseShading = CAGradientLayer()
        topPageReverseShading.colors = [UIColor(white : 0, alpha : 0.6).cgColor, UIColor.clear.cgColor]
        
        topPageReverseShading.startPoint = CGPoint(x: 1, y: 0.5)
        topPageReverseShading.endPoint = CGPoint(x: 0, y: 0.5)
        
        bottomPage = CALayer()
        bottomPage.backgroundColor = UIColor.white.cgColor
        bottomPage.masksToBounds = true
        
        bottomPageShadow = CAGradientLayer()
        bottomPageShadow.colors = [UIColor(white: 0, alpha: 0.6).cgColor, UIColor.clear.cgColor]
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
    
    override init(frame : CGRect) {
        super.init(frame: frame)
        self.initCommon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initCommon()
    }
    
    func reloadData() {
        pageCache.flush()
        self.numberOfPages = self.pageCache.dataSource.numberOfPagesInLeavesView(leavesView: self)
        self.currentPageIndex = 0
    }
    
    func getImages() {
        if (self.currentPageIndex < self.numberOfPages) {
            if (self.currentPageIndex > 0 && self.backgroundRendering) {
                self.pageCache.precacheImageForPageIndex(pageIndex: self.currentPageIndex - 1)
            }
            
            self.topPage.contents = self.pageCache.cachedImageForPageIndex(pageIndex: self.currentPageIndex)
            self.topPageReverseImage.contents = self.pageCache.cachedImageForPageIndex(pageIndex: self.currentPageIndex)
            
            if (self.currentPageIndex < self.numberOfPages - 1) {
                self.bottomPage.contents = self.pageCache.cachedImageForPageIndex(pageIndex: self.currentPageIndex + 1)
            }
            
            self.pageCache.minimizeToPageIndex(pageIndex: self.currentPageIndex)
        } else {
            self.topPage.contents = nil
            self.topPageReverseImage.contents = nil
            self.bottomPage.contents = nil

        }
    }
    
    func setLayerFrames() {
        self.topPage.frame = CGRect(x: self.layer.bounds.origin.x, y: self.layer.bounds.origin.y, width: self.leafEdge * self.bounds.size.width, height: self.layer.bounds.size.height)
        self.topPageReverse.frame = CGRect(x: self.layer.bounds.origin.x + (2 * self.leafEdge - 1) * self.bounds.size.width, y: self.layer.bounds.origin.y, width:(1 - self.leafEdge) * self.bounds.size.width, height: self.layer.bounds.size.height)
        self.bottomPage.frame = self.layer.bounds
        self.topPageShadow.frame = CGRect(x: self.topPageReverse.frame.origin.x - 40, y: 0, width: 40, height: self.bottomPage.bounds.size.height)
        
        self.topPageReverseImage.frame = self.topPageReverse.bounds
        self.topPageReverseImage.transform = CATransform3DMakeScale(-1, 1, 1)
        self.topPageReverseOverlay.frame  = self.topPageReverse.bounds
        self.topPageReverseShading.frame = CGRect(x: self.topPageReverse.bounds.size.width - 50, y: 0, width: 50 + 1, height: self.topPageReverse.bounds.size.height)
        
        self.bottomPageShadow.frame = CGRect(x: self.leafEdge * self.bounds.size.width, y: 0, width: 40, height: self.bottomPage.bounds.size.height)
        
        self.topPageOverlay.frame = self.topPage.bounds
    }
    
    func willTurnToPageAtIndex(index: Int) {
        if self.delegate.responds(to: #selector(LeavesView.willTurnToPageAtIndex(index:))) {
            self.delegate.leavesView(leavesView: self, willTurnToPageAtIndex: index)
        }
    }
    
    func didTurnToPageAtIndex(index: Int) {
        if self.delegate.responds(to: #selector(LeavesView.didTurnToPageAtIndex(index:))) {
            self.delegate.leavesView(leavesView: self, didTurnToPageAtIndex: index)
        }
    }
    
    func didTurnPageBackward() {
        self.interactionLocked = false
        self.didTurnToPageAtIndex(index: self.currentPageIndex)
    }
    
    func didTurnPageForward() {
        self.interactionLocked = false
        self.currentPageIndex = self.currentPageIndex + 1
        self.didTurnToPageAtIndex(index: self.currentPageIndex)
    }
    
    func hasPrevPage() -> Bool {
        return self.currentPageIndex > 0
    }
    
    func hasNextPage() -> Bool {
        return self.currentPageIndex < self.numberOfPages - 1
    }
    
    func touchedNextPage() -> Bool {
        return self.nextPageRect.contains(self.touchBeganPoint)
    }
    
    func touchedPrevPage() -> Bool {
        return self.nextPageRect.contains(self.touchBeganPoint)
    }
    
    func dragThreshold() -> CGFloat {
        return 10
    }
    
    func targetWidth() -> CGFloat {
        if (self.preferredTargetWidth > 0 && self.preferredTargetWidth < self.bounds.size.width / 2) {
            return self.preferredTargetWidth
        } else {
            return max(28, self.bounds.size.width / 5)
        }
    }
    
    func updateTargetRects() {
        let targetWidth = self.targetWidth()
        self.nextPageRect = CGRect(x: self.bounds.size.width - targetWidth, y: 0, width: targetWidth, height: self.bounds.size.height)
        self.prevPageRect = CGRect(x: 0, y: 0, width: targetWidth, height: self.bounds.size.height)
    }
}

//}
//
//#pragma mark accessors
//
//- (id<LeavesViewDataSource>)dataSource {
//    return self.pageCache.dataSource;
//    
//    }
//    
//    - (void)setDataSource:(id<LeavesViewDataSource>)value {
//        self.pageCache.dataSource = value;
//        }
//        
//        - (void)setLeafEdge:(CGFloat)aLeafEdge {
//            _leafEdge = aLeafEdge;
//            self.topPageShadow.opacity = MIN(1.0, 4*(1-self.leafEdge));
//            self.bottomPageShadow.opacity = MIN(1.0, 4*self.leafEdge);
//            self.topPageOverlay.opacity = MIN(1.0, 4*(1-self.leafEdge));
//            [self setLayerFrames];
//            }
//            
//            - (void)setCurrentPageIndex:(NSUInteger)aCurrentPageIndex {
//                _currentPageIndex = aCurrentPageIndex;
//                
//                [CATransaction begin];
//                [CATransaction setValue:(id)kCFBooleanTrue
//                    forKey:kCATransactionDisableActions];
//                
//                [self getImages];
//                
//                self.leafEdge = 1.0;
//                
//                [CATransaction commit];
//                }
//                
//                - (void)setPreferredTargetWidth:(CGFloat)value {
//                    _preferredTargetWidth = value;
//                    [self updateTargetRects];
//}
//
//#pragma mark UIResponder
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    if (self.interactionLocked)
//    return;
//    
//    UITouch *touch = [event.allTouches anyObject];
//    self.touchBeganPoint = [touch locationInView:self];
//    
//    if ([self touchedPrevPage] && [self hasPrevPage]) {		
//        [CATransaction begin];
//        [CATransaction setValue:(id)kCFBooleanTrue
//            forKey:kCATransactionDisableActions];
//        self.currentPageIndex = self.currentPageIndex - 1;
//        self.leafEdge = 0.0;
//        [CATransaction commit];
//        self.touchIsActive = YES;		
//    } 
//    else if ([self touchedNextPage] && [self hasNextPage])
//    self.touchIsActive = YES;
//    
//    else 
//    self.touchIsActive = NO;
//    }
//    
//    - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//        if (!self.touchIsActive)
//        return;
//        UITouch *touch = [event.allTouches anyObject];
//        CGPoint touchPoint = [touch locationInView:self];
//        
//        [CATransaction begin];
//        [CATransaction setValue:[NSNumber numberWithFloat:0.07]
//            forKey:kCATransactionAnimationDuration];
//        self.leafEdge = touchPoint.x / self.bounds.size.width;
//        [CATransaction commit];
//        }
//        
//        
//        - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//            if (!self.touchIsActive)
//            return;
//            self.touchIsActive = NO;
//            
//            UITouch *touch = [event.allTouches anyObject];
//            CGPoint touchPoint = [touch locationInView:self];
//            BOOL dragged = distance(touchPoint, self.touchBeganPoint) > [self dragThreshold];
//            
//            [CATransaction begin];
//            float duration;
//            if ((dragged && self.leafEdge < 0.5) || (!dragged && [self touchedNextPage])) {
//                [self willTurnToPageAtIndex:self.currentPageIndex+1];
//                self.leafEdge = 0;
//                duration = self.leafEdge;
//                self.interactionLocked = YES;
//                if (self.currentPageIndex+2 < self.numberOfPages && self.backgroundRendering)
//                [self.pageCache precacheImageForPageIndex:self.currentPageIndex+2];
//                [self performSelector:@selector(didTurnPageForward)
//                withObject:nil 
//                afterDelay:duration + 0.25];
//            }
//            else {
//                [self willTurnToPageAtIndex:self.currentPageIndex];
//                self.leafEdge = 1.0;
//                duration = 1 - self.leafEdge;
//                self.interactionLocked = YES;
//                [self performSelector:@selector(didTurnPageBackward)
//                withObject:nil 
//                afterDelay:duration + 0.25];
//            }
//            [CATransaction setValue:[NSNumber numberWithFloat:duration]
//            forKey:kCATransactionAnimationDuration];
//            [CATransaction commit];
//            }
//            
//            - (void)layoutSubviews {
//                [super layoutSubviews];
//                
//                if (!CGSizeEqualToSize(self.pageSize, self.bounds.size)) {
//                    self.pageSize = self.bounds.size;
//                    
//                    [CATransaction begin];
//                    [CATransaction setValue:(id)kCFBooleanTrue
//                        forKey:kCATransactionDisableActions];
//                    [self setLayerFrames];
//                    [CATransaction commit];
//                    
//                    self.pageCache.pageSize = self.bounds.size;
//                    [self getImages];
//                    [self updateTargetRects];
//                }
//}
//
//@end
//
//CGFloat distance(CGPoint a, CGPoint b) {
//    return sqrtf(powf(a.x-b.x, 2) + powf(a.y-b.y, 2));
//}
