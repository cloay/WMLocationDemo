//
//  WMLocationProxy.m
//  WMFakeLocation
//
//  Created by cloay<shangrody@gmail.com> on 2017/2/16.
//  Copyright © 2017年 Cloay. All rights reserved.
//

#import "WMLocationProxy.h"
#import <MapKit/MapKit.h>

@interface WMLocationProxy() <CLLocationManagerDelegate>
@property (nonatomic, strong) NSArray *orginLocations;
@end

@implementation WMLocationProxy

- (BOOL)respondsToSelector:(SEL)aSelector {
    if (self.oLMDelegate && [self.oLMDelegate respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (self.oLMDelegate) {
        return [self.oLMDelegate methodSignatureForSelector:aSelector];
    }
    return [super methodSignatureForSelector:aSelector];
}


- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if (self.oLMDelegate && [self.oLMDelegate respondsToSelector:anInvocation.selector]) {
        if (anInvocation.selector == @selector(locationManager:didUpdateToLocation:fromLocation:)) {
            
            CLLocation *originLocation;
            [anInvocation getArgument:&originLocation atIndex:3];
            
            CLLocation *newLocation = [self makeFakeLocationWithOriginLocation:originLocation];
            [anInvocation setArgument:&newLocation atIndex:3];
        }
        
        if (anInvocation.selector == @selector(locationManager:didUpdateLocations:)) {
            __unsafe_unretained NSArray *locations;
            [anInvocation getArgument:&locations atIndex:3];
            if (locations.count > 0) {
                CLLocation *originLocation = locations[0];
                CLLocation *fakeLocation = [self makeFakeLocationWithOriginLocation:originLocation];
                NSArray *fakeLocations = @[fakeLocation];
                self.orginLocations = fakeLocations;
                [anInvocation setArgument:&fakeLocations atIndex:3];
            }
        }
        [anInvocation invokeWithTarget:self.oLMDelegate];
    }
}


/**
 欺骗微信，利用GPS定位的坐标生成假的GPS位置坐标返回给微信

 @param originLocation GPS定位的实际位置坐标
 @return 返回生成的假的GPS位置坐标
 */
- (CLLocation*)makeFakeLocationWithOriginLocation:(CLLocation*)originLocation {
    //指定假的位置坐标点，比如公司位置
    CLLocationCoordinate2D lCoordinate2D = CLLocationCoordinate2DMake(116.506752,39.899905);
    CLLocation *newLocation = [[CLLocation alloc] initWithCoordinate:lCoordinate2D altitude:originLocation.altitude horizontalAccuracy:originLocation.horizontalAccuracy verticalAccuracy:originLocation.verticalAccuracy course:originLocation.course speed:originLocation.speed timestamp:originLocation.timestamp];
    return newLocation;
}

@end
