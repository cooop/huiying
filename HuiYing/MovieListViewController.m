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
#import "CinemaTableViewController.h"

@interface MovieListViewController ()

@property (nonatomic, strong) UIButton *cityButton;
@property (nonatomic, copy) NSString *cityButtonTitle;
@property (nonatomic, strong) MovieTableViewController * movieTableViewController;
@property (nonatomic, strong) CinemaTableViewController * cinemaTableViewController;
//@property (nonatomic, strong) ODRefreshControl *refreshMovieControl;
//@property (nonatomic, strong) ODRefreshControl *refreshCinemaControl;
@property (nonatomic, assign) int64_t cityID;
@property (nonatomic, strong) NSString * location;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation MovieListViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _movieTableViewController = [[MovieTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:_movieTableViewController];
    [self.view addSubview:self.movieTableViewController.tableView];
    
    _cinemaTableViewController = [[CinemaTableViewController alloc]initWithCityId:self.cityID];
    [self addChildViewController:_cinemaTableViewController ];
    [self.view addSubview:self.cinemaTableViewController.tableView];
    _cinemaTableViewController.tableView.hidden = YES;
    
    [_segmentedControl addTarget:self action:@selector(switchBetweenMovieAndCinema) forControlEvents:UIControlEventValueChanged];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.cityID = [[ApplicationSettings sharedInstance]cityID];
    self.location = [[ApplicationSettings sharedInstance]cityName];
    if (!self.cityID) {
        self.location = @"定位中";
        
    }
    
    NetworkManager *networkManager = [NetworkManager sharedInstance];
    [networkManager movieListInCity:self.cityID];
    [networkManager cinemaListInCity:self.cityID];
    
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(movieListSuccess:) name:kMovieListSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cinemaListSuccess:) name:kCinemaListInCitySuccessNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kMovieListSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self  name:kCinemaListInCitySuccessNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -location
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];
//    [self getCity:currentLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"定位失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        //TODO: 加入重试按钮
    }
}

#pragma mark - notification handler

- (void)movieListSuccess:(NSNotification*) notification{
    NSDictionary* userInfo = [notification userInfo];
    self.movieTableViewController.movies = userInfo[kUserInfoKeyMovies];
    [self.movieTableViewController.tableView reloadData];
}

- (void)cinemaListSuccess:(NSNotification*) notification{
    NSDictionary* userInfo = [notification userInfo];
    self.cinemaTableViewController.cinemas = userInfo[kUserInfoKeyCinemas];
    [self.cinemaTableViewController.tableView reloadData];
}

#pragma mark - private methods
- (void)dropViewDidBeginRefreshingMovies
{
    [[NetworkManager sharedInstance] movieListInCity:self.cityID];
}

- (void)dropViewDidBeginRefreshingCinemas
{
    [[NetworkManager sharedInstance] cinemaListInCity:self.cityID];
}

-(void)pushToCityListView {
    CityListViewController * cityListViewController = [[CityListViewController alloc]init];
    [self.navigationController pushViewController:cityListViewController animated:YES];
}

-(void)switchBetweenMovieAndCinema{
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        self.movieTableViewController.tableView.hidden = YES;
        self.cinemaTableViewController.tableView.hidden = NO;
        [self.cinemaTableViewController.tableView reloadData];
    }else{
        self.cinemaTableViewController.tableView.hidden = YES;
        self.movieTableViewController.tableView.hidden = NO;
        [self.movieTableViewController.tableView reloadData];
    }
}

-(void)startToLocate{
    if([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }else {
        //TODO:提示用户无法进行定位操作,未测试
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"定位未开启" message:@"请前往系统设置开启定位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
    {
        //设置定位权限 仅ios8有意义
        [self.locationManager requestWhenInUseAuthorization];// 前台定位
        
        //  [locationManager requestAlwaysAuthorization];// 前后台同时定位
    }
    // 开始定位
    [_locationManager startUpdatingLocation];
}

@end
