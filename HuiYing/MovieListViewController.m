//
//  ViewController.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/6.
//  Copyright (c) 2015年 huiying. All rights reserved.
//

#import "MovieListViewController.h"
#import "NetworkManager.h"
#import "CityListViewController.h"
#import "ApplicationSettings.h"
#import "MovieTableViewController.h"
#import "CinemaListViewController.h"
#import "MJRefresh.h"
#import "CityMeta.h"
#import "LocationManager.h"
#import "MobClick.h"
#import "GDTMobBannerView.h"
#import "Constraits.h"
#import "SearchViewController.h"

@interface MovieListViewController ()<UIAlertViewDelegate, GDTMobBannerViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;//定义Manager
@property (nonatomic, strong) UIButton *cityButton;
@property (nonatomic, copy) NSString *cityButtonTitle;
@property (nonatomic, strong) MovieTableViewController * movieTableViewController;
@property (nonatomic, strong) CinemaListViewController * cinemaListViewController;
@property (nonatomic, strong) GDTMobBannerView* adBannerView;
@property (nonatomic, assign) int64_t cityID;
@property (nonatomic, strong) NSString * location;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) CityMeta * locateCity;
@property (nonatomic, strong) UILabel* locationLabel;


@end

@implementation MovieListViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    _cityID = [[ApplicationSettings sharedInstance]cityID];
    _location = [[ApplicationSettings sharedInstance]cityName];
    if (!self.cityID) {
        self.location = @"北京";
        self.cityID  = 100006;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:UMengMovieList];
    
    int64_t oldCityID = self.cityID;
    self.cityID = [[ApplicationSettings sharedInstance]cityID];
    self.location = [[ApplicationSettings sharedInstance]cityName];
    if (!self.cityID) {
        self.location = @"北京";
        self.cityID = 100005;
        [ApplicationSettings sharedInstance].cityID = self.cityID;
        [ApplicationSettings sharedInstance].cityName = self.location;
        [[ApplicationSettings sharedInstance] saveSettings];
    }
    
    if (!_movieTableViewController || oldCityID != self.cityID) {
        _movieTableViewController = [[MovieTableViewController alloc]initWithCityId:self.cityID];
        [self addChildViewController:_movieTableViewController];
    }
    [self.view addSubview:self.movieTableViewController.tableView];
    
    if (!_cinemaListViewController || oldCityID != self.cityID) {
        _cinemaListViewController = [[CinemaListViewController alloc]initWithCityId:self.cityID];
        [self addChildViewController:_cinemaListViewController];
    }
    [self.view addSubview:self.cinemaListViewController.view];
    [self switchBetweenMovieAndCinema];
    
    [_segmentedControl addTarget:self action:@selector(switchBetweenMovieAndCinema) forControlEvents:UIControlEventValueChanged];

    self.navigationController.navigationBar.barTintColor = UI_COLOR_PINK;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UILabel * locationLabel = [[UILabel alloc]init];
    locationLabel.text = _location;
    locationLabel.font = [UIFont systemFontOfSize:16];
    locationLabel.textColor = [UIColor whiteColor];
    CGFloat locationWidth = [locationLabel.text sizeWithAttributes:@{NSFontAttributeName:locationLabel.font}].width;
    CGFloat locationHeight = [locationLabel.text sizeWithAttributes:@{NSFontAttributeName:locationLabel.font}].height;
    UIImage* image = [UIImage imageNamed:@"nav_arrow"];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(15, UI_STATUS_BAR_HEIGHT+UI_NAVIGATION_BAR_HEIGHT-14-locationHeight, locationWidth+5+image.size.width,locationHeight)];
    locationLabel.frame = CGRectMake(0, 0, locationWidth, locationHeight);
    self.locationLabel = locationLabel;
    
    UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(+locationWidth+5, locationHeight-image.size.height-6, image.size.width, image.size.height);
    
    [view addSubview:locationLabel];
    [view addSubview:imageView];
    
    [view setUserInteractionEnabled:YES];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToCityListView)]];
    
    UIBarButtonItem *locationBarButton = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = locationBarButton;
    
    UIImageView* searchImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_icon"]];
    [searchImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToSearchView)]];
    UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc]initWithCustomView:searchImage];
    self.navigationItem.rightBarButtonItem = searchBarButton;
    
    self.edgesForExtendedLayout= UIRectEdgeNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locateSuccess:) name:kLocateSuccessNotification object:nil];
    
    if (!_adBannerView) {
        _adBannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - GDTMOB_AD_SUGGEST_SIZE_320x50.height, UI_SCREEN_WIDTH, GDTMOB_AD_SUGGEST_SIZE_320x50.height) appkey:GDTAPPKEY placementId:GDTBANNERID];
        _adBannerView.delegate = self; // 设置Delegate
        _adBannerView.currentViewController = self; //设置当前的ViewController
        _adBannerView.interval = 30; //【可选】设置广告轮播时间;范围为30~120秒,0表示不轮播
        _adBannerView.isGpsOn = NO; //【可选】开启GPS定位;默认关闭
        _adBannerView.showCloseBtn = YES; //【可选】展示关闭按钮;默认显示
        _adBannerView.isAnimationOn = YES; //【可选】开启banner轮播和展现时的动画效果;默认开启
        [self.view addSubview:_adBannerView]; //添加到当前的view中
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_adBannerView loadAdAndShow]; //加载广告并展示
    });
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:UMengMovieList];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLocateSuccessNotification object:nil];
    [self.movieTableViewController.tableView removeFromSuperview];
    [self.cinemaListViewController.view removeFromSuperview];
    [self.adBannerView removeFromSuperview];
    self.adBannerView = nil;
}

-(void)dealloc{
    _adBannerView.delegate = nil;
    _adBannerView.currentViewController = nil;
    _adBannerView = nil;
}

#pragma mark - private methods

-(void)pushToCityListView {
    CityListViewController * cityListViewController = [[CityListViewController alloc]init];
    [self.navigationController pushViewController:cityListViewController animated:YES];
}

-(void)pushToSearchView{
    SearchViewController * searchVC = [[SearchViewController alloc]initWithCityID:self.cityID];
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(void)switchBetweenMovieAndCinema{
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        self.movieTableViewController.tableView.hidden = YES;
        self.cinemaListViewController.view.hidden = NO;
        [self.cinemaListViewController.tableView reloadData];
    }else{
        self.cinemaListViewController.view.hidden = YES;
        self.movieTableViewController.tableView.hidden = NO;
        [self.movieTableViewController.tableView reloadData];
    }
}

#pragma mark - notification handler
-(void) locateSuccess:(NSNotification*)notification{
    NSDictionary* userInfo = [notification userInfo];
    CityMeta* city = userInfo[kUserInfoCurrentCity];
    
    if (![[LocationManager sharedInstance] alertShow] && city.cityID >= 0) {
        
        if (city.cityID != self.cityID) {
            NSString* title = [NSString stringWithFormat:@"定位到您当前所在城市为%@，是否切换？",city.cityName];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            [alert show];
            self.locateCity = city;
            [LocationManager sharedInstance].alertShow = YES;
        }
    }
}

#pragma mark - UIAlertViewDelegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [ApplicationSettings sharedInstance].cityID = self.locateCity.cityID;
        [ApplicationSettings sharedInstance].cityName = self.locateCity.cityName;
        [[ApplicationSettings sharedInstance] saveSettings];

        self.cityID = self.locateCity.cityID;
        self.location = self.locateCity.cityName;
        
        self.locationLabel.text = self.location;
        
        self.movieTableViewController.cityID = self.cityID;
        self.cinemaListViewController.cityID = self.cityID;
        
        [[NetworkManager sharedInstance] movieListInCity:self.cityID page:1];
        [[NetworkManager sharedInstance]cinemaListInCity:self.cityID movie:-1 inDistrict:(self.cinemaListViewController. selectedDistrict?self.cinemaListViewController.selectedDistrict.districtID:-1) page:1 location:self.cinemaListViewController.currentLocation orderBy:self.cinemaListViewController.selectedOrderType];
    }
}

#pragma mark - GDTMobBannerViewDelegate

- (void)bannerViewWillClose{
    _movieTableViewController.tableView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT);
    _cinemaListViewController.view.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT);
    _cinemaListViewController.tableView.frame = CGRectMake(0, 36, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT- 36);
}

- (void)bannerViewFailToReceived:(NSError *)error{
    _movieTableViewController.tableView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT);
    _cinemaListViewController.view.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT);
    _cinemaListViewController.tableView.frame = CGRectMake(0, 36, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT- 36);
}

- (void)bannerViewDidReceived{
    _movieTableViewController.tableView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT-GDTMOB_AD_SUGGEST_SIZE_320x50.height);
    _cinemaListViewController.view.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT-GDTMOB_AD_SUGGEST_SIZE_320x50.height);
    _cinemaListViewController.tableView.frame = CGRectMake(0, 36, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT-GDTMOB_AD_SUGGEST_SIZE_320x50.height- 36);
}


@end
