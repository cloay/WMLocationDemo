//
//  NSObject+WMSwizzled.h
//  WMFakeLocation
//
//  Created by cloay<shangrody@gmail.com> on 2017/2/16.
//  Copyright © 2017年 Cloay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (WMSwizzled)

/**
 交换实例方法
 
 @param originCls 原始的类
 @param originalSel 原始的方法
 @param swizzledCls 要交换的方法所在的类
 @param swizzledSel 交换成的方法
 */
+ (void)wm_swizzleInstanceMethodWithOriginClass:(Class)originCls originalSelector:(SEL)originalSel swizzledClass:(Class)swizzledCls swizzledSelector:(SEL)swizzledSel;

@end
