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

-(void)startLocate;
-(void)endLocate;

@end
