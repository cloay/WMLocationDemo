//
//  CLLocationManager+WMFake.m
//  WMFakeLocation
//
//  Created by cloay on 2017/2/16.
//  Copyright © 2017年 Cloay. All rights reserved.
//

#import "CLLocationManager+WMFake.h"
#import "NSObject+WMSwizzled.h"
#import "WMLocationProxy.h"
#import <objc/runtime.h>

@interface CLLocationManager ()

@property (nonatomic, strong) WMLocationProxy *proxy;

@end

@implementation CLLocationManager (WMFake)

+ (void)load {
    Class cls = [self class];
    [self wm_swizzleInstanceMethodWithOriginClass:cls originalSelector:@selector(setDelegate:) swizzledClass:cls swizzledSelector:@selector(wm_setDelegate:)];
}

- (WMLocationProxy *)proxy {
    id object = objc_getAssociatedObject(self, @"wm_proxy");
    return object;
}


- (void)setProxy:(WMLocationProxy *)proxy {
    [self willChangeValueForKey:@"wm_proxy"];
    objc_setAssociatedObject(self, @"wm_proxy", proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"wm_proxy"];
}

- (void)wm_setDelegate:(id)delegate {
    WMLocationProxy *proxy = [[WMLocationProxy alloc] init];
    proxy.oLMDelegate = delegate;
    self.proxy = proxy;
    [self wm_setDelegate:proxy];
}

@end
