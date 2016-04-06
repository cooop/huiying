//
//  MovieTableViewController.h
//  HuiYing
//
//  Created by Jin Xin on 15/5/27.
//  Copyright (c) 2015年 huiying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewController : UITableViewController
@property (nonatomic, assign) int64_t cityID;
@property (nonatomic, strong) NSArray * movies;
@property (nonatomic, assign) int64_t moviePage;
@property (nonatomic, assign) BOOL isSearch;
-(instancetype)initWithCityId:(int64_t)cityId;
-(instancetype)initWithCityId:(int64_t)cityId isSearch:(BOOL)isSearch;
- (void)search:(NSString*)searchKey;
@end
