//
//  MovieListTableViewCell.h
//  HuiYing
//
//  Created by Jin Xin on 15/5/16.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieMeta.h"

@interface MovieListTableViewCell : UITableViewCell
@property (nonatomic, strong) MovieMeta* movieMeta;

-(void)showMovieCell;
@end
