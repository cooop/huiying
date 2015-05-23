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


@interface CityListViewController ()
@property (nonatomic, strong) CLLocationManager *locationManager;//定义Manager
@end

@implementation CityListViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.arrayHotCity = [NSMutableArray arrayWithObjects:@"上海",@"北京",@"广州",@"深圳",@"武汉",@"天津",@"西安",@"南京",@"杭州",@"成都",@"重庆", nil];
        self.keys = [NSMutableArray array];
        self.arrayCitys = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getCityData];
    
    
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
//    _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = UIColorFromRGB(0x008BFF);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    // 判断定位操作是否被允许
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _locationManager = nil;
}

#pragma mark - 获取城市数据
-(void)getCityData
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict"
                                                   ofType:@"plist"];
    self.cities = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    [self.keys addObjectsFromArray:[[self.cities allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    //添加热门城市
    NSString *strHot = @"热门";
    NSString *local = @"定位";
    [self.keys insertObject:local atIndex:0];
    [self.keys insertObject:strHot atIndex:1];
    [self.cities setObject:@[@"正在定位..."] forKey:local];
    [self.cities setObject:_arrayHotCity forKey:strHot];
}

#pragma mark - tableView
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.textLabel setTextColor:UIColorFromRGB(0x333333)];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
    }
    cell.textLabel.text = [[_cities objectForKey:key] objectAtIndex:indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [ApplicationSettings sharedInstance].city = self.cities[self.keys[indexPath.section]][indexPath.row];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -location
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];
    [self getCity:currentLocation];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backToMovieListView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)getCity:(CLLocation*)location{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil &&[placemarks count] > 0){
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *cityStr = placemark.locality;
            cityStr = cityStr?cityStr:placemark.administrativeArea;
            cityStr = [self formatCityName:cityStr];
            [self.cities setObject:@[cityStr] forKey:self.keys[0]];
            [self.tableView reloadData];
        }else if (error == nil &&[placemarks count] == 0){
            NSLog(@"No results were returned.");
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"定位失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            //TODO: 加入重试按钮
        }else if (error != nil){
            NSLog(@"An error occurred = %@", error);
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"定位失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            //TODO: 加入重试按钮
        }
    }];
}

-(NSString*)formatCityName:(NSString*)cityStr{
    for(NSString* key in self.keys){
        for(NSString* city in self.cities[key]){
            if ([cityStr hasPrefix:city]) {
                return city;
            }
        }
    }
    return cityStr;
}

@end
