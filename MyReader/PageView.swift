//
//  PageView.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/22.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

@objc protocol PageViewDelegate {
    
}

@objc protocol PageViewDataSource {
    
}

class PageView: UIView {
//    var delegate : id<PageViewDelegate>
//    var dataSource : id<PageViewDataSource>
    
    var preferredTargetWidth: CGFloat!

    var topPage : CALayer!
    var topPageOverlay: CALayer!
    var topPageReverse : CALayer!
    var topPageReverseImage : CALayer!
    var topPageReverseOverlay: CALayer!
    var bottomPage: CALayer!
    
    var topPageShadow : CAGradientLayer!
    var topPageReverseShading : CAGradientLayer!
    var bottomPageShadow : CAGradientLayer!
    
    var numberOfPages : Int!
    var leafEdge = CGFloat(1.0)
    var pageSize : CGSize!
    var touchBeganPoint : CGPoint!
    var nextPageRect : CGRect!
    var prevPageRect : CGRect!
    
    var touchIsActive : Bool!
    var interactionLocked: Bool!
    
    var backgroundRendering = false
    var currentPageIndex = 0
    
//    var pageCache : PageCache!
    
    func initCommon() {
        self.clipsToBounds = true
        topPage = CALayer()
        topPage.masksToBounds = true
        topPage.contentsGravity = kCAGravityLeft
        topPage.backgroundColor = UIColor.white.cgColor
        
        topPageOverlay = CALayer()
        topPageOverlay.backgroundColor = UIColor(white: 0, alpha: 0.2).cgColor
        
        topPageShadow = CAGradientLayer()
        topPageShadow.colors = [UIColor(white : 0, alpha: 0.6).cgColor, UIColor.clear.cgColor]
        
        topPageShadow.startPoint = CGPoint(x: 1, y: 0.5)
        topPageShadow.endPoint = CGPoint(x: 0, y : 0.5)
        
        topPageReverse = CALayer()
        topPageReverse.backgroundColor = UIColor.white.cgColor
        topPageReverse.masksToBounds = true
        
        topPageReverseImage = CALayer()
        topPageReverseImage.masksToBounds = true
        topPageReverseImage.contentsGravity = kCAGravityRight
        
        topPageReverseOverlay = CALayer()
        topPageReverseOverlay.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        
        topPageReverseShading = CAGradientLayer()
        topPageReverseShading.colors = [UIColor(white: 0, alpha: 0.6).cgColor, UIColor.clear.cgColor]
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
    
        layer.addSublayer(bottomPageShadow)
        layer.addSublayer(topPage)
        layer.addSublayer(topPageReverse)
        
//        pageCache = PageCache()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    func reloadData() {
        //                    [self.pageCache flush];
        //                    self.numberOfPages = [self.pageCache.dataSource numberOfPagesInLeavesView:self];
        currentPageIndex = 0
    }
    
    func getImages() {
        if (currentPageIndex < numberOfPages) {
            if (currentPageIndex > 0 && backgroundRendering) {
//                [self.pageCache precacheImageForPageIndex:self.currentPageIndex-1];
            }
//                topPage.contents = (id)[self.pageCache cachedImageForPageIndex:self.currentPageIndex];
//                topPageReverseImage.contents = (id)[self.pageCache cachedImageForPageIndex:self.currentPageIndex];
            
            if (currentPageIndex < numberOfPages - 1) {
//                     self.bottomPage.contents = (id)[self.pageCache cachedImageForPageIndex:self.currentPageIndex + 1];
            }
//            [self.pageCache minimizeToPageIndex:self.currentPageIndex];
        } else {
            topPage.contents = nil
            topPageReverseImage.contents = nil
            bottomPage.contents = nil
        }
    }
    
    func setLayerFrames() {
        topPage.frame = CGRect(x: layer.bounds.origin.x, y: layer.bounds.origin.y, width: leafEdge * bounds.size.width, height: layer.bounds.size.height)
        topPageReverse.frame = CGRect(x: layer.bounds.origin.x + (2 * leafEdge - 1) * layer.bounds.origin.y, y: (1 - leafEdge) * bounds.size.width, width: layer.bounds.size.width, height: layer.bounds.size.height)
        bottomPage.frame = layer.bounds
        topPageShadow.frame = CGRect(x: topPageReverse.frame.origin.x - 40, y: 0, width: 40, height: bottomPage.bounds.size.height)
        topPageReverseImage.frame = topPageReverse.bounds
        topPageReverseImage.transform = CATransform3DMakeScale(-1, 1, 1)
        topPageReverseOverlay.frame = topPageReverse.bounds
        topPageReverseShading.frame = CGRect(x: topPageReverse.bounds.size.width - 50, y: 0, width: 50 + 1, height: topPageReverse.bounds.size.height)
        
        bottomPageShadow.frame = CGRect(x: leafEdge * bounds.size.width, y: 0, width: 40, height: bottomPage.bounds.size.height)
        topPageOverlay.frame = topPage.bounds
    }
    
    func willTurnToPageAtIndex(index: Int) {
//        if ([self.delegate respondsToSelector:@selector(leavesView:willTurnToPageAtIndex:)])
//        [self.delegate leavesView:self willTurnToPageAtIndex:index];
    }
    
    func didTurnToPageAtIndex(index: Int) {
//        if ([self.delegate respondsToSelector:@selector(leavesView:didTurnToPageAtIndex:)])
//        [self.delegate leavesView:self didTurnToPageAtIndex:index];
    }
    
    func didTurnPageBackward() {
        interactionLocked = false
        didTurnToPageAtIndex(index: currentPageIndex)
    }
    
    func didTurnPageForward() {
        interactionLocked = false
        currentPageIndex = currentPageIndex + 1
        didTurnToPageAtIndex(index: currentPageIndex)
    }
    
    func hasPrevPage() -> Bool {
        return currentPageIndex > 0
    }
    
    func hasNextPage() -> Bool {
        return currentPageIndex < numberOfPages - 1
    }
    
    func touchedNextPage() -> Bool {
//        return CGRectContainsPoint(self.nextPageRect, self.touchBeganPoint);
        
        return CGRect().contains(nextPageRect) && CGRect().contains(touchBeganPoint)
    }
    
    func touchedPrevPage() -> Bool {
        return CGRect().contains(prevPageRect)
    }
    
    func dragThreshold() -> CGFloat {
        return 10
    }
    
    func targetWidth() -> CGFloat {
        if (preferredTargetWidth > 0 && preferredTargetWidth < bounds.size.width / 2) {
            return preferredTargetWidth
        } else {
            return max(28, bounds.size.width / 5)
        }
    }
    
    func updateTargetRects() {
        let targetWidth = self.targetWidth()
        nextPageRect = CGRect(x: bounds.size.width - targetWidth, y: 0, width: targetWidth, height: bounds.size.height)
        prevPageRect = CGRect(x: 0, y: 0, width: targetWidth, height: bounds.size.height)
        
    }
}

extension PageView : PageViewDelegate {
    
}

extension PageView : PageViewDataSource {
    func dataSource(id<PageView>) {
        return pageCache.dataSource

    }
    
    func setDataSource(value : id<PageViewDataSource>) {
        leafEdge = leafEdge
        self.topPageShadow.opacity = min(1.0, 4 * (1 - leafEdge))
        self.bottomPageShadow.opacity = min(1.0, 4 * leafEdge)
        self.topPageOverlay.opacity = min(1.0,  4 * (1 - leafEdge))
        
    }
}





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



//            - (void)dealloc {
//                [_topPage release];
//                [_topPageShadow release];
//                [_topPageOverlay release];
//                [_topPageReverse release];
//                [_topPageReverseImage release];
//                [_topPageReverseOverlay release];
//                [_topPageReverseShading release];
//                [_bottomPage release];
//                [_bottomPageShadow release];
//                [_pageCache release];
//
//                [super dealloc];
//                }
//}
//
//@end
//
//CGFloat distance(CGPoint a, CGPoint b) {
//    return sqrtf(powf(a.x-b.x, 2) + powf(a.y-b.y, 2));
//}
