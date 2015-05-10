//
//  SessionMeta.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/8.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionMeta.h"
#import "Constraits.h"
#import "Utils.h"

@implementation SessionMeta
-(id)initWithDict:(NSDictionary *)dict ofMovie:(int64_t)movieID inCinema:(int64_t)cinemaID{
    if (self = [super init]) {
        _sessionID = [[dict objectForKey:kJSONKeySessionID]intValue];
        _version = [MovieMeta translateMovieVersion:[dict objectForKey:kJSONKeySessionVersion]];
        _time = [Utils formatDate:[dict objectForKey:kJSONKeySessionTime]];
        _room = [dict objectForKey:kJSONKeySessionRoom];
        _cinemaID = cinemaID;
        _movieID = movieID;
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"SessionMeta{\n\tsessionID : %lld,\n\tversion : %d,\n\ttime : %@,\n\troom : %@,\n\tcinemaID : %lld,\n\tmovieID : %lld\n}",_sessionID,_version,_time,_room,_cinemaID,_movieID];
}
@end
