//
//  URLManager.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/7.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "URLManager.h"

#define SERVER_ADDRESS @"http://182.92.219.92:8000"

@implementation URLManager

+(NSString *)huiyingURL{
    //TODO: 做一些可连接性的检查
    return SERVER_ADDRESS;
}

#pragma mark - location query
+(NSString *)cityList{
    return [NSString stringWithFormat:@"%@/city/",[URLManager huiyingURL]];
}

+(NSString *)districtListInCity:(int64_t)cityID{
    return [NSString stringWithFormat:@"%@/city/%lld/",[URLManager huiyingURL],cityID];
}

#pragma mark - cimema query
+(NSString *)cinemaList{
    return [NSString stringWithFormat:@"%@/cinema/", [URLManager huiyingURL]];
}

+(NSString *)cinemaListInCity:(int64_t)cityID{
    return [NSString stringWithFormat:@"%@/cinema/%lld/",[URLManager huiyingURL],cityID];
}

+(NSString *)cinemaListInCity:(int64_t)cityID inDistrict:(int64_t)districtID{
   return [NSString stringWithFormat:@"%@/cinema/%lld/%lld/",[URLManager huiyingURL],cityID,districtID];
}

#pragma mark - movie query

+(NSString *)movieListInCity:(int64_t)cityID{
    return [NSString stringWithFormat:@"%@/movie/?city_id=%lld", [URLManager huiyingURL],cityID];
}

+(NSString *)movieListDetailWithID:(int64_t)movieID{
    return [NSString stringWithFormat:@"%@/movie/%lld/", [URLManager huiyingURL], movieID];
}

#pragma mark - session query

+ (NSString *)sessionOfMovie:(int64_t)movieID inCinema:(int64_t)cinemaID{
    return [NSString stringWithFormat:@"%@/session/cinema_%lld/movie_%lld/",[URLManager huiyingURL],cinemaID, movieID];
}

#pragma mark - ticket query

+ (NSString *)ticketPriceOfSession:(int64_t)sessionID{
    return [NSString stringWithFormat:@"%@/ticket/%lld/", [URLManager huiyingURL], sessionID];
}
@end