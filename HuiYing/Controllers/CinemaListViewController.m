//
//  CinemaTableViewController.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/25.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CinemaListViewController.h"
#import "DistrictPullDownViewController.h"
#import "OrderPullDownViewController.h"
#import "Constraits.h"
#import "CinemaMeta.h"
#import "SessionViewController.h"
#import "MJRefresh.h"
#import "NetworkManager.h"

@interface CinemaListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView* districtView;
@property (nonatomic, strong) UILabel* districtLabel;
@property (nonatomic, strong) UIImageView* districtArrow;
@property (nonatomic, strong) UIView* districtBg;
@property (nonatomic, strong) UIView* orderView;
@property (nonatomic, strong) UILabel* orderLabel;
@property (nonatomic, strong) UIImageView* orderArrow;
@property (nonatomic, strong) UIView* orderBg;
@property (nonatomic, strong) DistrictPullDownViewController* districtViewController;
@property (nonatomic, strong) OrderPullDownViewController* orderViewController;

@end

@implementation CinemaListViewController

-(instancetype)initWithCityId:(int64_t)cityId{
    if (self = [super init]) {
        _cityID = cityId;
        _cinemaPage = 1;
        _movieId = -1;
    }
    return self;
}

-(instancetype)initWithCityId:(int64_t)cityId movieId:(int64_t)movieId{
    if (self = [self initWithCityId:cityId]) {
        _movieId = movieId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.frame = CGRectMake(0, 36, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT);
    self.tableView.rowHeight = 80;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.edgesForExtendedLayout= UIRectEdgeNone;
    self.tableView.sectionHeaderHeight = 36;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshCinemas)];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCinemas)];
    
    UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 36)];
    
    _districtView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH/2, 36)];
    _districtView.backgroundColor = UIColorFromRGB(0xF9F9F9);
    
    _districtLabel = [[UILabel alloc]init];
    _districtLabel.text = @"城区";
    _districtLabel.font = [UIFont systemFontOfSize:13];
    _districtLabel.textColor = [UIColor blackColor];
    
    _districtArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"museum_tab_arrow_down"]];
    
    [_districtView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(districtPullDown)]];
    
    CGFloat labelHeight = [_districtLabel.text sizeWithAttributes:@{NSFontAttributeName:_districtLabel.font}].height;
    CGFloat labelWidth = [_districtLabel.text sizeWithAttributes:@{NSFontAttributeName:_districtLabel.font}].width;
    CGFloat imageHeight = _districtArrow.image.size.height;
    CGFloat imageWidth = _districtArrow.image.size.width;
    
    _districtLabel.frame = CGRectMake((UI_SCREEN_WIDTH/2 - labelWidth -imageWidth - 5)/2, (36 - labelHeight)/2,labelWidth,labelHeight);
    _districtArrow.frame = CGRectMake(CGRectGetMaxX(_districtLabel.frame)+5, (36- imageHeight)/2, imageWidth, imageHeight);
    [_districtView addSubview:_districtLabel];
    [_districtView addSubview:_districtArrow];
    
    _orderView = [[UIView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2, 0, UI_SCREEN_WIDTH/2, 36)];
    _orderView.backgroundColor = UIColorFromRGB(0xF9F9F9);
    
    _orderLabel = [[UILabel alloc]init];
    _orderLabel.text = @"排序";
    _orderLabel.font = [UIFont systemFontOfSize:13];
    _orderLabel.textColor = [UIColor blackColor];
    
    _orderArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"museum_tab_arrow_down"]];
    [_orderView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(orderPullDown)]];
    
    labelHeight = [_orderLabel.text sizeWithAttributes:@{NSFontAttributeName:_orderLabel.font}].height;
    labelWidth = [_orderLabel.text sizeWithAttributes:@{NSFontAttributeName:_orderLabel.font}].width;
    imageHeight = _orderArrow.image.size.height;
    imageWidth = _orderArrow.image.size.width;
    
    _orderLabel.frame = CGRectMake((UI_SCREEN_WIDTH/2 - labelWidth -imageWidth - 5)/2, (36 - labelHeight)/2,labelWidth,labelHeight);
    _orderArrow.frame = CGRectMake(CGRectGetMaxX(_orderLabel.frame)+5, (36- imageHeight)/2, imageWidth, imageHeight);
    [_orderView addSubview:_orderLabel];
    [_orderView addSubview:_orderArrow];
    
    [headerView addSubview:_districtView];
    [headerView addSubview:_orderView];
    
    [self.view addSubview: headerView];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeCinemaList:) name:kCinemaListInCitySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidChange:) name:kLocationDidChangeNotification object:nil];
    [[NetworkManager sharedInstance]cinemaListInCity:self.cityID movie:self.movieId inDistrict:(self.selectedDistrict?self.selectedDistrict.districtID:-1) page:1 location:self.currentLocation orderBy:self.selectedOrderType];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCinemaListInCitySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLocationDidChangeNotification object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cinemas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const identifier = @"CinemaListTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    CinemaMeta* cinema = (CinemaMeta*)self.cinemas[indexPath.row];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = cinema.cinemaName;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor blackColor];
    CGFloat labelHeight = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:titleLabel.font}].height;
    CGFloat labelWidth = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:titleLabel.font}].width;
    labelWidth = labelWidth > UI_SCREEN_WIDTH - 11 - 45? UI_SCREEN_WIDTH - 11 - 45: labelWidth;
    titleLabel.frame = CGRectMake(11, 12, labelWidth, labelHeight);
    
    UILabel *locationLabel = [[UILabel alloc]init];
    locationLabel.text = cinema.address;
    locationLabel.font = [UIFont systemFontOfSize:13];
    locationLabel.textColor = UIColorFromRGB(0x6E6E6E);
    labelHeight = [locationLabel.text sizeWithAttributes:@{NSFontAttributeName:locationLabel.font}].height;
    labelWidth = [locationLabel.text sizeWithAttributes:@{NSFontAttributeName:locationLabel.font}].width;
    labelWidth = labelWidth > UI_SCREEN_WIDTH - 11 - 45? UI_SCREEN_WIDTH - 11 - 45: labelWidth;
    locationLabel.frame = CGRectMake(11, 38, labelWidth, labelHeight);
    
    UILabel *comingLabel = [[UILabel alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"HH:mm";
    if (self.movieId >= 0) {
        comingLabel.text = [NSString stringWithFormat:@"最近场次%@",[formatter stringFromDate:cinema.coming]];
    }else{
        comingLabel.text = [NSString stringWithFormat:@"在映%lld部", cinema.movieNum];
    }
    
    comingLabel.font = [UIFont systemFontOfSize:13];
    comingLabel.textColor = UIColorFromRGB(0x6E6E6E);
    labelHeight = [comingLabel.text sizeWithAttributes:@{NSFontAttributeName:comingLabel.font}].height;
    labelWidth = [comingLabel.text sizeWithAttributes:@{NSFontAttributeName:comingLabel.font}].width;
    comingLabel.frame = CGRectMake(11, 58, labelWidth, labelHeight);
    
    UILabel *ratingLabel = [[UILabel alloc]init];
    ratingLabel.frame = CGRectMake(UI_SCREEN_WIDTH - 40, 15, 30, 20);
    ratingLabel.backgroundColor = [UIColor clearColor];
    ratingLabel.textAlignment = NSTextAlignmentRight;
    ratingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:18];
    ratingLabel.textColor = UIColorFromRGB(0xFF7833);
    ratingLabel.text = [NSString stringWithFormat:@"%.1f",(float)cinema.rate];
    
    UILabel *distanceLabel = [[UILabel alloc]init];
    distanceLabel.text = [NSString stringWithFormat:@"%.1fkm",(float)cinema.distance/1000];
    distanceLabel.font = [UIFont systemFontOfSize:13];
    distanceLabel.textColor = UIColorFromRGB(0x6E6E6E);
    distanceLabel.textAlignment = NSTextAlignmentRight;
    labelHeight = [distanceLabel.text sizeWithAttributes:@{NSFontAttributeName:distanceLabel.font}].height;
    labelWidth = [distanceLabel.text sizeWithAttributes:@{NSFontAttributeName:distanceLabel.font}].width;
    distanceLabel.frame = CGRectMake(UI_SCREEN_WIDTH -10-labelWidth, 58, labelWidth, labelHeight);
    
    [cell addSubview:titleLabel];
    [cell addSubview:locationLabel];
    [cell addSubview:comingLabel];
    [cell addSubview:distanceLabel];
    [cell addSubview:ratingLabel];
    
    return cell;
}

-(void)hideOrderView{
    self.orderViewController.view.frame = CGRectMake(0, 36, UI_SCREEN_WIDTH, 0);
    self.orderLabel.textColor = [UIColor blackColor];
    self.orderArrow.image = [UIImage imageNamed:@"museum_tab_arrow_down"];
    
    [self.orderViewController.view removeFromSuperview];
    [self.orderViewController removeFromParentViewController];
    self.orderViewController = nil;
    
    self.orderBg.frame = CGRectMake(0, 36, UI_SCREEN_WIDTH, 0);
    [self.orderBg removeFromSuperview];
    self.orderBg = nil;
}

-(void)showOrderView{
    OrderPullDownViewController *orderVC = [[OrderPullDownViewController alloc] init];
    [self addChildViewController:orderVC];
    [self.view addSubview:orderVC.view];
    self.orderViewController = orderVC;
    self.orderViewController.view.frame = CGRectMake(0, 36, UI_SCREEN_WIDTH, 0);
    self.orderViewController.selectedOrderType = _selectedOrderType;
    self.orderLabel.textColor = UIColorFromRGB(0xF95C6F);
    self.orderArrow.image = [UIImage imageNamed:@"museum_tab_arrow_up"];
    
    self.orderBg = [[UIView alloc]initWithFrame:CGRectMake(0, 36, UI_SCREEN_WIDTH, 0)];
    self.orderBg.backgroundColor = UIColorFromRGBA(0x808080 , .8);
    [self.orderBg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(orderPullDown)]];
    [self.view addSubview:self.orderBg];
    
    self.orderViewController.view.frame = CGRectMake(0, 36, UI_SCREEN_WIDTH, 170);
    self.orderBg.frame = CGRectMake(0, CGRectGetMaxY(self.orderViewController.view.frame), UI_SCREEN_WIDTH, CGRectGetHeight(self.view.frame)- CGRectGetHeight(self.orderViewController.view.frame) -36);
}

-(void)hideDistrictView{
    self.districtViewController.view.frame = CGRectMake(0, 36, UI_SCREEN_WIDTH, 0);
    self.districtLabel.textColor = [UIColor blackColor];
    self.districtArrow.image = [UIImage imageNamed:@"museum_tab_arrow_down"];

    [self.districtViewController.view removeFromSuperview];
    [self.districtViewController removeFromParentViewController];
    self.districtViewController = nil;
    
    self.districtBg.frame = CGRectMake(0, 36, UI_SCREEN_WIDTH, 0);
    [self.districtBg removeFromSuperview];
    self.districtBg = nil;

}

-(void)showDistrictView{
    DistrictPullDownViewController *districtVC = [[DistrictPullDownViewController alloc] initWithCityID:self.cityID];
    [self addChildViewController:districtVC];
    [self.view addSubview:districtVC.view];
    self.districtViewController = districtVC;
    self.districtViewController.view.frame = CGRectMake(0, 36, UI_SCREEN_WIDTH, 0);
    self.districtViewController.selectedDistrict = _selectedDistrict;
    self.districtLabel.textColor = UIColorFromRGB(0xF95C6F);
    self.districtArrow.image = [UIImage imageNamed:@"museum_tab_arrow_up"];
    
    self.districtBg = [[UIView alloc]initWithFrame:CGRectMake(0, 36, UI_SCREEN_WIDTH, 0)];
    self.districtBg.backgroundColor = UIColorFromRGBA(0x808080 , .8);
    [self.districtBg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(districtPullDown)]];
    [self.view addSubview:self.districtBg];
   
    self.districtViewController.view.frame = CGRectMake(0, 36, UI_SCREEN_WIDTH, 350);
    self.districtBg.frame = CGRectMake(0, CGRectGetMaxY(self.districtViewController.view.frame), UI_SCREEN_WIDTH, CGRectGetHeight(self.view.frame)- CGRectGetHeight(self.districtViewController.view.frame) -36);

}


-(void)districtPullDown{
    if (self.orderViewController) {
        [self hideOrderView];
    }
    if (self.districtViewController) {
        [self hideDistrictView];
    } else {
        [self showDistrictView];
    }

}

-(void)orderPullDown{
    if (self.districtViewController) {
        [self hideDistrictView];
    }
    if (self.orderViewController) {
        [self hideOrderView];
    } else {
        [self showOrderView];
    }
    
}

-(void)locationDidChange:(NSNotification*)notification
{
    [[NetworkManager sharedInstance]cinemaListInCity:self.cityID movie:self.movieId inDistrict:(self.selectedDistrict?self.selectedDistrict.districtID:-1) page:1 location:self.currentLocation orderBy:self.selectedOrderType];
}

-(void)observeCinemaList:(NSNotification*)notification
{
    NSDictionary* userInfo = [notification userInfo];
    int64_t page = [userInfo[kUserInfoKeyPage] longLongValue];
    if(page > self.cinemaPage){
        self.cinemaPage = page;
        NSMutableArray *cinemas = [NSMutableArray array];
        [cinemas addObjectsFromArray:self.cinemas];
        [cinemas addObjectsFromArray:userInfo[kUserInfoKeyCinemas]];
        self.cinemas = cinemas;
    }else if(page == self.cinemaPage && page == 1){
        self.cinemas = userInfo[kUserInfoKeyCinemas];
    }
    [self.tableView reloadData];
    [self.tableView.header endRefreshing];
    
    if (self.selectedDistrict) {
        _districtLabel.text = self.selectedDistrict.districtName;
        
    }else{
        _districtLabel.text = @"城区";
    }
    _districtLabel.textColor = [UIColor blackColor];
    _districtArrow.image = [UIImage imageNamed:@"museum_tab_arrow_down"];
    
    CGFloat labelHeight = [_districtLabel.text sizeWithAttributes:@{NSFontAttributeName:_districtLabel.font}].height;
    CGFloat labelWidth = [_districtLabel.text sizeWithAttributes:@{NSFontAttributeName:_districtLabel.font}].width;
    CGFloat imageHeight = _districtArrow.image.size.height;
    CGFloat imageWidth = _districtArrow.image.size.width;
    
    _districtLabel.frame = CGRectMake((UI_SCREEN_WIDTH/2 - labelWidth -imageWidth - 5)/2, (36 - labelHeight)/2,labelWidth,labelHeight);
    _districtArrow.frame = CGRectMake(CGRectGetMaxX(_districtLabel.frame)+5, (36- imageHeight)/2, imageWidth, imageHeight);
    
    [self hideDistrictView];
    
    if (_selectedOrderType == 0) {
        _orderLabel.text = @"排序";
    }else if(_selectedOrderType == 1) {
        _orderLabel.text = @"离我最近";
    }else if(_selectedOrderType == 2){
        _orderLabel.text = @"评价最高";
    }
    _orderLabel.textColor = [UIColor blackColor];
    _orderArrow.image = [UIImage imageNamed:@"museum_tab_arrow_down"];
    
    labelHeight = [_orderLabel.text sizeWithAttributes:@{NSFontAttributeName:_orderLabel.font}].height;
    labelWidth = [_orderLabel.text sizeWithAttributes:@{NSFontAttributeName:_orderLabel.font}].width;
    imageHeight = _orderArrow.image.size.height;
    imageWidth = _orderArrow.image.size.width;
    
    _orderLabel.frame = CGRectMake((UI_SCREEN_WIDTH/2 - labelWidth -imageWidth - 5)/2, (36 - labelHeight)/2,labelWidth,labelHeight);
    _orderArrow.frame = CGRectMake(CGRectGetMaxX(_orderLabel.frame)+5, (36- imageHeight)/2, imageWidth, imageHeight);
    
    [self hideOrderView];
}

-(NSArray*)orderCinemas:(NSArray*)cinemas{
    NSArray* array;
    switch (self.selectedOrderType) {
        case CinemaOrderTypeDefault:
            array = [cinemas sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
                return ((CinemaMeta*)obj2).cinemaID - ((CinemaMeta*)obj1).cinemaID;
            }];
            break;
        case CinemaOrderTypeDistance:
            array = [cinemas sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
                return ((CinemaMeta*)obj2).distance - ((CinemaMeta*)obj1).distance;
            }];
            break;
        case CinemaOrderTypeRate:
            array = [cinemas sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
                return ((CinemaMeta*)obj1).rate - ((CinemaMeta*)obj2).rate;
            }];
            break;
        default:
            array = cinemas;
            break;
    }
    return array;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CinemaMeta* cinema = self.cinemas[indexPath.row];
    SessionViewController* svc = [[SessionViewController alloc]initWithCinemaMeta:cinema];
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - refresh
- (void) refreshCinemas
{
    NetworkManager *networkManager = [NetworkManager sharedInstance];
    if (self.selectedDistrict) {
        [networkManager cinemaListInCity:self.cityID movie:self.movieId inDistrict:self.selectedDistrict.districtID page:1 location:self.currentLocation orderBy:self.selectedOrderType];
    }else{
        [networkManager cinemaListInCity:self.cityID movie:self.movieId inDistrict:-1 page:1 location:self.currentLocation orderBy:self.selectedOrderType];
    }
    self.cinemaPage = 1;
}

#pragma mark - load more
- (void) loadMoreCinemas
{
    NetworkManager *networkManager = [NetworkManager sharedInstance];
    if (self.selectedDistrict) {
        [networkManager cinemaListInCity:self.cityID movie:self.movieId inDistrict:self.selectedDistrict.districtID page:self.cinemaPage+1 location:self.currentLocation orderBy:self.selectedOrderType];
    }else{
        [networkManager cinemaListInCity:self.cityID movie:self.movieId inDistrict:-1 page:self.cinemaPage+1 location:self.currentLocation orderBy:self.selectedOrderType];
    }
    [self.tableView.footer endRefreshing];
}

@end
