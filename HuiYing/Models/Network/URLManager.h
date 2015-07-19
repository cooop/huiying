//
//  URLManager.h
//  HuiYing
//
//  Created by Jin Xin on 15/5/7.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLManager : NSObject

+(NSString *) huiyingURL;

//位置查询
+(NSString *) cityList;
+(NSString *) districtListInCity:(int64_t)cityID;

//影院查询
+(NSString *) cinemaList;
+(NSString *) cinemaListInCity:(int64_t)cityID;
+(NSString *) cinemaListInCity:(int64_t)cityID inDistrict:(int64_t)districtID;

//电影查询
+(NSString *) movieListInCity:(int64_t)cityID;
+(NSString *)movieListInCinema:(int64_t)cinemaID;
+(NSString *) movieListDetailWithID:(int64_t)movieID;

//场次查询
+(NSString *) sessionOfMovie:(int64_t)movieID inCinema:(int64_t)cinemaID;

//票价查询
+(NSString *) ticketPriceOfSession:(int64_t)sessionID;

@end
