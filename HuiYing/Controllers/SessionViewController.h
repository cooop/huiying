//
//  SessionViewController.h
//  HuiYing
//
//  Created by Jin Xin on 15/7/2.
//  Copyright (c) 2015年 huiying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CinemaMeta.h"
#import "MovieMeta.h"

@interface SessionViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>

- (id)initWithCinemaMeta:(CinemaMeta*)cinema;

- (id)initWithCinemaMeta:(CinemaMeta*)cinema andMovieId:(int64_t)movieId;
@end
