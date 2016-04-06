//
//  DistrictMeta.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/8.
//  Copyright (c) 2015年 huiying. All rights reserved.
//

#import "DistrictMeta.h"
#import "Constraits.h"

@implementation DistrictMeta

-(id)initWithDict:(NSDictionary *)dict inCity:(int64_t)cityID{
    if (self = [super init]) {
        _cityID = cityID;
        _districtID = [[dict objectForKey: kJSONKeyDistrictID] intValue];
        _districtName  = [dict objectForKey:kJSONKeyDistrictName];
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"DistrictMeta{\n\tcityID : %lld,\n\tdistrictID : %lld,\n\tdistrictName : %@\n}",_cityID,_districtID,_districtName];
}

@end
