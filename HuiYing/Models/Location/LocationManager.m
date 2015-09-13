//
//  LocationManager.m
//  HuiYing
//
//  Created by 金鑫 on 15/9/6.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;//定义Manager

@end

@implementation LocationManager
IMPLEMENT_SHARED_INSTANCE(LocationManager);

-(void)startLocate{
    if([CLLocationManager locationServicesEnabled]) {
        if (_locationManager == nil) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
        }
    }else {
        //TODO:提示用户无法进行定位操作,未测试
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"定位未开启" message:@"请前往系统设置开启定位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
    {
        //设置定位权限 仅ios8有意义
        [self.locationManager requestWhenInUseAuthorization];// 前台定位
        
        //  [locationManager requestAlwaysAuthorization];// 前后台同时定位
    }
    // 开始定位
    [_locationManager startUpdatingLocation];
}

-(void)endLocate{
    [_locationManager stopUpdatingLocation];
    _locationManager = nil;
}

#pragma mark -location
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation* location = [locations lastObject];
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setValue:location forKey:@"currentLocation"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocateSuccessNotification object:nil userInfo:userInfo];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setValue:error forKey:@"locateError"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocateFailedNotification object:nil userInfo:userInfo];

}

@end
