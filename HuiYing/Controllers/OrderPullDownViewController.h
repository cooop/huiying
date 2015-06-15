//
//  OrderPullDownViewController.h
//  HuiYing
//
//  Created by Jin Xin on 15/6/2.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "PullDownViewController.h"

typedef enum CinemaOrderType{
    CinemaOrderTypeDefault = 0,
    CinemaOrderTypeDistance,
    CinemaOrderTypeRate
}CinemaOrderType;

@interface OrderPullDownViewController : PullDownViewController
@property (nonatomic,assign) CinemaOrderType selectedOrderType;
@end
