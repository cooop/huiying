//
//  NetworkManager.h
//  HuiYing
//
//  Created by Jin Xin on 15/5/8.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "Constraits.h"

@interface NetworkManager : AFHTTPRequestOperationManager

DECLARE_SHARED_INSTANCE(NetworkManager);

//位置查询
-(void) cityList;
-(void) districtListInCity:(int64_t)cityID;

//影院查询
-(void) cinemaList;
-(void) cinemaListInCity:(int64_t)cityID;
-(void) cinemaListInCity:(int64_t)cityID inDistrict:(int64_t)districtID;

//电影查询
-(void) movieList;
-(void) movieListDetailWithID:(int64_t)movieID;

//场次查询
-(void) sessionOfMovie:(int64_t)movieID inCinema:(int64_t)cinemaID;

//票价查询
-(void) ticketPriceOfSession:(int64_t)sessionID;

@end
