//
//  OrderPullDownViewController.m
//  HuiYing
//
//  Created by Jin Xin on 15/6/2.
//  Copyright (c) 2015年 huiying. All rights reserved.
//

#import "OrderPullDownViewController.h"
#import "CinemaListViewController.h"
#import "Constraits.h"
#import "NetworkManager.h"

@interface OrderPullDownViewController ()

@end

@implementation OrderPullDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 170)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0 +[@"默认" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].height;;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *const identifier = @"DistrictPullDownTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    UILabel* label = [[UILabel alloc]init];
    if (indexPath.row == 0) {
        label.text = @"默认";
    }else if(indexPath.row == 1){
        label.text = @"离我最近";
    }else if(indexPath.row == 2){
        label.text = @"评价最高";
    }
    label.font = [UIFont systemFontOfSize:15];
    
    CGFloat height = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}].height;
    CGFloat width = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}].width;
    
    label.frame = CGRectMake((UI_SCREEN_WIDTH-width)/2, 15, width, height);
    if (self.selectedOrderType == indexPath.row) {
        label.textColor = UIColorFromRGB(0xF95C6F);
    }
    
    [cell addSubview:label];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedOrderType = (int)indexPath.row;
    
    CLLocation* location = nil;
    int64_t movie = -1;
    int64_t city = -1;
    int64_t district = -1;
    if ([self.parentViewController isKindOfClass:[CinemaListViewController class]]) {
        location = ((CinemaListViewController*)self.parentViewController).currentLocation;
        district = ((CinemaListViewController*)self.parentViewController).selectedDistrict?((CinemaListViewController*)self.parentViewController).selectedDistrict.districtID:-1;
        movie = ((CinemaListViewController*)self.parentViewController).movieId;
        city = ((CinemaListViewController*)self.parentViewController).cityID;
    }
    
    
    [[NetworkManager sharedInstance] cinemaListInCity:city movie:movie inDistrict:district page:1 location:location orderBy:self.selectedOrderType];
    
    
    if([self.parentViewController isKindOfClass:[CinemaListViewController class]]){
        ((CinemaListViewController*)self.parentViewController).cinemaPage = 1;
        ((CinemaListViewController*)self.parentViewController).selectedOrderType = self.selectedOrderType;
    }
    
    [tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


@end
