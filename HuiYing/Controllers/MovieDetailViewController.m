//
//  MovieDetailViewController.m
//  HuiYing
//
//  Created by Jin Xin on 15/6/15.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "MovieDetailMeta.h"
#import "NetworkManager.h"
#import "UIImage+ImageEffects.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailViewController ()
@property (nonatomic, strong) MovieDetailMeta * movieDetail;
@property (nonatomic, assign) int64_t movieID;
@property (nonatomic, strong) UIScrollView* scrollView;

@property (nonatomic, strong) UIImageView* headerView;
@property (nonatomic, strong) UIImageView* coverImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView* versionImageView;
@property (nonatomic, strong) UILabel * typeLabel;
@property (nonatomic, strong) UILabel * durationLabel;
@property (nonatomic, strong) UIImageView* star1;
@property (nonatomic, strong) UIImageView* star2;
@property (nonatomic, strong) UIImageView* star3;
@property (nonatomic, strong) UIImageView* star4;
@property (nonatomic, strong) UIImageView* star5;
@property (nonatomic, strong) UILabel* ratingLabel;

@property (nonatomic, assign, getter=isFullDescription) BOOL fullDescription;
@property (nonatomic, strong) UIView * descriptionView;
@property (nonatomic, strong) UILabel * tipLabel;
@property (nonatomic, strong) UIButton * moreButton;
@property (nonatomic, strong) UITextView* movieDescriptionView;

@property (nonatomic, strong) NSMutableArray * imageViews;
@property (nonatomic, strong) UIView * imagesView;
@property (nonatomic, strong) UILabel* imageTitleView;
@property (nonatomic, strong) UIScrollView* myScrollView;

@property (nonatomic, strong) UIImagePickerController * imagePicker;
@property (nonatomic, strong) UIButton * buyButton;
@end

@implementation MovieDetailViewController

- (id)initWithMovieID:(int64_t)movieID{
    if (self = [super init]) {
        _movieID = movieID;
        _headerView = [[UIImageView alloc] init];
        _coverImageView = [[UIImageView alloc] init];
        _titleLabel = [[UILabel alloc]init];
        _versionImageView = [[UIImageView alloc]init];
        _typeLabel = [[UILabel alloc]init];
        _durationLabel = [[UILabel alloc]init];
        _ratingLabel = [[UILabel alloc]init];
        _star1 = [[UIImageView alloc]init];
        _star2 = [[UIImageView alloc]init];
        _star3 = [[UIImageView alloc]init];
        _star4 = [[UIImageView alloc]init];
        _star5 = [[UIImageView alloc]init];
        _imageViews = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _buyButton = [[UIButton alloc]initWithFrame:CGRectMake(10, UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_STATUS_BAR_HEIGHT-50, UI_SCREEN_WIDTH-20, 40)];
    NSAttributedString * title = [[NSAttributedString alloc]initWithString:@"购票" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:UIColorFromRGB(0xFFFFFF)}];
    [_buyButton setAttributedTitle:title forState:UIControlStateNormal];
    _buyButton.backgroundColor = UI_COLOR_PINK;
    _buyButton.layer.cornerRadius = 20;
    [self.view addSubview:_buyButton];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_STATUS_BAR_HEIGHT-60)];
    
    [self.view addSubview:_scrollView];
    
    [self drawNavigationBar];
    [self drawHeaderView];
    [self drawMovieDesciption];
    [self drawImages];
    _scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, CGRectGetHeight(_headerView.frame)+CGRectGetHeight(_descriptionView.frame)+ CGRectGetHeight(_imagesView.frame));
    
    
}

- (void)drawNavigationBar{
    //navi bar
    self.navigationController.navigationBar.barTintColor = UI_COLOR_PINK;
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"影片介绍";
    titleLabel.textColor = UIColorFromRGB(0xFFFFFF);
    
    CGFloat titleWidth = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:titleLabel.font}].width;
    CGFloat titleHeight = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:titleLabel.font}].height;
    
    titleLabel.frame = CGRectMake(0, 0, titleWidth, titleHeight);
    self.navigationItem.titleView = titleLabel;
    
    
    UIImage * image = [UIImage imageNamed:@"nav_back"];
    UIImageView * view = [[UIImageView alloc]initWithImage:image];
    view.frame = CGRectMake(10,UI_STATUS_BAR_HEIGHT+UI_NAVIGATION_BAR_HEIGHT/2-image.size.height/2, image.size.width, image.size.height);
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToMovieListView)]];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = backBarButton;
}

- (void)drawHeaderView{

    
    //header
    _headerView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 132);
    
    _coverImageView.frame = CGRectMake(10, 10, 80, 108);
    _coverImageView.contentMode = UIViewContentModeScaleToFill;
    
    UIImage* defaultImage = [UIImage imageNamed:@"defult_img1"];
    _coverImageView.image = defaultImage;
    UIImage* blurDefautImage =[defaultImage applyBlurWithRadius:0.5f tintColor:[UIColor colorWithWhite:0.85f alpha:0.75f] saturationDeltaFactor:1.8 maskImage:nil];
    _headerView.image = blurDefautImage;
    
    CALayer *imageLayer = _coverImageView.layer;
    imageLayer.borderWidth = 1;
    imageLayer.borderColor = UIColorFromRGB(0xFFFFFF).CGColor;
    
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textColor = UIColorFromRGB(0xFFFFFF);
    _titleLabel.text = @"影片";
    CGSize size = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}];
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_coverImageView.frame)+10, 24, size.width, size.height);
    
    _typeLabel.font = [UIFont systemFontOfSize:13];
    _typeLabel.textColor = UIColorFromRGB(0xFFFFFF);
    _typeLabel.text = @"类型";
    size = [_typeLabel.text sizeWithAttributes:@{NSFontAttributeName:_typeLabel.font}];
    _typeLabel.frame = CGRectMake(CGRectGetMaxX(_coverImageView.frame)+10, CGRectGetMaxY(_titleLabel.frame)+12, size.width, size.height);
    
    _durationLabel.font = [UIFont systemFontOfSize:13];
    _durationLabel.textColor = UIColorFromRGB(0xFFFFFF);
    _durationLabel.text = @"片长";
    size = [_durationLabel.text sizeWithAttributes:@{NSFontAttributeName:_durationLabel.font}];
    _durationLabel.frame = CGRectMake(CGRectGetMaxX(_coverImageView.frame)+10, CGRectGetMaxY(_typeLabel.frame)+8, size.width, size.height);
    
    UIImage * starImage = [UIImage imageNamed:@"intro_movie_ico_star3"];
    _star1.image = starImage;
    _star2.image = starImage;
    _star3.image = starImage;
    _star4.image = starImage;
    _star5.image = starImage;
    _star1.frame = CGRectMake(CGRectGetMaxX(_coverImageView.frame)+10, CGRectGetMaxY(_durationLabel.frame)+10, starImage.size.width, starImage.size.height);
    _star2.frame = CGRectMake(CGRectGetMaxX(_star1.frame)+4, CGRectGetMaxY(_durationLabel.frame)+10, starImage.size.width, starImage.size.height);
    _star3.frame = CGRectMake(CGRectGetMaxX(_star2.frame)+4, CGRectGetMaxY(_durationLabel.frame)+10, starImage.size.width, starImage.size.height);
    _star4.frame = CGRectMake(CGRectGetMaxX(_star3.frame)+4, CGRectGetMaxY(_durationLabel.frame)+10, starImage.size.width, starImage.size.height);
    _star5.frame = CGRectMake(CGRectGetMaxX(_star4.frame)+4, CGRectGetMaxY(_durationLabel.frame)+10, starImage.size.width, starImage.size.height);
    
    _ratingLabel.backgroundColor = [UIColor clearColor];
    _ratingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:18];
    _ratingLabel.textColor = UIColorFromRGB(0xFF7833);
    _ratingLabel.text = @"0.0";
    size = [_ratingLabel.text sizeWithAttributes:@{NSFontAttributeName:_ratingLabel.font}];
    _ratingLabel.frame = CGRectMake(CGRectGetMaxX(_star5.frame)+6, CGRectGetMaxY(_durationLabel.frame)+10,size.width, size.height);
    
    [_headerView addSubview:_coverImageView];
    [_headerView addSubview:_titleLabel];
    [_headerView addSubview:_versionImageView];
    [_headerView addSubview:_typeLabel];
    [_headerView addSubview:_durationLabel];
    [_headerView addSubview:_star1];
    [_headerView addSubview:_star2];
    [_headerView addSubview:_star3];
    [_headerView addSubview:_star4];
    [_headerView addSubview:_star5];
    [_headerView addSubview:_ratingLabel];
    
    [self.scrollView addSubview:_headerView];
}

- (void)drawMovieDesciption{
    self.fullDescription = NO;
    
    _descriptionView = [[UIView alloc]initWithFrame:CGRectMake(0, 132, UI_SCREEN_WIDTH, 160)];
    
    _tipLabel = [[UILabel alloc]init];
    _tipLabel.text = @"剧情简介";
    _tipLabel.textColor = UIColorFromRGB(0x333333);
    _tipLabel.font = [UIFont systemFontOfSize:15];
    CGSize size = [_tipLabel.text sizeWithAttributes:@{NSFontAttributeName:_tipLabel.font}];
    _tipLabel.frame = CGRectMake(10, 15, size.width, size.height);
    [_descriptionView addSubview:_tipLabel];
    
    _moreButton = [[UIButton alloc]init];
    UIImage * downArrowImage = [UIImage imageNamed:@"intro_movie_arrow"];
    [_moreButton setImage:downArrowImage forState:UIControlStateNormal];
    _moreButton.frame = CGRectMake((UI_SCREEN_WIDTH - downArrowImage.size.width)/2, 150 -downArrowImage.size.height, downArrowImage.size.width, downArrowImage.size.height);
    [_moreButton addTarget:self action:@selector(moreButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_descriptionView addSubview:_moreButton];
    
    _movieDescriptionView = [[UITextView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_tipLabel.frame)+5, UI_SCREEN_WIDTH -20, 130 - size.height - downArrowImage.size.height)];
    _movieDescriptionView.textColor = UIColorFromRGB(0x6E6E6E);
    _movieDescriptionView.scrollEnabled = NO;
    _movieDescriptionView.editable = NO;
    [_descriptionView addSubview:_movieDescriptionView];
    
    _descriptionView.layer.borderColor = UIColorFromRGB(0xDCDCDC).CGColor;
    _descriptionView.layer.borderWidth = 1;
    
    [self.scrollView addSubview:_descriptionView];
}

- (void)moreButtonPressed{
    CGSize size = [_tipLabel.text sizeWithAttributes:@{NSFontAttributeName:_tipLabel.font}];
    UIImage * downArrowImage = [UIImage imageNamed:@"intro_movie_arrow"];
    
    if ([self isFullDescription]) {
        _descriptionView.frame = CGRectMake(0, 132, UI_SCREEN_WIDTH, 160);
        _moreButton.frame = CGRectMake((UI_SCREEN_WIDTH - downArrowImage.size.width)/2, 150 -downArrowImage.size.height, downArrowImage.size.width, downArrowImage.size.height);
        _movieDescriptionView.frame = CGRectMake(10, CGRectGetMaxY(_tipLabel.frame)+5, UI_SCREEN_WIDTH -20, 130 - size.height - downArrowImage.size.height);
        _movieDescriptionView.contentSize = _movieDescriptionView.frame.size;
        self.fullDescription = NO;
    }else{
        CGSize deSize = [_movieDescriptionView sizeThatFits:CGSizeMake(_movieDescriptionView.frame.size.width,CGFLOAT_MAX)];
        
        if (deSize.height > 130 - size.height - downArrowImage.size.height) {
            CGFloat height = 30+size.height+downArrowImage.size.height+ deSize.height;
            _descriptionView.frame = CGRectMake(0, 132, UI_SCREEN_WIDTH,height);
            _moreButton.frame = CGRectMake((UI_SCREEN_WIDTH - downArrowImage.size.width)/2, height - 10 -downArrowImage.size.height, downArrowImage.size.width, downArrowImage.size.height);
            _movieDescriptionView.frame = CGRectMake(10, CGRectGetMaxY(_tipLabel.frame)+5, UI_SCREEN_WIDTH -20, deSize.height);
        }
        self.fullDescription = YES;
    }
    _imagesView.frame = CGRectMake(0, CGRectGetMaxY(_descriptionView.frame), UI_SCREEN_WIDTH, 110);
    _scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, CGRectGetHeight(_headerView.frame)+CGRectGetHeight(_descriptionView.frame)+CGRectGetHeight(_imagesView.frame));
}

- (void)drawImages{
    _imagesView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_descriptionView.frame), UI_SCREEN_WIDTH, 110)];
    
    _imageTitleView = [[UILabel alloc]init];
    _imageTitleView.text = @"剧照";
    _imageTitleView.font = [UIFont systemFontOfSize:15];
    _imageTitleView.textColor = UIColorFromRGB(0x333333);
    CGSize size = [_imageTitleView.text sizeWithAttributes:@{NSFontAttributeName:_imageTitleView.font}];
    _imageTitleView.frame = CGRectMake(10, 15, size.width, size.height);
    [_imagesView addSubview:_imageTitleView];
    
    int count = (UI_SCREEN_WIDTH-18)/62;
    int margin = (UI_SCREEN_WIDTH-20-count*60)/(count-1);
    
    for (int i =0; i< count; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10+(60+margin)*i, 25+size.height, 60, 60)];
        imageView.image = [UIImage imageNamed:@"defult_img2"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedWithObject:)];
        imageView.tag = i;
        [imageView addGestureRecognizer:tap];
        [_imageViews addObject:imageView];
        [_imagesView addSubview:imageView];
    }
    
    _descriptionView.layer.borderColor = UIColorFromRGB(0xDCDCDC).CGColor;
    _descriptionView.layer.borderWidth = 1;
    
    [self.scrollView addSubview:_imagesView];
}

- (void) tappedWithObject:(id)sender
{
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDetailListSuccess:) name:kMovieDetailListSuccessNotification object:nil];
    [[NetworkManager sharedInstance] movieListDetailWithID:self.movieID];
}

- (void)movieDetailListSuccess:(NSNotification*)notification
{
    NSDictionary * userInfo = [notification userInfo];
    if ([userInfo[kUserInfoKeyMovieID] isEqual:@(self.movieID)]) {
        _movieDetail = userInfo[kUserInfoKeyMovieDetail];
    }
    
    NSURL * url = [NSURL URLWithString:self.movieDetail.coverImage];

    __weak __typeof__(self) weakSelf = self;
    [_coverImageView setImageWithURLRequest:[[NSURLRequest alloc]initWithURL:url] placeholderImage:[UIImage imageNamed:@"defult_img1"]success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakSelf.coverImageView.image = image;
        weakSelf.headerView.image = [image applyBlurWithRadius:0.5f tintColor:[UIColor colorWithWhite:0.85f alpha:0.75f] saturationDeltaFactor:1.8 maskImage:nil];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        weakSelf.coverImageView.image = [UIImage imageNamed:@"defult_img1"];
        weakSelf.headerView.image = [[UIImage imageNamed:@"defult_img1"]applyBlurWithRadius:0.5f tintColor:[UIColor colorWithWhite:0.85f alpha:0.75f] saturationDeltaFactor:1.8 maskImage:nil];
    }];
    
    _titleLabel.text = self.movieDetail.chineseName;
    CGSize size = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}];
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_coverImageView.frame)+10, 24, size.width, size.height);
    
    _typeLabel.text = [NSString stringWithFormat:@"类型: %@",self.movieDetail.type];
    size = [_typeLabel.text sizeWithAttributes:@{NSFontAttributeName:_typeLabel.font}];
    _typeLabel.frame = CGRectMake(CGRectGetMaxX(_coverImageView.frame)+10, CGRectGetMaxY(_titleLabel.frame)+12, size.width, size.height);

    _durationLabel.text = [NSString stringWithFormat:@"片长: %lld分钟",self.movieDetail.duration];
    size = [_durationLabel.text sizeWithAttributes:@{NSFontAttributeName:_durationLabel.font}];
    _durationLabel.frame = CGRectMake(CGRectGetMaxX(_coverImageView.frame)+10, CGRectGetMaxY(_typeLabel.frame)+8, size.width, size.height);
    
    _ratingLabel.text = [NSString stringWithFormat:@"%.1f", self.movieDetail.rate];
    size = [_ratingLabel.text sizeWithAttributes:@{NSFontAttributeName:_ratingLabel.font}];
    _ratingLabel.frame = CGRectMake(CGRectGetMaxX(_star5.frame)+6, CGRectGetMaxY(_durationLabel.frame)+10,size.width, size.height);
    
    _versionImageView.image = [self versionImage:self.movieDetail];
    size = _versionImageView.image.size;
    _versionImageView.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame)+4, 24, size.width, size.height);
    
    int rate = (int)(self.movieDetail.rate + 0.5);
    if (rate < 1) {
    }else if(rate >= 1 & rate < 2){
        _star1.image = [UIImage imageNamed:@"intro_movie_ico_star2"];
    }else{
        _star1.image = [UIImage imageNamed:@"intro_movie_ico_star1"];
    }

    if (rate < 3) {
    }else if(rate >= 3 & rate < 4){
        _star2.image = [UIImage imageNamed:@"intro_movie_ico_star2"];
    }else{
        _star2.image = [UIImage imageNamed:@"intro_movie_ico_star1"];
    }
    
    if (rate < 5) {
    }else if(rate >= 5 & rate < 6){
        _star3.image = [UIImage imageNamed:@"intro_movie_ico_star2"];
    }else{
        _star3.image = [UIImage imageNamed:@"intro_movie_ico_star1"];
    }
    
    if (rate < 7) {
    }else if(rate >= 7 & rate < 8){
        _star4.image = [UIImage imageNamed:@"intro_movie_ico_star2"];
    }else{
        _star4.image = [UIImage imageNamed:@"intro_movie_ico_star1"];
    }
    
    if (rate < 9) {
    }else if(rate >= 9 & rate < 10){
        _star5.image = [UIImage imageNamed:@"intro_movie_ico_star2"];
    }else{
        _star5.image = [UIImage imageNamed:@"intro_movie_ico_star1"];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName:UIColorFromRGB(0x6E6E6E),
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    //TODO:self.movieDetail.movieDescription
    _movieDescriptionView.attributedText = [[NSAttributedString alloc] initWithString:@"生活在日本东京的野比大雄（大原惠美 配音），是一个学习不上进、日常迷迷糊糊并且饱受同学欺负的男孩。他的性格不仅左右着自己的事业和婚姻，还对未来子孙产生莫大的影响。为此，大雄孙子的孙子世修（松本さち 配音）带着猫型机器人哆啦A梦（水田山葵 配音）乘坐时光机突然来访，期望彻底改变大雄及整个家族的命运。在哆啦A梦的帮助下，大雄不再受到胖虎（木村昴 配音）和小夫（关智一 配音）等人的欺负，他喜欢美丽的女孩源静香（嘉数由美 配音）。为了实现和静香结婚的命运，他和哆啦A梦穿越时空，见证了决定人生的最关键的时刻和事件。当大雄慢慢开始变得幸福之际，哆啦A梦也到了必须返回22世纪的时候……" attributes:attributes];
    
    for (int i = 0; i< self.imageViews.count; i++) {
        NSURL * url = [NSURL URLWithString:self.movieDetail.images[i]];
        [self.imageViews[i] setImageWithURLRequest:[[NSURLRequest alloc]initWithURL:url] placeholderImage:[UIImage imageNamed:@"defult_img2"]success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            ((UIImageView*)weakSelf.imageViews[i]).image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            ((UIImageView*)weakSelf.imageViews[i]).image = [UIImage imageNamed:@"defult_img2"];
        }];
    }
    
}

-(void)backToMovieListView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
