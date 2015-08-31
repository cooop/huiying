//
//  CinemaMeta.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/8.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CinemaMeta.h"
#import "Constraits.h"
#import "Utils.h"

@implementation CinemaMeta

-(id)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        _cinemaID = [[dict objectForKey:kJSONKeyCinemaID]intValue];
        _cinemaName = [dict objectForKey:kJSONKeyCinemaName];
        _cityID = [[dict objectForKey:kJSONKeyCinemaCityID]intValue];
        _districtID = [[dict objectForKey:kJSONKeyCinemaDistrictID]intValue];
        _address = [dict objectForKey:kJSONKeyCinemaAddress];
        _rate = [[dict objectForKey:kJSONKeyCinemaRate]floatValue];
        _coming = [dict objectForKey:kJSONKeyCinemaComing];
        _distance = [[dict objectForKey:kJSONKeyCinemaDistance]floatValue];
        _movieNum = [[dict objectForKey:kJSONKeyCinemaMovieNum] intValue];
        _coming = [Utils formatDate:[dict objectForKey:kJSONKeyCinemaComing]];
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"CinemaMeta{\n\tcinemaID : %lld,\n\tcinemaName : %@,\n\tcityID : %lld,\n\tdistrictID : %lld,\n\taddress : %@,\n\trate : %f\n\tdistance : %f,\n\tcoming : %@\n}",_cinemaID,_cinemaName,_cityID,_districtID,_address,_rate,_distance,_coming];
}
@end
