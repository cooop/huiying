//
//  CityMeta.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/8.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CityMeta.h"
#import "Constraits.h"

@implementation CityMeta

-(id)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        _cityID = [[dict objectForKey:kJSONKeyCityID]intValue];
        _cityName = [dict objectForKey:kJSONKeyCityName];
    }
    return self;
}
@end
