//
//  SessionsMeta.h
//  HuiYing
//
//  Created by 金鑫 on 15/7/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionsMeta : NSObject
@property (nonatomic, strong) NSArray* dates;
@property (nonatomic, strong) NSDictionary* dateSessionsDic;
-(id)initWithArray:(NSArray *)array ofMovie:(int64_t)movieID inCinema:(int64_t)cinemaID;
@end
