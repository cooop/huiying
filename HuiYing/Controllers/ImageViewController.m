//
//  ImageViewController.m
//  HuiYing
//
//  Created by 金鑫 on 15/9/21.
//  Copyright © 2015年 huiying. All rights reserved.
//

#import "ImageViewController.h"
#import "Constraits.h"
#import "UIImageView+AFNetworking.h"
#import "URLManager.h"

@interface ImageViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) UIImageView* centerImageView;
@property (nonatomic, strong) UIActivityIndicatorView* indicatorView;
@property (nonatomic, strong) UIScrollView* scrollView;

@end

@implementation ImageViewController

- (instancetype)initWithURL:(NSString *)url {
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}


#pragma mark - lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_STATUS_BAR_HEIGHT-UI_NAVIGATION_BAR_HEIGHT)];
    self.centerImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:self.centerImageView];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicatorView.color = [UIColor grayColor];
    CGFloat height = UI_SCREEN_HEIGHT-UI_STATUS_BAR_HEIGHT-UI_NAVIGATION_BAR_HEIGHT;
    self.indicatorView.center = CGPointMake(UI_SCREEN_WIDTH / 2, (height) / 2);
    
    self.indicatorView.hidesWhenStopped=YES;
    [self.view addSubview:self.indicatorView];
    
    [self.indicatorView startAnimating];
    
    __weak __typeof__(self) weakSelf = self;
    [self.centerImageView setImageWithURLRequest:[[NSURLRequest alloc]initWithURL:[[NSURL alloc]initWithString:[URLManager fullImageURL:self.url]]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakSelf.centerImageView.image = image;
        [weakSelf.indicatorView stopAnimating];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [weakSelf.indicatorView stopAnimating];
    }];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    
    [_scrollView addSubview:self.centerImageView];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doDoubleTap)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [_scrollView addGestureRecognizer:doubleTap];

    //设置UIScrollView的滚动范围和图片的真实尺寸一致
    _scrollView.contentSize=self.centerImageView.bounds.size;
    
    //设置实现缩放
    //设置代理scrollview的代理对象
    _scrollView.delegate=self;
    
    //设置最大伸缩比例
    _scrollView.maximumZoomScale=2.0;
    
    //设置最小伸缩比例
    _scrollView.minimumZoomScale=1.0;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _scrollView.zoomScale = 1.0;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.centerImageView;
}

-(void)doDoubleTap{
    if (self.scrollView.zoomScale<= 1.5) {
        [self.scrollView setZoomScale:2.0 animated:YES];
    }else{
        [self.scrollView setZoomScale:1.0 animated:YES];
    }
}
@end
