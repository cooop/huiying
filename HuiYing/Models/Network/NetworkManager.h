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
#import <CoreLocation/CoreLocation.h>
#import "OrderPullDownViewController.h"

@interface NetworkManager : AFHTTPRequestOperationManager

DECLARE_SHARED_INSTANCE(NetworkManager);

//位置查询
-(void) cityList;
-(void) cityVersion;
-(void) districtListInCity:(int64_t)cityID;

//影院查询
-(void) cinemaList;
-(void) cinemaListInCity:(int64_t)cityID movie:(int64_t)movieID inDistrict:(int64_t)districtID page:(int64_t)page location:(CLLocation*)location orderBy:(CinemaOrderType)order;
-(void) cinemaListDetailWithID:(int64_t)cinemaID;

//电影查询
-(void)movieListInCity:(int64_t)cityID page:(int64_t)page;
-(void)movieListInCinema:(int64_t)cinemaID;
-(void) movieListDetailWithID:(int64_t)movieID;

//场次查询
-(void) sessionOfMovie:(int64_t)movieID inCinema:(int64_t)cinemaID;

//票价查询
-(void) ticketPriceOfSession:(int64_t)sessionID;

@end
