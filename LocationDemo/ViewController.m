//
//  ViewController.m
//  LocationDemo
//
//  Created by cloay on 2017/2/16.
//  Copyright © 2017年 Cloay. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "WMLocationProxy.h"

@interface ViewController ()<CLLocationManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CLLocationManager *lManager = [[CLLocationManager alloc] init];
    [lManager setDelegate:self];
    [lManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    [lManager setDistanceFilter:kCLDistanceFilterNone];
    
    if ([CLLocationManager headingAvailable]) {
        [lManager startUpdatingHeading];
    }
    
    [lManager startUpdatingLocation];
    
//    BOOL responds = [lManager.delegate respondsToSelector:@selector(locationManager:didUpdateLocations:)];
//    NSLog(@"responds = %d", responds);
    CLLocation *location = [[CLLocation alloc] initWithLatitude:0.f longitude:0.f];
    [lManager.delegate locationManager:lManager didUpdateLocations:@[location]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CLLocationManagerDelegate method
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"location = %@", locations[0]);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    NSLog(@"newHeading = %@", newHeading);
}
@end
