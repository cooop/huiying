//
//  MovieImagesViewController.m
//  HuiYing
//
//  Created by 金鑫 on 15/9/21.
//  Copyright © 2015年 huiying. All rights reserved.
//

#import "MovieImagesViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Constraits.h"
#import "URLManager.h"
#import "ImagePreviewController.h"
#import "MobClick.h"

#define kImageViewWidth (UI_SCREEN_WIDTH - 40)/4

@interface MovieImagesViewController()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView* imagesCollectionView;

@end

@implementation MovieImagesViewController

-(id)initWithImageUrls:(NSArray *)imageUrls{
    if (self = [super init]) {
        _imageUrls = imageUrls;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self drawNavigationBar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _imagesCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT) collectionViewLayout:flowLayout];
    _imagesCollectionView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT);
    _imagesCollectionView.backgroundColor = [UIColor clearColor];
    _imagesCollectionView.dataSource=self;
    _imagesCollectionView.delegate=self;
    [_imagesCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MovieImagesCollectionViewIdentifier"];
    
    [self.view addSubview:self.imagesCollectionView];
}

- (void)drawNavigationBar{
    //navi bar
    self.navigationController.navigationBar.barTintColor = UI_COLOR_PINK;
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"剧照";
    titleLabel.textColor = UIColorFromRGB(0xFFFFFF);
    
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
    [MobClick beginLogPageView:UMengMovieImagesList];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:UMengMovieImagesList];
}


-(void)backToParentView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageUrls.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieImagesCollectionViewIdentifier" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UICollectionViewCell alloc]init];
    }
    
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kImageViewWidth, kImageViewWidth)];
    __weak UIImageView * weakImageView = imageView;
    NSURL * url = [NSURL URLWithString: [URLManager fullImageURL:self.imageUrls[indexPath.row]]];
    [imageView setImageWithURLRequest:[[NSURLRequest alloc]initWithURL:url] placeholderImage:[UIImage imageNamed:@"defult_img2"]success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakImageView.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        weakImageView.image = [UIImage imageNamed:@"defult_img2"];
    }];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    [cell addSubview: imageView];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kImageViewWidth, kImageViewWidth);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ImagePreviewController* ipvc = [[ImagePreviewController alloc]initWithImages:self.imageUrls startIndex:indexPath.row];
    [self.navigationController pushViewController:ipvc animated:YES];
}


@end
