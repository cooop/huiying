//
//  LocationManager.h
//  HuiYing
//
//  Created by 金鑫 on 15/9/6.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Constraits.h"

@interface LocationManager : NSObject

DECLARE_SHARED_INSTANCE(LocationManager);

@property (nonatomic, strong) NSMutableDictionary *cities;
@property (nonatomic, strong) NSMutableArray *keys; //城市首字母
@property (nonatomic, assign) BOOL alertShow;
@property (nonatomic, strong) CLLocation* currentLocation;

-(void)startLocate;
-(void)endLocate;

@end
