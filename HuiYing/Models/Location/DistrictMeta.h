//
//  DistrictMeta.h
//  HuiYing
//
//  Created by Jin Xin on 15/5/8.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DistrictMeta : NSObject
@property (nonatomic) int64_t cityID;
@property (nonatomic) int64_t districtID;
@property (nonatomic,strong) NSString* districtName;
-(id)initWithDict:(NSDictionary *)dict inCity:(int64_t)cityID;
@end
