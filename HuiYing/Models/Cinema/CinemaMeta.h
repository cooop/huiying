//
//  CinemaMeta.h
//  HuiYing
//
//  Created by Jin Xin on 15/5/8.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CinemaMeta : NSObject
@property (nonatomic) int64_t cinemaID;
@property (nonatomic,strong) NSString* cinemaName;
@property (nonatomic) int64_t cityID;
@property (nonatomic) int64_t districtID;
@property (nonatomic,strong) NSString * address;
@property (nonatomic,strong) NSString * phone;
@property (nonatomic) float longitude;
@property (nonatomic) float latitude;
@property (nonatomic,strong) NSString * service;
@property (nonatomic) int rate;
-(id)initWithDict:(NSDictionary *)dict;
@end
