//
//  SessionsMeta.m
//  HuiYing
//
//  Created by 金鑫 on 15/7/10.
//  Copyright (c) 2015年 huiying. All rights reserved.
//

#import "SessionsMeta.h"
#import "SessionMeta.h"

@implementation SessionsMeta

-(id)initWithArray:(NSArray *)array ofMovie:(int64_t)movieID inCinema:(int64_t)cinemaID{
    if (self = [super init]) {
        NSMutableArray* dateArray = [NSMutableArray array];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSMutableDictionary* dateSessionsDic = [NSMutableDictionary dictionary];
        for (NSDictionary* sessionsOfDate in array) {
            NSEnumerator* enumerator = [sessionsOfDate keyEnumerator];
            NSString* dateStr = nil;
            if ((dateStr = enumerator.nextObject) != nil) {
                NSDate* date = [dateFormatter dateFromString:dateStr];
                NSMutableArray* sessions = [NSMutableArray array];
                for (NSDictionary* dict in sessionsOfDate[dateStr]) {
                    SessionMeta* session = [[SessionMeta alloc]initWithDict:dict ofMovie:movieID inCinema:cinemaID];
                    [sessions addObject:session];
                }
                [dateArray addObject:date];
                [dateSessionsDic setValue:sessions forKey:date];
            }
        }
        [dateArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [(NSDate*)obj1 compare:(NSDate*)obj2];
        }];
        _dates = dateArray;
        _dateSessionsDic = dateSessionsDic;
    }
    return self;
}
@end
