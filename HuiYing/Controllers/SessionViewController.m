//
//  SessionViewController.m
//  HuiYing
//
//  Created by Jin Xin on 15/7/2.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionViewController.h"
#import "CinemaMeta.h"
#import "MovieMeta.h"
#import "Constraits.h"

@interface SessionViewController ()
@property (nonatomic, strong) CinemaMeta* cinema;
@property (nonatomic, strong) MovieMeta* movie;

@property (nonatomic, strong) UIView * cinemaView;
@property (nonatomic, strong) UILabel* cinemaName;
@property (nonatomic, strong) UILabel* cinemaAddress;
@property (nonatomic, strong) UICollectionView *imageCollectionView;
@property (nonatomic, strong) UIView * movieView;
@property (nonatomic, strong) UILabel* movieName;
@property (nonatomic, strong) UIImageView* movieVersion;
@property (nonatomic, strong) UILabel* movieRate;
@property (nonatomic, strong) UICollectionView * dateCollectionView;
@property (nonatomic, strong) UITableView * sessionTableView;
@end

@implementation SessionViewController

- (id)initWithCinemaMeta:(CinemaMeta*)cinema{
    if (self = [super init]) {
        _cinema =  cinema;
    }
    return self;
}

- (id)initWithCinemaMeta:(CinemaMeta*)cinema andMovieMeta:(MovieMeta*)movie{
    if (self = [super init]) {
        _cinema =  cinema;
        _movie = movie;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self drawNavigationBar];
    
    _cinemaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 60)];
    
    _cinemaName = [[UILabel alloc]init];
    _cinemaName.text = self.cinema.cinemaName;
    _cinemaName.textColor = UIColorFromRGB(0x000000);
    _cinemaName.font = [UIFont systemFontOfSize:15];
    CGSize size = [_cinemaName.text sizeWithAttributes:@{NSFontAttributeName:_cinemaName.font}];
    if (size.width < UI_SCREEN_WIDTH -30) {
        _cinemaName.frame = CGRectMake(10, 10, size.width, size.height);
    }else{
        _cinemaName.frame = CGRectMake(10, 10, UI_SCREEN_WIDTH -30, size.height);
    }
    
    _cinemaAddress = [[UILabel alloc]init];
    _cinemaAddress.text = self.cinema.address;
    _cinemaAddress.textColor = UIColorFromRGB(0x6E6E6E);
    _cinemaAddress.font = [UIFont systemFontOfSize:13];
    size = [_cinemaAddress.text sizeWithAttributes:@{NSFontAttributeName:_cinemaAddress.font}];
    if (size.width < UI_SCREEN_WIDTH -30) {
        _cinemaAddress.frame = CGRectMake(10, 36, size.width, size.height);
    }else{
        _cinemaAddress.frame = CGRectMake(10, 36, UI_SCREEN_WIDTH -30, size.height);
    }
    
    _imageCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 60, UI_SCREEN_WIDTH, 115)];
}

- (void)drawNavigationBar{
    //navi bar
    self.navigationController.navigationBar.barTintColor = UI_COLOR_PINK;
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = self.cinema.cinemaName;
    titleLabel.textColor = UIColorFromRGB(0xFFFFFF);
    
    CGFloat titleWidth = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:titleLabel.font}].width;
    CGFloat titleHeight = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:titleLabel.font}].height;
    
    titleLabel.frame = CGRectMake(0, 0, titleWidth, titleHeight);
    self.navigationItem.titleView = titleLabel;
    
    
    UIImage * image = [UIImage imageNamed:@"nav_back"];
    UIImageView * view = [[UIImageView alloc]initWithImage:image];
    view.frame = CGRectMake(10,UI_STATUS_BAR_HEIGHT+UI_NAVIGATION_BAR_HEIGHT/2-image.size.height/2, image.size.width, image.size.height);
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToParentView)]];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = backBarButton;
}

-(void)backToParentView{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
