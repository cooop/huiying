//
//  PullDownViewController.h
//  HuiYing
//
//  Created by Jin Xin on 15/5/28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullDownViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * tableView;
@end
