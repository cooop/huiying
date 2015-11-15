//
//  ImagePreviewController.m
//  HuiYing
//
//  Created by 金鑫 on 15/9/21.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "ImagePreviewController.h"
#import "ImageViewController.h"
#import "Constraits.h"
#import "MobClick.h"

@interface ImagePreviewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSString* showingImage;
@property (nonatomic, strong) UIBarButtonItem * rightBarButton;
@property (nonatomic, strong) UILabel* titleLabel;
@end


@implementation ImagePreviewController

- (id)initWithImages:(NSArray*)images startIndex:(int64_t)index{
    if (self = [super init]) {
        _images = images;
        _startIndex = index;
        _showingImage = self.images[self.startIndex];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self drawNavigationBar];
    [self initPageViewController];//这句需要放在unlockFinishBlock初始化之后
}

- (void)drawNavigationBar{
    //navi bar
    self.navigationController.navigationBar.barTintColor = UI_COLOR_PINK;
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = [NSString stringWithFormat: @"剧照(%lld/%lu)",self.startIndex+1,self.images.count];
    titleLabel.textColor = UIColorFromRGB(0xFFFFFF);
    
    CGFloat titleWidth = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:titleLabel.font}].width;
    CGFloat titleHeight = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:titleLabel.font}].height;
    
    titleLabel.frame = CGRectMake(0, 0, titleWidth, titleHeight);
    self.navigationItem.titleView = titleLabel;
    self.titleLabel = titleLabel;
    
    UIImage * image = [UIImage imageNamed:@"nav_back"];
    UIImageView * view = [[UIImageView alloc]initWithImage:image];
    view.frame = CGRectMake(10,UI_STATUS_BAR_HEIGHT+UI_NAVIGATION_BAR_HEIGHT/2-image.size.height/2, image.size.width, image.size.height);
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToParentView)]];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = backBarButton;
}

-(void)backToParentView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:UMengImagePreview];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:UMengImagePreview];
}

- (void)initPageViewController
{
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    [self addChildViewController:self.pageViewController];
    self.pageViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    ImageViewController *selectedImageViewController = [self getImageViewControllerForPageIndex:self.startIndex];
    [self.pageViewController setViewControllers:@[selectedImageViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(ImageViewController *)viewController {
    NSUInteger oldPageIndex = viewController.pageIndex;
    NSInteger newPageIndex = oldPageIndex - 1;
    if (newPageIndex >= 0) {
        return [self getImageViewControllerForPageIndex:newPageIndex];
    } else {
        return nil;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(ImageViewController *)viewController {
    NSUInteger oldPageIndex = viewController.pageIndex;
    NSUInteger newPageIndex = oldPageIndex + 1;
    if (newPageIndex < self.images.count) {
        return [self getImageViewControllerForPageIndex:newPageIndex];
    } else {
        return nil;
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    ImageViewController *imageViewController = pageViewController.viewControllers[0];
    self.showingImage = self.images[imageViewController.pageIndex];
    self.titleLabel.text = [NSString stringWithFormat: @"剧照(%lu/%lu)",imageViewController.pageIndex+1,self.images.count];
    CGFloat titleWidth = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].width;
    CGFloat titleHeight = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].height;
    
    self.titleLabel.frame = CGRectMake(0, 0, titleWidth, titleHeight);
}

- (ImageViewController *)getImageViewControllerForPageIndex:(NSUInteger)pageIndex {
    NSString *downloadImage = self.images[pageIndex];
    
    ImageViewController *imageViewController = [self getReusableViewController:downloadImage];
    imageViewController.pageIndex = pageIndex;
    
    return imageViewController;
}

#pragma mark - Reusable UI Elements

- (ImageViewController *)getReusableViewController:(NSString *)curImage {
    ImageViewController *imageViewController = [[ImageViewController alloc] initWithURL:curImage];
    return imageViewController;
}

@end
