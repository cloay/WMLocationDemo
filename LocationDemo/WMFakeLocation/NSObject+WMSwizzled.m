//
//  NSObject+WMSwizzled.m
//  WMFakeLocation
//
//  Created by cloay<shangrody@gmail.com> on 2017/2/16.
//  Copyright © 2017年 Cloay. All rights reserved.
//

#import "NSObject+WMSwizzled.h"
#import "objc/runtime.h"

@implementation NSObject (WMSwizzled)

+ (void)wm_swizzleInstanceMethodWithOriginClass:(Class)originCls originalSelector:(SEL)originalSel swizzledClass:(Class)swizzledCls swizzledSelector:(SEL)swizzledSel {
    Method originalMethod = class_getInstanceMethod(originCls, originalSel);
    Method swizzledMethod = class_getInstanceMethod(swizzledCls, swizzledSel);
    
    // class_addMethod will fail if original method already exists, the method doesn’t exist and we just added one
    BOOL didAddMethod = class_addMethod(originCls, originalSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(originCls, swizzledSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


@end
