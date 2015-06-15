//
//  ViewController.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/6.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "MovieListViewController.h"
#import "NetworkManager.h"
#import "ODRefreshControl.h"
#import "CityListViewController.h"
#import "ApplicationSettings.h"
#import "MovieTableViewController.h"
#import "CinemaTableViewController.h"

@interface MovieListViewController ()

@property (nonatomic, strong) UIButton *cityButton;
@property (nonatomic, copy) NSString *cityButtonTitle;
@property (nonatomic, strong) MovieTableViewController * movieTableViewController;
@property (nonatomic, strong) CinemaTableViewController * cinemaTableViewController;
@property (nonatomic, strong) ODRefreshControl *refreshMovieControl;
@property (nonatomic, strong) ODRefreshControl *refreshCinemaControl;
@property (nonatomic, assign) int64_t cityID;

@property (nonatomic, strong) NSString * location;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation MovieListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //TODO: read from settings
    _cityID = 110100;
    _location = @"杭州";
    [ApplicationSettings sharedInstance].city = _location;
    
    _movieTableViewController = [[MovieTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:_movieTableViewController];
    [self.view addSubview:self.movieTableViewController.tableView];
    
    _cinemaTableViewController = [[CinemaTableViewController alloc]initWithCityId:self.cityID];
    [self addChildViewController:_cinemaTableViewController ];
    [self.view addSubview:self.cinemaTableViewController.tableView];
    _cinemaTableViewController.tableView.hidden = YES;
    
    [_segmentedControl addTarget:self action:@selector(switchBetweenMovieAndCinema) forControlEvents:UIControlEventValueChanged];
    
}

- (void)dropViewDidBeginRefreshingMovies
{
    [[NetworkManager sharedInstance] movieListInCity:self.cityID];
}

- (void)dropViewDidBeginRefreshingCinemas
{
    [[NetworkManager sharedInstance] cinemaListInCity:self.cityID];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NetworkManager *networkManager = [NetworkManager sharedInstance];
    [networkManager movieListInCity:self.cityID];
    [networkManager cinemaListInCity:self.cityID];
    
    _location = [ApplicationSettings sharedInstance].city;
    
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
    
    _refreshMovieControl = [[ODRefreshControl alloc] initInScrollView:self.movieTableViewController.tableView];
    [_refreshMovieControl addTarget:self action:@selector(dropViewDidBeginRefreshingMovies) forControlEvents:UIControlEventValueChanged];
    _refreshCinemaControl = [[ODRefreshControl alloc] initInScrollView:self.cinemaTableViewController.tableView];
    [_refreshCinemaControl addTarget:self action:@selector(dropViewDidBeginRefreshingCinemas) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kMovieListSuccessNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)movieListSuccess:(NSNotification*) notification{
    NSDictionary* userInfo = [notification userInfo];
    self.movieTableViewController.movies = userInfo[kUserInfoKeyMovies];
    [self.movieTableViewController.tableView reloadData];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_refreshMovieControl endRefreshing];
    });
}

- (void)cinemaListSuccess:(NSNotification*) notification{
    NSDictionary* userInfo = [notification userInfo];
    self.cinemaTableViewController.cinemas = userInfo[kUserInfoKeyCinemas];
    [self.cinemaTableViewController.tableView reloadData];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_refreshCinemaControl endRefreshing];
    });
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

@end
