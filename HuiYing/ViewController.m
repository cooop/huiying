//
//  ViewController.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/6.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "ViewController.h"
#import "NetworkManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //For TEST
    NetworkManager *networkManager = [NetworkManager sharedInstance];
    [networkManager cityList];
    [networkManager districtListInCity:110100];
    [networkManager cinemaList];
    [networkManager cinemaListInCity:110100];
    [networkManager cinemaListInCity:110100 inDistrict:6911];
    [networkManager movieList];
    [networkManager movieListDetailWithID:1];
    [networkManager sessionOfMovie:1 inCinema:1];
    [networkManager ticketPriceOfSession:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
