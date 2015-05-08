//
//  CinemaMeta.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/8.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CinemaMeta.h"
#import "Constraits.h"

@implementation CinemaMeta

-(id)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        _cinemaID = [[dict objectForKey:kJSONKeyCinemaID]intValue];
        _cinemaName = [dict objectForKey:kJSONKeyCinemaName];
        _cityID = [[dict objectForKey:kJSONKeyCinemaCityID]intValue];
        _districtID = [[dict objectForKey:kJSONKeyCinemaDistrictID]intValue];
        _address = [dict objectForKey:kJSONKeyCinemaAddress];
        _phone = [dict objectForKey:kJSONKeyCinemaPhone];
        _longitude = [[dict objectForKey:kJSONKeyCinemaLongitude]floatValue];
        _latitude = [[dict objectForKey:kJSONKeyCinemaLatitude]floatValue];
        _service = [dict objectForKey:kJSONKeyCinemaService];
        _rate = [[dict objectForKey:kJSONKeyCinemaRate]intValue];
    }
    return self;
}
@end
