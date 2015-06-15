//
//  OrderPullDownViewController.m
//  HuiYing
//
//  Created by Jin Xin on 15/6/2.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "OrderPullDownViewController.h"
#import "Constraits.h"

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
    [[NSNotificationCenter defaultCenter] postNotificationName:kCinemaOrderTypeChangeNotification object:nil];
    [tableView reloadData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


@end
