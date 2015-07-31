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
@property (nonatomic) float rate;
@property (nonatomic) float distance;
@property (nonatomic, strong) NSDate* coming;
-(id)initWithDict:(NSDictionary *)dict;
@end
