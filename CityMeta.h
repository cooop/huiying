//
//  CityMeta.h
//  HuiYing
//
//  Created by Jin Xin on 15/5/8.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityMeta : NSObject
@property (nonatomic) int64_t cityID;
@property (nonatomic,strong) NSString* cityName;
-(id)initWithDict:(NSDictionary *)dict;
@end
