//
//  MovieTableViewController.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/27.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "MovieTableViewController.h"
#import "Constraits.h"
#import "MovieMeta.h"

@interface MovieTableViewController ()

@end

@implementation MovieTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.rowHeight = 105;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const identifier = @"MovieListTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    UIImageView *coverImageView = [[UIImageView alloc]init];
    coverImageView.contentMode = UIViewContentModeScaleToFill;
    coverImageView.opaque = YES;
    coverImageView.frame = CGRectMake(10, 10, 65, 85);
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor blackColor];
    
    UILabel *descriptionLabel = [[UILabel alloc]init];
    descriptionLabel.frame = CGRectMake(CGRectGetMaxX(coverImageView.frame)+10, 57, 200, 15);
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.textAlignment = NSTextAlignmentLeft;
    descriptionLabel.font = [UIFont systemFontOfSize:13];
    descriptionLabel.textColor = UIColorFromRGB(0x6E6E6E);
    
    
    UILabel *infoLabal = [[UILabel alloc]init];
    infoLabal.frame = CGRectMake(CGRectGetMaxX(coverImageView.frame)+10, 78, 150, 15);
    infoLabal.backgroundColor = [UIColor clearColor];
    infoLabal.textAlignment = NSTextAlignmentLeft;
    infoLabal.font = [UIFont systemFontOfSize:13];
    infoLabal.textColor = UIColorFromRGB(0x6E6E6E);
    
    UIImageView* versionView = [[UIImageView alloc]init];
    versionView.contentMode = UIViewContentModeLeft;
    versionView.opaque = YES;
    
    UILabel* ratingLabel = [[UILabel alloc]init];
    ratingLabel.frame = CGRectMake(CGRectGetMaxX(versionView.frame)+4, 20, UI_SCREEN_WIDTH-CGRectGetMaxX(versionView.frame)-14, 20);
    ratingLabel.backgroundColor = [UIColor clearColor];
    ratingLabel.textAlignment = NSTextAlignmentRight;
    ratingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:18];
    ratingLabel.textColor = UIColorFromRGB(0xFF7833);
    
    UIImage * buttonImage = [UIImage imageNamed:@"list_movie_btn_buy"];
    UIButton* buyButton = [[UIButton alloc]init];
    buyButton.frame = CGRectMake(UI_SCREEN_WIDTH - 10 - buttonImage.size.width, 56, buttonImage.size.width, buttonImage.size.height);
    [buyButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    NSAttributedString* title = [[NSAttributedString alloc]initWithString:@"购票" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:UIColorFromRGB(0xFE6F80)}];
    [buyButton setAttributedTitle:title forState:UIControlStateNormal];
    
    [cell addSubview:coverImageView];
    [cell addSubview:titleLabel];
    [cell addSubview:versionView];
    [cell addSubview:descriptionLabel];
    [cell addSubview:infoLabal];
    [cell addSubview:ratingLabel];
    [cell addSubview:buyButton];
    
    MovieMeta* movieMeta = self.movies[indexPath.row];
    coverImageView.image = [UIImage imageNamed:@"image"];
    titleLabel.text = movieMeta.chineseName;
    CGFloat titleWidth = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:titleLabel.font}].width;
    titleLabel.frame = CGRectMake(CGRectGetMaxX(coverImageView.frame)+10, 20, titleWidth, 20);
    versionView.frame= CGRectMake(CGRectGetMaxX(titleLabel.frame)+4, 20, 50, 20);
    versionView.image =[self versionImage:movieMeta];
    descriptionLabel.text = movieMeta.subtitle;
    infoLabal.text = [NSString stringWithFormat:@"今天%d家影院%d场",67,956];
    ratingLabel.text =[NSString stringWithFormat:@"%.1f", (float)movieMeta.rate/10];
    return cell;
}

-(UIImage*)versionImage:(MovieMeta*)movieMeta{
    UIImage* image = nil;
    switch (movieMeta.version) {
        case kMovieVersion2DIMAX:
            image = [UIImage imageNamed:@"list_movie_ico_imax2d"];
            break;
        case kMovieVersion3D:
            image = [UIImage imageNamed:@"list_movie_ico_3d"];
            break;
        case kMovieVersion3DIMAX:
            image = [UIImage imageNamed:@"list_movie_ico_imax3d"];
            break;
        default:
            break;
    }
    return image;
}






@end