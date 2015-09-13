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

@interface MovieListViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;//定义Manager
@property (nonatomic, strong) UIButton *cityButton;
@property (nonatomic, copy) NSString *cityButtonTitle;
@property (nonatomic, strong) MovieTableViewController * movieTableViewController;
@property (nonatomic, strong) CinemaListViewController * cinemaListViewController;
@property (nonatomic, assign) int64_t cityID;
@property (nonatomic, strong) NSString * location;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

//for locating
@property (nonatomic, assign) NSInteger timestamp;
@property (nonatomic, strong) NSArray* cityList;
@property (nonatomic, strong) NSMutableDictionary *cities;
@property (nonatomic, strong) NSMutableArray *keys; //城市首字母

@end

@implementation MovieListViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _timestamp = [[ApplicationSettings sharedInstance] timestamp];
    _cityList = [[ApplicationSettings sharedInstance] cityList];
    [self parseCityList:self.cityList];
    
    _cityID = [[ApplicationSettings sharedInstance]cityID];
    _location = [[ApplicationSettings sharedInstance]cityName];
    if (!self.cityID) {
        self.location = @"北京";
        self.cityID  = 100005;
    }
    
    [[LocationManager sharedInstance] startLocate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(versionGet:) name:kCityVersionSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityListSuccess:) name:kCityListSuccessNotification object:nil];
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
    
    UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(+locationWidth+5, locationHeight-image.size.height-6, image.size.width, image.size.height);
    
    [view addSubview:locationLabel];
    [view addSubview:imageView];
    
    [view setUserInteractionEnabled:YES];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToCityListView)]];
    
    UIBarButtonItem *locationBarButton = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = locationBarButton;
    
    self.edgesForExtendedLayout= UIRectEdgeNone;
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.movieTableViewController.tableView removeFromSuperview];
    [self.cinemaListViewController.view removeFromSuperview];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCityVersionSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCityListSuccessNotification object:nil];
    [[LocationManager sharedInstance] endLocate];
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

-(void)getCityData
{
    NSString *local = @"定位";
    if (![self.keys containsObject:local]) {
        [self.keys insertObject:local atIndex:0];
    }
    CityMeta* cityMeta = [self locatingCityMeta];
    [self.cities setValue:@[cityMeta] forKey:local];
}

-(void)parseCityList:(NSArray*)cityList{
    
    for(NSDictionary* cityDict in cityList){
        NSEnumerator* enumerator = [cityDict keyEnumerator];
        NSString* cityKey = nil;
        if ((cityKey = enumerator.nextObject) != nil) {
            NSString* key = cityKey;
            if ([cityKey isEqualToString:@"hot"]) {
                [self.keys addObject:@"热门"];
                key = @"热门";
            }else{
                [self.keys addObject:cityKey];
            }
            NSMutableArray * cityArray = [NSMutableArray array];
            for(NSDictionary* city in cityDict[cityKey]){
                CityMeta* cityMeta =[[CityMeta alloc]initWithDict:city];
                [cityArray addObject:cityMeta];
            }
            [self.cities setValue:cityArray forKey:key];
        }
    }
    [self getCityData];
}

-(CityMeta*)formatCityName:(NSString*)cityStr{
    if (cityStr== nil) {
        return [self locatingCityMeta];
    }
    for(NSString* key in self.keys){
        for(CityMeta* city in self.cities[key]){
            if ([cityStr hasPrefix:city.cityName]) {
                return city;
            }
        }
    }
    return [self locatingCityMeta];
}

-(CityMeta*)locatingCityMeta{
    CityMeta* cityMeta = [[CityMeta alloc] init];
    cityMeta.cityName =@"正在定位...";
    cityMeta.cityID = -100;
    return  cityMeta;
}

#pragma mark - notification
-(void)versionGet:(NSNotification*)notification{
    NSDictionary * userInfo = [notification userInfo];
    NSInteger timestamp = [userInfo[kUserInfoKeyCityVersion] integerValue];
    if (timestamp > self.timestamp) {
        [ApplicationSettings sharedInstance].timestamp = timestamp;
        [[ApplicationSettings sharedInstance] saveSettings];
        [[NetworkManager sharedInstance] cityList];
    }
}

-(void)cityListSuccess:(NSNotification*)notification{
    NSDictionary * userInfo = [notification userInfo];
    [self parseCityList:userInfo[kUserInfoKeyCities]];
    self.cityList = userInfo[kUserInfoKeyCities];
    [ApplicationSettings sharedInstance].cityList = self.cityList;
    [[ApplicationSettings sharedInstance] saveSettings];
}

@end
