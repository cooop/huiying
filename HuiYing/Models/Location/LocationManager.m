//
//  LocationManager.m
//  HuiYing
//
//  Created by 金鑫 on 15/9/6.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "LocationManager.h"
#import "ApplicationSettings.h"
#import "CityMeta.h"
#import "NetworkManager.h"

@interface LocationManager()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;//定义Manager

//for locating
@property (nonatomic, assign) NSInteger timestamp;
@property (nonatomic, strong) NSArray * cityList;
@property (nonatomic, strong) CityMeta * oldCity;

@end

@implementation LocationManager
IMPLEMENT_SHARED_INSTANCE(LocationManager);

-(void)startLocate{
    
    _alertShow = NO;
    _keys = [NSMutableArray array];
    _cities = [NSMutableDictionary dictionary];
    
    _timestamp = [[ApplicationSettings sharedInstance] timestamp];
    _cityList = [[ApplicationSettings sharedInstance] cityList];
    [self parseCityList:self.cityList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(versionGet:) name:kCityVersionSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityListSuccess:) name:kCityListSuccessNotification object:nil];
    
    [[NetworkManager sharedInstance] cityVersion];
    
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCityVersionSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCityListSuccessNotification object:nil];
    
    [_locationManager stopUpdatingLocation];
    _locationManager = nil;
}

-(void)getCityData
{
    NSString *local = @"定位";
    if (![self.keys containsObject:local]) {
        [self.keys insertObject:local atIndex:0];
    }
    CityMeta* cityMeta = [self locatingCityMeta];
    [self.cities setValue:@[cityMeta] forKey:local];
}

-(void)parseCityList:(NSArray*)cityList{
    
    for(NSDictionary* cityDict in cityList){
        NSEnumerator* enumerator = [cityDict keyEnumerator];
        NSString* cityKey = nil;
        if ((cityKey = enumerator.nextObject) != nil) {
            NSString* key = cityKey;
            
            NSMutableArray * cityArray = [NSMutableArray array];
            for(NSDictionary* city in cityDict[cityKey]){
                CityMeta* cityMeta =[[CityMeta alloc]initWithDict:city];
                [cityArray addObject:cityMeta];
            }
            
            if ([cityArray count] > 0) {
                if ([cityKey isEqualToString:@"hot"]) {
                    [self.keys addObject:@"热门"];
                    key = @"热门";
                }else{
                    [self.keys addObject:cityKey];
                }
                [self.cities setValue:cityArray forKey:key];
            }
        }
    }
    [self getCityData];
}

-(CityMeta*)formatCityName:(NSString*)cityStr{
    if (cityStr== nil) {
        return [self locatingCityMeta];
    }
    for(NSString* key in self.keys){
        for(CityMeta* city in self.cities[key]){
            if ([cityStr hasPrefix:city.cityName]) {
                return city;
            }
        }
    }
    return [self locatingCityMeta];
}

-(CityMeta*)locatingCityMeta{
    CityMeta* cityMeta = [[CityMeta alloc] init];
    cityMeta.cityName =@"正在定位...";
    cityMeta.cityID = -100;
    return  cityMeta;
}

-(void)getCity:(CLLocation*)location{
    __block CityMeta* city = [self locatingCityMeta];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0){
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *cityStr = placemark.locality;
            cityStr = cityStr?cityStr:placemark.administrativeArea;
            city = [self formatCityName:cityStr];
            [self.cities setValue:@[city] forKey:self.keys[0]];            
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
            [userInfo setValue:location forKey:kUserInfoCurrentLocation];
            [userInfo setValue:city forKey:kUserInfoCurrentCity];
            
            if (!self.oldCity) {
                self.oldCity = city;
            }else{
                if (self.oldCity.cityID != city.cityID) {
                    self.oldCity = city;
                    self.alertShow = NO;
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLocateSuccessNotification object:nil userInfo:userInfo];
        }
    }];
}

#pragma mark -location
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation* location = [locations lastObject];
    self.currentLocation = location;
    [self getCity:location];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setValue:error forKey:@"locateError"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocateFailedNotification object:nil userInfo:userInfo];
}


#pragma mark - notification
-(void)versionGet:(NSNotification*)notification{
    NSDictionary * userInfo = [notification userInfo];
    NSInteger timestamp = [userInfo[kUserInfoKeyCityVersion] integerValue];
    if (timestamp > self.timestamp) {
        [ApplicationSettings sharedInstance].timestamp = timestamp;
        [[ApplicationSettings sharedInstance] saveSettings];
        [[NetworkManager sharedInstance] cityList];
    }
}

-(void)cityListSuccess:(NSNotification*)notification{
    NSDictionary * userInfo = [notification userInfo];
    [self.keys removeAllObjects];
    [self.cities removeAllObjects];
    [self parseCityList:userInfo[kUserInfoKeyCities]];
    self.cityList = userInfo[kUserInfoKeyCities];
    [ApplicationSettings sharedInstance].cityList = self.cityList;
    [[ApplicationSettings sharedInstance] saveSettings];
}

@end
