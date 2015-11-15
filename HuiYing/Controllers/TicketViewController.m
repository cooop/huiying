//
//  TicketViewController.m
//  HuiYing
//
//  Created by 金鑫 on 15/7/27.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "TicketViewController.h"
#import "SessionMeta.h"
#import "Constraits.h"
#import "NetworkManager.h"
#import "UIImageView+AFNetworking.h"
#import "TicketMeta.h"
#import "URLManager.h"
#import "BuyTicketViewController.h"
#import "MobClick.h"

@interface TicketViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) SessionMeta* session;
@property (nonatomic, strong) NSArray* tickets;
@property (nonatomic, strong) UILabel* naviTitle;
@property (nonatomic, strong) UITableView* tableView;
@end

@implementation TicketViewController

-(id)initWIthSession:(SessionMeta*)session{
    if (self = [super init]) {
        _session = session;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT- UI_NAVIGATION_BAR_HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];

    [self drawNavigationBar];

}

- (void)drawNavigationBar{
    //navi bar
    self.navigationController.navigationBar.barTintColor = UI_COLOR_PINK;
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"场次票价";
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ticketListSuccess:) name:kTicketListSuccessNotification object:nil];
    [[NetworkManager sharedInstance]ticketPriceOfSession:self.session.sessionID];
    [MobClick beginLogPageView:UMengTicketList];
}

-(void)ticketListSuccess:(NSNotification*)notification{
    NSDictionary* userInfo = [notification userInfo];
    self.tickets = userInfo[kUserInfoKeyTickets];
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:kCinemaDetailListSuccessNotification];
    [MobClick endLogPageView:UMengTicketList];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backToParentView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *const identifier = @"TicketListTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TicketMeta * ticket = self.tickets[indexPath.row];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView setImageWithURL:[NSURL URLWithString:[URLManager fullImageURL:[NSString stringWithFormat:@"%@.png", ticket.source]]]];
    imageView.frame = CGRectMake(10, (60-imageView.image.size.height)/2, imageView.image.size.width, imageView.image.size.height);
    
    UILabel* label = [[UILabel alloc]init];
    label.text = ticket.source;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = UIColorFromRGB(0x000000);
    CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    label.frame = CGRectMake(CGRectGetMaxX(imageView.frame)+8, (60 - size.height)/2, size.width, size.height);
    
    UIImage * buttonImage = [UIImage imageNamed:@"list_movie_btn_buy"];
    UIButton* buyButton = [[UIButton alloc]init];
    buyButton.frame = CGRectMake(UI_SCREEN_WIDTH - 10 - buttonImage.size.width, (60-buttonImage.size.height)/2, buttonImage.size.width, buttonImage.size.height);
    [buyButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    NSAttributedString* title = [[NSAttributedString alloc]initWithString:@"购票" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:UIColorFromRGB(0xFE6F80)}];
    [buyButton setAttributedTitle:title forState:UIControlStateNormal];
    buyButton.tag = indexPath.row;
    [buyButton addTarget:self action:@selector(buyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* priceLabel = [[UILabel alloc]init];
    priceLabel.text = [NSString stringWithFormat:@"%.0f", ticket.currentPrice];
    priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:18];
    priceLabel.textColor = UIColorFromRGB(0xFF7833);
    size = [priceLabel.text sizeWithAttributes:@{NSFontAttributeName:priceLabel.font}];
    priceLabel.frame = CGRectMake(CGRectGetMinX(buyButton.frame)-size.width-15, (60 - size.height)/2, size.width, size.height);
    
    UILabel* rmbLabel = [[UILabel alloc]init];
    rmbLabel.text = @"¥";
    rmbLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:14];
    rmbLabel.textColor = UIColorFromRGB(0xFF7833);
    size = [rmbLabel.text sizeWithAttributes:@{NSFontAttributeName:rmbLabel.font}];
    rmbLabel.frame = CGRectMake(CGRectGetMinX(priceLabel.frame)-size.width-4, (60 - size.height)/2, size.width, size.height);
    
    [cell addSubview:imageView];
    [cell addSubview:label];
    [cell addSubview:buyButton];
    [cell addSubview:priceLabel];
    [cell addSubview:rmbLabel];
    
    return cell;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tickets count];
}

-(void)buyButtonPressed:(id)sender{
    NSInteger index = [sender tag];
    TicketMeta* ticket = self.tickets[index];
    BuyTicketViewController* buyVC = [[BuyTicketViewController alloc]initWithURL:ticket.url];
    [self.navigationController pushViewController:buyVC animated:YES];
    [MobClick event:UMengClickBuyInTicketList];
}


@end
