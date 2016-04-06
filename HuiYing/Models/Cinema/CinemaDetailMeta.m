//
//  CinemaDetailMeta.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/24.
//  Copyright (c) 2015年 huiying. All rights reserved.
//

#import "CinemaDetailMeta.h"
#import "Constraits.h"

@implementation CinemaDetailMeta

-(id)initWithDict:(NSDictionary *)dict{
    if (self = [super initWithDict:dict]) {
        _phone = [dict objectForKey:kJSONKeyCinemaPhone];
        _longitude = [[dict objectForKey:kJSONKeyCinemaLongitude]floatValue];
        _latitude = [[dict objectForKey:kJSONKeyCinemaLatitude]floatValue];
        _service = [dict objectForKey:kJSONKeyCinemaService];
    }
    return self;
}

@end
