//
//  MovieTableViewController.h
//  HuiYing
//
//  Created by Jin Xin on 15/5/27.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewController : UITableViewController
@property (nonatomic, assign) int64_t cityID;
@property (nonatomic, strong) NSArray * movies;
@property (nonatomic, assign) int64_t moviePage;
-(instancetype)initWithCityId:(int64_t)cityId;
@end
