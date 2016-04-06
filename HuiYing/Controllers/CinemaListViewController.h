//
//  CinemaTableViewController.h
//  HuiYing
//
//  Created by Jin Xin on 15/5/25.
//  Copyright (c) 2015年 huiying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "OrderPullDownViewController.h"
#import "DistrictMeta.h"

@interface CinemaListViewController : UIViewController
@property (nonatomic, strong) NSArray* cinemas;
@property (nonatomic, assign) int64_t cityID;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, assign) int64_t cinemaPage;
@property (nonatomic, strong) DistrictMeta* selectedDistrict;
@property (nonatomic, assign) CinemaOrderType selectedOrderType;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, assign) int64_t movieId;
@property (nonatomic, assign) int64_t oldCityID;
@property (nonatomic, strong) NSArray* districts;
@property (nonatomic, assign) BOOL isSearch;

-(instancetype)initWithCityId:(int64_t)cityId;
-(instancetype)initWithCityId:(int64_t)cityId movieId:(int64_t)movieId;
-(instancetype)initWithCityId:(int64_t)cityId isSearch:(BOOL)isSearch;

- (void)search:(NSString*)searchKey;
@end
