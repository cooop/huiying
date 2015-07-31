//
//  MyPoint.m
//  HuiYing
//
//  Created by 金鑫 on 15/7/20.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "MyPoint.h"

@implementation MyPoint
-(id)initWithCoordinate:(CLLocationCoordinate2D)c andTitle:(NSString *)t{
    self = [super init];
    if(self){
        _coordinate = c;
        _title = t;
    }
    return self;
}
@end
