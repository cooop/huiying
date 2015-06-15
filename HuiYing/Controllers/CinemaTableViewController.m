//
//  CinemaTableViewController.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/25.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CinemaTableViewController.h"
#import "DistrictPullDownViewController.h"
#import "OrderPullDownViewController.h"
#import "Constraits.h"
#import "CinemaMeta.h"

@interface CinemaTableViewController ()
@property (nonatomic, strong) UIView* districtView;
@property (nonatomic, strong) UILabel* districtLabel;
@property (nonatomic, strong) UIImageView* districtArrow;
@property (nonatomic, strong) UIView* orderView;
@property (nonatomic, strong) UILabel* orderLabel;
@property (nonatomic, strong) UIImageView* orderArrow;
@property (nonatomic, strong) DistrictPullDownViewController* districtViewController;
@property (nonatomic, strong) DistrictMeta* selectedDistrict;
@property (nonatomic, strong) OrderPullDownViewController* orderViewController;
@property (nonatomic, assign) CinemaOrderType selectedOrderType;
@end

@implementation CinemaTableViewController

-(instancetype)initWithCityId:(int64_t)cityId{
    if (self = [super init]) {
        _cityID = cityId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT);
    self.tableView.rowHeight = 80;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.edgesForExtendedLayout= UIRectEdgeNone;
    self.tableView.sectionHeaderHeight = 36;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
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
    
    self.tableView.tableHeaderView = headerView;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observeCinemaList:) name:kCinemaListInDistrictSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeCinemaList:) name:kCinemaListInCitySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeCinemaOrderChange) name:kCinemaOrderTypeChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    titleLabel.frame = CGRectMake(11, 12, labelWidth, labelHeight);
    
    UILabel *locationLabel = [[UILabel alloc]init];
    locationLabel.text = cinema.address;
    locationLabel.font = [UIFont systemFontOfSize:13];
    locationLabel.textColor = UIColorFromRGB(0x6E6E6E);
    labelHeight = [locationLabel.text sizeWithAttributes:@{NSFontAttributeName:locationLabel.font}].height;
    labelWidth = [locationLabel.text sizeWithAttributes:@{NSFontAttributeName:locationLabel.font}].width;
    locationLabel.frame = CGRectMake(11, 38, labelWidth, labelHeight);
    
    UILabel *comingLabel = [[UILabel alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"HH:mm";
    comingLabel.text = [NSString stringWithFormat:@"最近场次%@",[formatter stringFromDate:cinema.coming]];
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
    ratingLabel.text = [NSString stringWithFormat:@"%.1f",(float)cinema.rate/10];
    
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


-(void)districtPullDown{
    if (self.orderViewController) {
       
        self.orderViewController.view.frame = CGRectMake(0, 36, UI_SCREEN_WIDTH, 0);
        self.orderLabel.textColor = [UIColor blackColor];
        self.orderArrow.image = [UIImage imageNamed:@"museum_tab_arrow_down"];
        
        [self.orderViewController.view removeFromSuperview];
        [self.orderViewController removeFromParentViewController];
        self.orderViewController = nil;
        
    }
    if (self.districtViewController) {
        [UIView animateWithDuration:0.25f animations:^{
//            CGRect frame = self.districtViewController.view.frame;
//            frame.origin.y -= self.districtViewController.view.frame.size.height;
            self.districtViewController.view.frame = CGRectMake(0, 36, UI_SCREEN_WIDTH, 0);
            self.districtLabel.textColor = [UIColor blackColor];
            self.districtArrow.image = [UIImage imageNamed:@"museum_tab_arrow_down"];
        } completion:^(BOOL finished){
            [self.districtViewController.view removeFromSuperview];
            [self.districtViewController removeFromParentViewController];
            self.districtViewController = nil;
        }];
    } else {
        DistrictPullDownViewController *districtVC = [[DistrictPullDownViewController alloc] initWithCityID:self.cityID];
        [self addChildViewController:districtVC];
        [self.view addSubview:districtVC.view];
        self.districtViewController = districtVC;
        self.districtViewController.view.frame = CGRectMake(0, 36, UI_SCREEN_WIDTH, 0);
        self.districtViewController.selectedDistrict = _selectedDistrict;
        self.districtLabel.textColor = UIColorFromRGB(0xF95C6F);
        self.districtArrow.image = [UIImage imageNamed:@"museum_tab_arrow_up"];
        [UIView animateWithDuration:0.25f animations:^(void) {
            self.districtViewController.view.frame = CGRectMake(0, 36, UI_SCREEN_WIDTH, 350);
        } completion:^(BOOL finished) {
            
        }];
    }

}

-(void)orderPullDown{
    if (self.districtViewController) {
       
        self.districtViewController.view.frame = CGRectMake(0, 36, UI_SCREEN_WIDTH, 0);
        self.districtLabel.textColor = [UIColor blackColor];
        self.districtArrow.image = [UIImage imageNamed:@"museum_tab_arrow_down"];
    
        [self.districtViewController.view removeFromSuperview];
        [self.districtViewController removeFromParentViewController];
        self.districtViewController = nil;
       
    }
    
    if (self.orderViewController) {
        [UIView animateWithDuration:0.25f animations:^{
            //            CGRect frame = self.districtViewController.view.frame;
            //            frame.origin.y -= self.districtViewController.view.frame.size.height;
            self.orderViewController.view.frame = CGRectMake(0, 36, UI_SCREEN_WIDTH, 0);
            self.orderLabel.textColor = [UIColor blackColor];
            self.orderArrow.image = [UIImage imageNamed:@"museum_tab_arrow_down"];
        } completion:^(BOOL finished){
            [self.orderViewController.view removeFromSuperview];
            [self.orderViewController removeFromParentViewController];
            self.orderViewController = nil;
        }];
    } else {
        OrderPullDownViewController *orderVC = [[OrderPullDownViewController alloc] init];
        [self addChildViewController:orderVC];
        [self.view addSubview:orderVC.view];
        self.orderViewController = orderVC;
        self.orderViewController.view.frame = CGRectMake(0, 36, UI_SCREEN_WIDTH, 0);
        self.orderViewController.selectedOrderType = _selectedOrderType;
        self.orderLabel.textColor = UIColorFromRGB(0xF95C6F);
        self.orderArrow.image = [UIImage imageNamed:@"museum_tab_arrow_up"];
        [UIView animateWithDuration:0.25f animations:^(void) {
            self.orderViewController.view.frame = CGRectMake(0, 36, UI_SCREEN_WIDTH, 170);
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

-(void)observeCinemaList:(NSNotification*)notification
{
    NSDictionary* userInfo = [notification userInfo];
    self.cinemas = [self orderCinemas: userInfo[kUserInfoKeyCinemas]];
    [self.tableView reloadData];
    if (self.districtViewController.selectedDistrict) {
        _districtLabel.text = self.districtViewController.selectedDistrict.districtName;
        _selectedDistrict = self.districtViewController.selectedDistrict;
    }else{
        _districtLabel.text = @"城区";
        _selectedDistrict = nil;
    }
    _districtLabel.textColor = [UIColor blackColor];
    _districtArrow.image = [UIImage imageNamed:@"museum_tab_arrow_down"];
    
    CGFloat labelHeight = [_districtLabel.text sizeWithAttributes:@{NSFontAttributeName:_districtLabel.font}].height;
    CGFloat labelWidth = [_districtLabel.text sizeWithAttributes:@{NSFontAttributeName:_districtLabel.font}].width;
    CGFloat imageHeight = _districtArrow.image.size.height;
    CGFloat imageWidth = _districtArrow.image.size.width;
    
    _districtLabel.frame = CGRectMake((UI_SCREEN_WIDTH/2 - labelWidth -imageWidth - 5)/2, (36 - labelHeight)/2,labelWidth,labelHeight);
    _districtArrow.frame = CGRectMake(CGRectGetMaxX(_districtLabel.frame)+5, (36- imageHeight)/2, imageWidth, imageHeight);
    
    [UIView animateWithDuration:0.25f animations:^{
        //            CGRect frame = self.districtViewController.view.frame;
        //            frame.origin.y -= self.districtViewController.view.frame.size.height;
        self.districtViewController.view.frame = CGRectMake(0, 36, UI_SCREEN_WIDTH, 0);
    } completion:^(BOOL finished){
        [self.districtViewController.view removeFromSuperview];
        [self.districtViewController removeFromParentViewController];
        self.districtViewController = nil;
    }];
    
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

-(void)observeCinemaOrderChange{
    _selectedOrderType = self.orderViewController.selectedOrderType;
    self.cinemas = [self orderCinemas: self.cinemas];
    [self.tableView reloadData];
    if (_selectedOrderType == 0) {
        _orderLabel.text = @"排序";
    }else if(_selectedOrderType == 1) {
        _orderLabel.text = @"离我最近";
    }else if(_selectedOrderType == 2){
        _orderLabel.text = @"评价最高";
    }
    _orderLabel.textColor = [UIColor blackColor];
    _orderArrow.image = [UIImage imageNamed:@"museum_tab_arrow_down"];
    
    CGFloat labelHeight = [_orderLabel.text sizeWithAttributes:@{NSFontAttributeName:_orderLabel.font}].height;
    CGFloat labelWidth = [_orderLabel.text sizeWithAttributes:@{NSFontAttributeName:_orderLabel.font}].width;
    CGFloat imageHeight = _orderArrow.image.size.height;
    CGFloat imageWidth = _orderArrow.image.size.width;
    
    _orderLabel.frame = CGRectMake((UI_SCREEN_WIDTH/2 - labelWidth -imageWidth - 5)/2, (36 - labelHeight)/2,labelWidth,labelHeight);
    _orderArrow.frame = CGRectMake(CGRectGetMaxX(_orderLabel.frame)+5, (36- imageHeight)/2, imageWidth, imageHeight);
    
    [UIView animateWithDuration:0.25f animations:^{
        //            CGRect frame = self.districtViewController.view.frame;
        //            frame.origin.y -= self.districtViewController.view.frame.size.height;
        self.orderViewController.view.frame = CGRectMake(0, 36, UI_SCREEN_WIDTH, 0);
    } completion:^(BOOL finished){
        [self.orderViewController.view removeFromSuperview];
        [self.orderViewController removeFromParentViewController];
        self.orderViewController = nil;
    }];

}

@end
