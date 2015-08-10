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


@interface CityListViewController ()
@property (nonatomic, strong) CLLocationManager *locationManager;//定义Manager
@property (nonatomic, assign) NSInteger timestamp;
@property (nonatomic, strong) NSArray* cityList;
@end

@implementation CityListViewController

-(id)init{
    if(self = [super init]){
        _cities = [NSMutableDictionary dictionary];
        _keys = [NSMutableArray array];
    }
    return self;
}

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _timestamp = [[ApplicationSettings sharedInstance] timestamp];
    _cityList = [[ApplicationSettings sharedInstance] cityList];
    [self parseCityList:self.cityList];
    
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
    [[NetworkManager sharedInstance]cityVersion];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(versionGet:) name:kCityVersionSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityListSuccess:) name:kCityListSuccessNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCityVersionSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCityListSuccessNotification object:nil];
    _locationManager = nil;
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
    [ApplicationSettings sharedInstance].cityID = city.cityID;
    [ApplicationSettings sharedInstance].cityName = city.cityName;
    [[ApplicationSettings sharedInstance] saveSettings];
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

#pragma mark - notification handler
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
    [self.tableView reloadData];
}

#pragma mark - private methods
-(void)getCityData
{
    NSString *local = @"定位";
    if (![self.keys containsObject:local]) {
        [self.keys insertObject:local atIndex:0];
    }
    CityMeta* cityMeta = [[CityMeta alloc] init];
    cityMeta.cityName =@"正在定位...";
    cityMeta.cityID = -100;
    [self.cities setValue:@[cityMeta] forKey:local];
}


-(void)parseCityList:(NSArray*)cityList{
    
    for(NSDictionary* cityDict in cityList){
        NSEnumerator* enumerator = [cityDict keyEnumerator];
        NSString* cityKey = nil;
        if ((cityKey = enumerator.nextObject) != nil) {
            if ([cityKey isEqualToString:@"hot"]) {
                [self.keys addObject:@"热门"];
                cityKey = @"热门";
            }else{
                [self.keys addObject:cityKey];
            }
            NSMutableArray * cityArray = [NSMutableArray array];
            for(NSDictionary* city in cityDict[cityKey]){
                CityMeta* cityMeta =[[CityMeta alloc]initWithDict:city];
                [cityArray addObject:cityMeta];
            }
            [self.cities setValue:cityArray forKey:cityKey];
        }
    }
    [self getCityData];
}

-(void)backToMovieListView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getCity:(CLLocation*)location{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil &&[placemarks count] > 0){
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *cityStr = placemark.locality;
            cityStr = cityStr?cityStr:placemark.administrativeArea;
            [self.cities setObject:[self formatCityName:cityStr] forKey:self.keys[0]];
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

-(CityMeta*)formatCityName:(NSString*)cityStr{
    for(NSString* key in self.keys){
        for(CityMeta* city in self.cities[key]){
            if ([cityStr hasPrefix:city.cityName]) {
                return city;
            }
        }
    }
    return nil;
}

@end
