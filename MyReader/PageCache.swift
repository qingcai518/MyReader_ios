//
//  PageCache.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/22.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation
import UIKit


//@protocol LeavesViewDataSource;

class PageCache: NSObject {
    var pageSize : CGSize!
    var dataSource : PageViewDataSource

    func initWithPageSize(aPageSize: CGSize) {
        
    }
    
    //- (CGImageRef)cachedImageForPageIndex:(NSUInteger)pageIndex;
    func cachedImageForPageIndex(pageIndex: Int) -> CGImage {
        
    }
    
    //- (void)precacheImageForPageIndex:(NSUInteger)pageIndex;
    func precacheImageForPageIndex(pageIndex: Int) {
        
    }
    
    func minimizeToPageIndex(pageIndex: Int) {
        
    }
    
    func flush() {
        
    }
}

//@property (readonly) NSMutableDictionary *pageCache;
//
//@end
//
//@implementation LeavesCache
//
//- (id)initWithPageSize:(CGSize)aPageSize
//{
//    if (self = [super init]) {
//        _pageSize = aPageSize;
//        _pageCache = [[NSMutableDictionary alloc] init];
//    }
//    return self;
//    }
//    
//    - (void)dealloc
//        {
//            [_pageCache release];
//            [super dealloc];
//        }
//        
//        - (CGImageRef)imageForPageIndex:(NSUInteger)pageIndex {
//            if (CGSizeEqualToSize(self.pageSize, CGSizeZero))
//            return NULL;
//            
//            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//            CGContextRef context = CGBitmapContextCreate(NULL,
//                                                         self.pageSize.width,
//                                                         self.pageSize.height,
//                                                         8,						/* bits per component*/
//                self.pageSize.width * 4, 	/* bytes per row */
//                colorSpace,
//                kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
//            CGColorSpaceRelease(colorSpace);
//            CGContextClipToRect(context, CGRectMake(0, 0, self.pageSize.width, self.pageSize.height));
//            
//            [self.dataSource renderPageAtIndex:pageIndex inContext:context];
//            
//            CGImageRef image = CGBitmapContextCreateImage(context);
//            CGContextRelease(context);
//            
//            [UIImage imageWithCGImage:image];
//            CGImageRelease(image);
//            
//            return image;
//            }
//            
//            - (CGImageRef)cachedImageForPageIndex:(NSUInteger)pageIndex {
//                NSNumber *pageIndexNumber = [NSNumber numberWithInt:pageIndex];
//                UIImage *pageImage;
//                @synchronized (self.pageCache) {
//                    pageImage = [self.pageCache objectForKey:pageIndexNumber];
//                }
//                if (!pageImage) {
//                    CGImageRef pageCGImage = [self imageForPageIndex:pageIndex];
//                    if (pageCGImage) {
//                        pageImage = [UIImage imageWithCGImage:pageCGImage];
//                        @synchronized (self.pageCache) {
//                            [self.pageCache setObject:pageImage forKey:pageIndexNumber];
//                        }
//                    }
//                }
//                return pageImage.CGImage;
//                }
//                
//                - (void)precacheImageForPageIndexNumber:(NSNumber *)pageIndexNumber {
//                    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//                    [self cachedImageForPageIndex:[pageIndexNumber intValue]];
//                    [pool release];
//                    }
//                    
//                    - (void)precacheImageForPageIndex:(NSUInteger)pageIndex {
//                        [self performSelectorInBackground:@selector(precacheImageForPageIndexNumber:)
//                        withObject:[NSNumber numberWithInt:pageIndex]];
//                        }
//                        
//                        - (void)minimizeToPageIndex:(NSUInteger)pageIndex {
//                            /* Uncache all pages except previous, current, and next. */
//                            @synchronized (self.pageCache) {
//                                for (NSNumber *key in [self.pageCache allKeys])
//                                if (ABS([key intValue] - (int)pageIndex) > 2)
//                                [self.pageCache removeObjectForKey:key];
//                            }
//                            }
//                            
//                            - (void)flush {
//                                @synchronized (self.pageCache) {
//                                    [self.pageCache removeAllObjects];
//                                }
//}
//
//#pragma mark accessors
//
//- (void)setPageSize:(CGSize)value {
//    _pageSize = value;
//    [self flush];
//}
//
//@end
