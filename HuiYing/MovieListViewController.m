//
//  ViewController.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/6.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "MovieListViewController.h"
#import "MovieListTableViewCell.h"
#import "NetworkManager.h"
#import "ODRefreshControl.h"

@interface MovieListViewController ()

@property (strong, nonatomic) UIButton *cityButton;
@property (copy, nonatomic) NSString *cityButtonTitle;
@property (nonatomic, strong) UITableView * movieListTableView;
@property (nonatomic, strong) ODRefreshControl *refreshControl;

@property (nonatomic, strong) NSArray * movies;
@property (nonatomic, strong) NSString * location;

@end

@implementation MovieListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = UI_COLOR_PINK;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    _location = @"杭州";
    
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
    
    UIBarButtonItem *locationBarButton = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = locationBarButton;
    
    self.movieListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.movieListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.movieListTableView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT);
//    self.movieListTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.movieListTableView.rowHeight = 105;
    self.movieListTableView.dataSource = self;
    self.movieListTableView.delegate = self;
    self.edgesForExtendedLayout= UIRectEdgeNone;
    [self.view addSubview:self.movieListTableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(movieListSuccess:) name:kMovieListSuccessNotification object:nil];
    
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.movieListTableView];
    [_refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing) forControlEvents:UIControlEventValueChanged];
    
}

- (void)dropViewDidBeginRefreshing
{
    [[NetworkManager sharedInstance] movieList];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //For TEST
    NetworkManager *networkManager = [NetworkManager sharedInstance];
//    [networkManager cityList];
//    [networkManager districtListInCity:110100];
//    [networkManager cinemaList];
//    [networkManager cinemaListInCity:110100];
//    [networkManager cinemaListInCity:110100 inDistrict:6911];
    [networkManager movieList];
//    [networkManager movieListDetailWithID:1];
//    [networkManager sessionOfMovie:1 inCinema:1];
//    [networkManager ticketPriceOfSession:1];
    
    [self.movieListTableView deselectRowAtIndexPath:self.movieListTableView.indexPathForSelectedRow animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)movieListSuccess:(NSNotification*) notification{
    NSDictionary* userInfo = [notification userInfo];
    self.movies = userInfo[kUserInfoKeyMovies];
    [self.movieListTableView reloadData];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_refreshControl endRefreshing];
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const identifier = @"MovieListTableIdentifier";
    MovieListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MovieListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.movieMeta = self.movies[indexPath.row];
    [cell showMovieCell];
    return cell;
}


@end
