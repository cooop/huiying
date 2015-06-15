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
        _rate = [[dict objectForKey:kJSONKeyCinemaRate]intValue];
        _coming = [dict objectForKey:kJSONKeyCinemaComing];
        _distance = [[dict objectForKey:kJSONKeyCinemaDistance]floatValue];
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"CinemaMeta{\n\tcinemaID : %lld,\n\tcinemaName : %@,\n\tcityID : %lld,\n\tdistrictID : %lld,\n\taddress : %@,\n\trate : %d\n\tdistance : %f,\n\tcoming : %@\n}",_cinemaID,_cinemaName,_cityID,_districtID,_address,_rate,_distance,_coming];
}
@end
