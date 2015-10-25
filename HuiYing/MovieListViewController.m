//
//  ViewController.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/6.
//  Copyright (c) 2015年 Netease. All rights reserved.
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

@interface MovieListViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;//定义Manager
@property (nonatomic, strong) UIButton *cityButton;
@property (nonatomic, copy) NSString *cityButtonTitle;
@property (nonatomic, strong) MovieTableViewController * movieTableViewController;
@property (nonatomic, strong) CinemaListViewController * cinemaListViewController;
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
    
    self.edgesForExtendedLayout= UIRectEdgeNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locateSuccess:) name:kLocateSuccessNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLocateSuccessNotification object:nil];
    [self.movieTableViewController.tableView removeFromSuperview];
    [self.cinemaListViewController.view removeFromSuperview];
}

#pragma mark - private methods

-(void)pushToCityListView {
    CityListViewController * cityListViewController = [[CityListViewController alloc]init];
    [self.navigationController pushViewController:cityListViewController animated:YES];
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

@end
