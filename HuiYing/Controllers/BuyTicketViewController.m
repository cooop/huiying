//
//  BuyTicketViewController.m
//  HuiYing
//
//  Created by 金鑫 on 15/10/25.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "BuyTicketViewController.h"
#import "Constraits.h"

@interface BuyTicketViewController()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView * webView;
@property (nonatomic, strong) UIActivityIndicatorView* activityIndicatorView;
@property (nonatomic, strong) NSString* url;
@end

@implementation BuyTicketViewController


-(id) initWithURL:(NSString*)url{
    if(self = [super init]){
        _url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _webView = [[UIWebView alloc]init];
    _webView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT);
    _webView.scalesPageToFit =YES;
    _webView.delegate = self;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    [_activityIndicatorView setCenter: self.view.center] ;
    [_activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite] ;
    [self.view addSubview : _activityIndicatorView] ;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self drawNavigationBar];
    
}

- (void)drawNavigationBar{
    //navi bar
    self.navigationController.navigationBar.barTintColor = UI_COLOR_PINK;
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"购票";
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

-(void)backToParentView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicatorView startAnimating] ;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicatorView stopAnimating];
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
    NSURL *url = [NSURL URLWithString:[error.userInfo objectForKey:@"NSErrorFailingURLStringKey"]];
    if ([error.domain isEqual:@"WebKitErrorDomain"]
        && error.code == 101
        && [[UIApplication sharedApplication]canOpenURL:url])
    {
        [[UIApplication sharedApplication]openURL:url];
        return;
    }
    
    // Normal error handling…
}

@end
