//
//  CinemaMeta.h
//  HuiYing
//
//  Created by Jin Xin on 15/5/8.
//  Copyright (c) 2015年 huiying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CinemaMeta : NSObject
@property (nonatomic, assign) int64_t cinemaID;
@property (nonatomic, strong) NSString* cinemaName;
@property (nonatomic, assign) int64_t cityID;
@property (nonatomic, assign) int64_t districtID;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, assign) float rate;
@property (nonatomic, assign) float distance;
@property (nonatomic, strong) NSDate* coming;
@property (nonatomic, assign) int64_t movieNum;
-(id)initWithDict:(NSDictionary *)dict;
@end
