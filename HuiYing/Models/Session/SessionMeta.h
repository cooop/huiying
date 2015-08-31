//
//  SessionMeta.h
//  HuiYing
//
//  Created by Jin Xin on 15/5/8.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieMeta.h"

@interface SessionMeta : NSObject
@property (nonatomic) int64_t sessionID;
@property (nonatomic) MovieVersion version;
@property (nonatomic,strong) NSDate* startTime;
@property (nonatomic,strong) NSDate* endTime;
@property (nonatomic) int64_t maxPrice;
@property (nonatomic) int64_t minPrice;
@property (nonatomic,strong) NSString* room;
@property (nonatomic) int64_t movieID;
@property (nonatomic) int64_t cinemaID;
@property (nonatomic) NSString *language;

-(id) initWithDict:(NSDictionary*)dict ofMovie:(int64_t)movieID inCinema:(int64_t)cinemaID;

@end

