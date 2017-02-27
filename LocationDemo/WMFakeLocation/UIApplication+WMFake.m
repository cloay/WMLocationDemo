//
//  UIApplication+WMFake.m
//  LocationDemo
//
//  Created by cloay on 2017/2/21.
//  Copyright © 2017年 Cloay. All rights reserved.
//

#import "UIApplication+WMFake.h"
#import "NSObject+WMSwizzled.h"
#import "objc/runtime.h"

@implementation UIApplication (WMFake)

+ (void)load {
    unsigned int numberOfClasses = 0;
    Class *classes = objc_copyClassList(&numberOfClasses);
    Class appDelegateClass = nil;
    for (unsigned int i = 0; i < numberOfClasses; ++i) {
        if (class_conformsToProtocol(classes[i], @protocol(UIApplicationDelegate))) {
            //找到实现UIApplicationDelegate的类
            appDelegateClass = classes[i];
            
            //添加方法
            SEL swizzledSel = @selector(wm_application:didFinishLaunchingWithOptions:);
            [self addMethod:appDelegateClass withMethod:swizzledSel];
            
            SEL fakeBtnDidTapedSel = @selector(fakeBtnDidTaped:);
            [self addMethod:appDelegateClass withMethod:fakeBtnDidTapedSel];
        }
    }
    
    //替换
    [self wm_swizzleInstanceMethodWithOriginClass:appDelegateClass originalSelector:@selector(application:didFinishLaunchingWithOptions:) swizzledClass:appDelegateClass swizzledSelector:@selector(wm_application:didFinishLaunchingWithOptions:)];
}

+ (void)addMethod:(Class)cls withMethod:(SEL)aSelector {
    Class swizzledCls = [self class];
    Method swizzledMethod = class_getInstanceMethod(swizzledCls, aSelector);
    class_addMethod(cls, aSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
}

- (BOOL)wm_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL didFinishLaunching = [self wm_application:application didFinishLaunchingWithOptions:launchOptions];
    UIButton *fakeBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, 50, 36)];
    [fakeBtn setTitle:@"Fake" forState:UIControlStateNormal];
    [fakeBtn setTitle:@"Fake" forState:UIControlStateSelected];
    [fakeBtn setTitleColor:[UIColor colorWithRed:129 / 255.f green:219 / 255.f blue:99 / 255.f alpha:1] forState:UIControlStateSelected];
    [fakeBtn setTitleColor:[UIColor colorWithRed:33 / 255.f green:33 / 255.f blue:33 / 255.f alpha:1] forState:UIControlStateNormal];
    [fakeBtn addTarget:self action:@selector(fakeBtnDidTaped:) forControlEvents:UIControlEventTouchUpInside];
    [application.keyWindow addSubview:fakeBtn];
    
    return didFinishLaunching;
}

- (void)fakeBtnDidTaped:(UIButton *)btn {
    btn.selected = !btn.selected;
    [[NSUserDefaults standardUserDefaults] setBool:btn.selected forKey:@"KWMFakeLocation"];
}


@end
