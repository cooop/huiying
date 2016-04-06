//
//  DistrictPullDownViewController.m
//  
//
//  Created by Jin Xin on 15/5/28.
//  Copyright (c) 2015年 huiying. All rights reserved.
//

#import "DistrictPullDownViewController.h"
#import "Constraits.h"
#import "NetworkManager.h"
#import "DistrictMeta.h"
#import "CinemaListViewController.h"

@interface DistrictPullDownViewController ()
@property (nonatomic,assign) NSInteger selectedIndex;
@end

@implementation DistrictPullDownViewController

-(instancetype)initWithCityID:(int64_t)cityId oldCityID:(int64_t)oldCityID{
    if(self = [super init]){
        _cityId = cityId;
        _oldCityId = oldCityID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.view.frame = CGRectMake(0, UI_STATUS_BAR_HEIGHT+UI_NAVIGATION_BAR_HEIGHT+36, UI_SCREEN_WIDTH, 350);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 350)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(districtListInCitySuccess:) name:kDistrictListInCitySuccessNotification object:nil];
    if (self.oldCityId == self.cityId && self.districts && [self.districts count]) {
        [self findSelectedIndex];
        [self.tableView reloadData];
    }else{
        [[NetworkManager sharedInstance] districtListInCity:self.cityId];
    }
}

- (void)districtListInCitySuccess:(NSNotification*)notification{
    NSDictionary* userInfo = [notification userInfo];
    int64_t cityId = [userInfo[kUserInfoKeyCityID] longLongValue];
    if (self.cityId == cityId) {
        self.districts = userInfo[kUserInfoKeyDistricts];
    }
    
    [self findSelectedIndex];
   
    [self.tableView reloadData];
}

-(void)findSelectedIndex{
    for (DistrictMeta* district in  self.districts){
        if (self.selectedDistrict.districtID == district.districtID) {
            self.selectedIndex = [self.districts indexOfObject:district] + 1;
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0 +[@"全部" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].height;;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *const identifier = @"DistrictPullDownTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }

    UILabel* label = [[UILabel alloc]init];
    if (indexPath.row == 0) {
        label.text = @"全部";
    }else{
        label.text = ((DistrictMeta*)self.districts[indexPath.row - 1]).districtName;
    }
    label.font = [UIFont systemFontOfSize:15];
    
    CGFloat height = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}].height;
    CGFloat width = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}].width;

    label.frame = CGRectMake((UI_SCREEN_WIDTH-width)/2, 15, width, height);
    if (self.selectedIndex == indexPath.row) {
        label.textColor = UIColorFromRGB(0xF95C6F);
    }
    
    [cell addSubview:label];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CLLocation* location = nil;
    CinemaOrderType order = CinemaOrderTypeDefault;
    int64_t movie = -1;
    if ([self.parentViewController isKindOfClass:[CinemaListViewController class]]) {
        location = ((CinemaListViewController*)self.parentViewController).currentLocation;
        order = ((CinemaListViewController*)self.parentViewController).selectedOrderType;
        movie = ((CinemaListViewController*)self.parentViewController).movieId;
    }
    
    self.selectedIndex = indexPath.row;
    if (indexPath.row == 0) {
        self.selectedDistrict = nil;
        [[NetworkManager sharedInstance] cinemaListInCity:self.cityId movie:movie inDistrict:-1 page:1 location:location orderBy:order];
    }else{
        self.selectedDistrict = self.districts[indexPath.row -1];
        [[NetworkManager sharedInstance] cinemaListInCity:self.cityId movie:movie inDistrict:self.selectedDistrict.districtID page:1 location:location orderBy:order];
    }
    
    if([self.parentViewController isKindOfClass:[CinemaListViewController class]]){
        ((CinemaListViewController*)self.parentViewController).cinemaPage = 1;
        ((CinemaListViewController*)self.parentViewController).selectedDistrict = self.selectedDistrict;
        ((CinemaListViewController*)self.parentViewController).oldCityID = self.cityId;
        if (self.districts && [self.districts count]) {
            ((CinemaListViewController*)self.parentViewController).districts = self.districts;
        }
    }
    
    [tableView reloadData];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.districts.count + 1;
}

@end
