//
//  CinemaViewController.m
//  HuiYing
//
//  Created by 金鑫 on 15/7/19.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CinemaViewController.h"
#import "CinemaDetailMeta.h"
#import "NetworkManager.h"
#import "MyPoint.h"

@interface CinemaViewController ()<MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) MKMapView* mapView;
@property (nonatomic, strong) UILabel * naviTitle;
@property (nonatomic) int64_t cinemaID;
@property (nonatomic, strong) CinemaDetailMeta* cinema;
@property (nonatomic, strong) CLLocationManager *locationManager;//定义Manager
@property (nonatomic, strong) UIImageView* star1;
@property (nonatomic, strong) UIImageView* star2;
@property (nonatomic, strong) UIImageView* star3;
@property (nonatomic, strong) UIImageView* star4;
@property (nonatomic, strong) UIImageView* star5;
@property (nonatomic, strong) UILabel* ratingLabel;
@property (nonatomic, strong) UIView* ratingView;
@property (nonatomic, strong) UITableView* tableView;

@end

@implementation CinemaViewController

- (id)initWithCinemaID:(int64_t)cinemaID{
    if(self = [super init]){
        _cinemaID = cinemaID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _mapView =[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 200)];
    [_mapView setMapType:MKMapTypeStandard];
    
    [self.mapView setShowsUserLocation:YES];

    [self.view addSubview:self.mapView];
    
    [self drawNavigationBar];
    [self drawRating];
    [self drawTableView];
}

- (void)drawNavigationBar{
    //navi bar
    self.navigationController.navigationBar.barTintColor = UI_COLOR_PINK;
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"影院介绍";
    titleLabel.textColor = UIColorFromRGB(0xFFFFFF);
    
    self.naviTitle = titleLabel;
    
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

- (void)drawRating{
    _ratingView = [[UIView alloc]initWithFrame:CGRectMake(10, 200, UI_SCREEN_WIDTH-20, 45)];
    [self.view addSubview:self.ratingView];
    _ratingLabel = [[UILabel alloc]init];
    _star1 = [[UIImageView alloc]init];
    _star2 = [[UIImageView alloc]init];
    _star3 = [[UIImageView alloc]init];
    _star4 = [[UIImageView alloc]init];
    _star5 = [[UIImageView alloc]init];
    UIImage * starImage = [UIImage imageNamed:@"intro_movie_ico_star3"];
    _star1.image = starImage;
    _star2.image = starImage;
    _star3.image = starImage;
    _star4.image = starImage;
    _star5.image = starImage;
    _star1.frame = CGRectMake(10, (45-starImage.size.height)/2, starImage.size.width, starImage.size.height);
    _star2.frame = CGRectMake(CGRectGetMaxX(_star1.frame)+4, (45-starImage.size.height)/2, starImage.size.width, starImage.size.height);
    _star3.frame = CGRectMake(CGRectGetMaxX(_star2.frame)+4, (45-starImage.size.height)/2, starImage.size.width, starImage.size.height);
    _star4.frame = CGRectMake(CGRectGetMaxX(_star3.frame)+4, (45-starImage.size.height)/2, starImage.size.width, starImage.size.height);
    _star5.frame = CGRectMake(CGRectGetMaxX(_star4.frame)+4, (45-starImage.size.height)/2, starImage.size.width, starImage.size.height);
    
    _ratingLabel.backgroundColor = [UIColor clearColor];
    _ratingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:18];
    _ratingLabel.textColor = UIColorFromRGB(0xFF7833);
    _ratingLabel.text = @"0.0";
    CGSize size = [_ratingLabel.text sizeWithAttributes:@{NSFontAttributeName:_ratingLabel.font}];
    _ratingLabel.frame = CGRectMake(CGRectGetMaxX(_star5.frame)+10, (45- size.height)/2 ,size.width, size.height);
    
    [self.ratingView addSubview:self.star1];
    [self.ratingView addSubview:self.star2];
    [self.ratingView addSubview:self.star3];
    [self.ratingView addSubview:self.star4];
    [self.ratingView addSubview:self.star5];
    
    CGFloat lineHeight = 1.0f/[UIScreen mainScreen].scale;
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 45- lineHeight, UI_SCREEN_WIDTH-20, lineHeight)];
    line.backgroundColor = UIColorFromRGB(0xDCDCDC);

    [self.ratingView addSubview:line];
    [self.ratingView addSubview:self.ratingLabel];
}

-(void)drawTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 245, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_STATUS_BAR_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-245)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cinemaDetailListSuccess:) name:kCinemaDetailListSuccessNotification object:nil];
    [[NetworkManager sharedInstance]cinemaListDetailWithID:self.cinemaID];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:kCinemaDetailListSuccessNotification];
}

- (void)cinemaDetailListSuccess:(NSNotification*)notification{
    NSDictionary* userInfo = [notification userInfo];
    self.cinema = userInfo[kUserInfoKeyCinemaDetail];
    
    self.naviTitle.text= self.cinema.cinemaName;
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:self.cinema.latitude longitude:self.cinema.longitude];
    CLLocationCoordinate2D center = [loc coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, 250, 250);
    NSString *titile = self.cinema.cinemaName;
    MyPoint *myPoint = [[MyPoint alloc] initWithCoordinate:center andTitle:titile];
    [self.mapView addAnnotation:myPoint];
    [self.mapView setRegion:region animated:YES];
    
    self.ratingLabel.text = [NSString stringWithFormat:@"%.1f", self.cinema.rate];
    CGSize size = [self.ratingLabel.text sizeWithAttributes:@{NSFontAttributeName:self.ratingLabel.font}];
    self.ratingLabel.frame = CGRectMake(CGRectGetMaxX(self.star5.frame)+10, (45- size.height)/2 ,size.width, size.height);
    
    int rate = (int)(self.cinema.rate + 0.5);
    if (rate < 1) {
    }else if(rate >= 1 & rate < 2){
        _star1.image = [UIImage imageNamed:@"intro_movie_ico_star2"];
    }else{
        _star1.image = [UIImage imageNamed:@"intro_movie_ico_star1"];
    }
    
    if (rate < 3) {
    }else if(rate >= 3 & rate < 4){
        _star2.image = [UIImage imageNamed:@"intro_movie_ico_star2"];
    }else{
        _star2.image = [UIImage imageNamed:@"intro_movie_ico_star1"];
    }
    
    if (rate < 5) {
    }else if(rate >= 5 & rate < 6){
        _star3.image = [UIImage imageNamed:@"intro_movie_ico_star2"];
    }else{
        _star3.image = [UIImage imageNamed:@"intro_movie_ico_star1"];
    }
    
    if (rate < 7) {
    }else if(rate >= 7 & rate < 8){
        _star4.image = [UIImage imageNamed:@"intro_movie_ico_star2"];
    }else{
        _star4.image = [UIImage imageNamed:@"intro_movie_ico_star1"];
    }
    
    if (rate < 9) {
    }else if(rate >= 9 & rate < 10){
        _star5.image = [UIImage imageNamed:@"intro_movie_ico_star2"];
    }else{
        _star5.image = [UIImage imageNamed:@"intro_movie_ico_star1"];
    }

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backToParentView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self introductionHeight:indexPath];
}

-(CGFloat)introductionHeight:(NSIndexPath*)indexPath{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;// 字体的行间距

    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSForegroundColorAttributeName:UIColorFromRGB(0x6E6E6E),
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    NSString* labelText = nil;
    
    if (indexPath.row == 0) {
        labelText = self.cinema.address;
    }else if(indexPath.row == 1){
        labelText = self.cinema.phone;
    }else{
        labelText = self.cinema.service;
    }
    
    if (labelText == nil) {
        labelText = @"";
    }
    
    NSAttributedString* attributedText = [[NSAttributedString alloc] initWithString:labelText attributes:attributes];
    CGRect textRect = [attributedText boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 55, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGFloat introductionHeight = 30 + textRect.size.height;
    if (introductionHeight < 45) {
        introductionHeight = 45;
    }
    return introductionHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *const identifier = @"CinemaDetailListTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UIImageView *imageView = [[UIImageView alloc]init];
    UILabel* label = [[UILabel alloc]init];
    
    NSString* labelText = nil;
    if (indexPath.row == 0) {
        imageView.image = [UIImage imageNamed:@"intro_museum_ico_place"];
        labelText = self.cinema.address;
    }else if(indexPath.row == 1){
        imageView.image = [UIImage imageNamed:@"intro_museum_ico_phone"];
        labelText = self.cinema.phone;
    }else{
        imageView.image = [UIImage imageNamed:@"intro_museum_ico_park"];
        labelText = self.cinema.service;
    }
    
    if (labelText == nil) {
        labelText = @"";
    }
    
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSForegroundColorAttributeName:UIColorFromRGB(0x6E6E6E),
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    label.attributedText = [[NSAttributedString alloc] initWithString:labelText attributes:attributes];
    
    imageView.frame = CGRectMake(14, (45-imageView.image.size.height)/2, imageView.image.size.width, imageView.image.size.height);
    label.frame = CGRectMake(CGRectGetMaxX(imageView.frame)+10, 14, UI_SCREEN_WIDTH - 55, [self introductionHeight:indexPath]-28);
    [cell addSubview:imageView];
    [cell addSubview:label];
    
    return cell;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

@end
