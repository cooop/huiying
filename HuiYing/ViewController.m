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
    NetworkManager *networkManager = [[NetworkManager alloc]init];
    [networkManager cityList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
