//
//  CinemaTableViewController.h
//  HuiYing
//
//  Created by Jin Xin on 15/5/25.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CinemaTableViewController : UITableViewController
@property (nonatomic, strong) NSArray* cinemas;
@property (nonatomic, assign) int64_t cityID;
-(instancetype)initWithCityId:(int64_t)cityId;
@end
