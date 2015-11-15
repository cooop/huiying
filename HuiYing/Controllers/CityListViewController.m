//
//  CityListViewController.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/20.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CityListViewController.h"
#import "ApplicationSettings.h"
#import "Constraits.h"
#import "CityMeta.h"
#import "NetworkManager.h"
#import "LocationManager.h"
#import "MobClick.h"


@interface CityListViewController ()
@property (nonatomic, assign) NSInteger timestamp;
@property (nonatomic, strong) NSArray* cityList;
@end

@implementation CityListViewController

-(id)init{
    if(self = [super init]){
        _cities = [[LocationManager sharedInstance] cities];
        _keys = [[LocationManager sharedInstance] keys];
    }
    return self;
}

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.text = @"城市切换";
    
    CGFloat titleWidth = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:titleLabel.font}].width;
    CGFloat titleHeight = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:titleLabel.font}].height;
    
    titleLabel.frame = CGRectMake(0, 0, titleWidth, titleHeight);
    self.navigationItem.titleView = titleLabel;
    
    
    UIImage * image = [UIImage imageNamed:@"nav_close"];
    UIImageView * view = [[UIImageView alloc]initWithImage:image];
    view.frame = CGRectMake(10,UI_STATUS_BAR_HEIGHT+UI_NAVIGATION_BAR_HEIGHT/2-image.size.height/2, image.size.width, image.size.height);
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToMovieListView)]];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = UIColorFromRGB(0x008BFF);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [[NetworkManager sharedInstance]cityVersion];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locateSuccess:) name:kLocateSuccessNotification object:nil];
    [MobClick beginLogPageView:UMengCityList];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLocateSuccessNotification object:nil];
    [MobClick endLogPageView:UMengCityList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate & datesource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 14)];
    bgView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 250, 14)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = UIColorFromRGB(0x333333);
    titleLabel.font = [UIFont systemFontOfSize:14];
    
    NSString *key = [_keys objectAtIndex:section];
    if ([key rangeOfString:@"定位"].location != NSNotFound) {
        titleLabel.text = @"GPS定位城市";
    }
    else if([key rangeOfString:@"热门"].location != NSNotFound) {
        titleLabel.text = @"热门城市";
    }
    else{
        titleLabel.text = key;
    }
    
    [bgView addSubview:titleLabel];
    
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keys;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *key = [_keys objectAtIndex:section];
    NSArray *citySection = [_cities objectForKey:key];
    return [citySection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NSString *key = [_keys objectAtIndex:indexPath.section];
    NSArray* citiesInSection = [_cities objectForKey:key];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.textLabel setTextColor:UIColorFromRGB(0x333333)];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
    }
    cell.textLabel.text = ((CityMeta*)[citiesInSection objectAtIndex:indexPath.row]).cityName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CityMeta * city = self.cities[self.keys[indexPath.section]][indexPath.row];
    if (city.cityID >= 0) {
        [ApplicationSettings sharedInstance].cityID = city.cityID;
        [ApplicationSettings sharedInstance].cityName = city.cityName;
        [[ApplicationSettings sharedInstance] saveSettings];
        [LocationManager sharedInstance].alertShow = YES;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)locateSuccess:(NSNotification*)notification{
    self.keys = [[LocationManager sharedInstance] keys];
    self.cities = [[LocationManager sharedInstance] cities];
    [self.tableView reloadData];
}


-(void)backToMovieListView{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
