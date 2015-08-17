//
//  DistrictPullDownViewController.h
//  HuiYing
//
//  Created by Jin Xin on 15/5/28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "PullDownViewController.h"
#import "DistrictMeta.h"

@interface DistrictPullDownViewController : PullDownViewController
@property (nonatomic,assign) int64_t cityId;
@property (nonatomic,strong) NSArray* districts;
@property (nonatomic,strong) DistrictMeta* selectedDistrict;
-(instancetype)initWithCityID:(int64_t)cityId;
@end
