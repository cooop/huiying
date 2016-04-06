//
//  SessionViewController.m
//  HuiYing
//
//  Created by Jin Xin on 15/7/2.
//  Copyright (c) 2015年 huiying. All rights reserved.
//

#import "SessionViewController.h"
#import "CinemaMeta.h"
#import "MovieMeta.h"
#import "Constraits.h"
#import "NetworkManager.h"
#import "UIImageView+AFNetworking.h"
#import "SessionMeta.h"
#import "SessionsMeta.h"
#import "CinemaViewController.h"
#import "TicketViewController.h"
#import "URLManager.h"
#import "MobClick.h"
#import "Utils.h"

@interface SessionViewController ()
@property (nonatomic, strong) CinemaMeta* cinema;
@property (nonatomic, strong) MovieMeta* selectedMovie;
@property (nonatomic, strong) NSArray* movies;
@property (nonatomic, strong) NSArray* dates;
@property (nonatomic, strong) NSDate* selectedDate;
@property (nonatomic, strong) NSDictionary* sessions;

@property (nonatomic, strong) UIView * cinemaView;
@property (nonatomic, strong) UILabel* cinemaName;
@property (nonatomic, strong) UILabel* cinemaAddress;
@property (nonatomic, strong) UICollectionView *imageCollectionView;
@property (nonatomic, strong) UIView * movieView;
@property (nonatomic, strong) UILabel* movieName;
@property (nonatomic, strong) UIImageView* movieVersion;
@property (nonatomic, strong) UILabel* movieRate;
@property (nonatomic, strong) UICollectionView * dateCollectionView;
@property (nonatomic, strong) UITableView * sessionTableView;
@property (nonatomic, strong) UIImageView * selectedDateBackground;
@property (nonatomic, assign) int64_t selectedMovieId;
@end

@implementation SessionViewController

- (id)initWithCinemaMeta:(CinemaMeta*)cinema{
    if (self = [super init]) {
        _cinema =  cinema;
        _selectedMovieId = -1;
    }
    return self;
}

- (id)initWithCinemaMeta:(CinemaMeta*)cinema andMovieId:(int64_t)movieId{
    if (self = [super init]) {
        _cinema =  cinema;
        _selectedMovieId = movieId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self drawNavigationBar];
    [self drawCinemaView];
    [self drawImageCollectionView];
    [self drawMovieView];
    [self drawDateCollectionView];
    [self drawSessionTableView];
    
    [self.view addSubview:_cinemaView];
    [self.view addSubview:_imageCollectionView];
    [self.view addSubview:_movieView];
    [self.view addSubview:_dateCollectionView];
    [self.view addSubview:_sessionTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieListSuccessInCinema:) name:kMovieListSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionListSuccess:) name:kSessionListSuccessNotification object:nil];
    if (self.selectedMovie) {
        [self refreshMoviewView];
    }
    [[NetworkManager sharedInstance]movieListInCinema:self.cinema.cinemaID];
    [MobClick beginLogPageView:UMengSessionList];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kMovieListSuccessNotification object:nil];
    [MobClick endLogPageView:UMengSessionList];
}

-(void)movieListSuccessInCinema:(NSNotification*)notification{
    NSDictionary * userInfo = [notification userInfo];
    self.movies = userInfo[kUserInfoKeyMovies];
    [self.imageCollectionView reloadData];
    if (!self.selectedMovie && self.movies.count >0) {
        if (self.selectedMovieId >= 0) {
            self.selectedMovie = [self findSelectMovieByMovieId:self.selectedMovieId];
        }
        if (!self.selectedMovie) {
            self.selectedMovie = self.movies[0];
        }
        [self refreshMoviewView];
    }
}

-(MovieMeta*)findSelectMovieByMovieId:(int64_t)movieId{
    for (MovieMeta* movie in self.movies) {
        if (movie.movieID == movieId) {
            return movie;
        }
    }
    return nil;
}

-(void)sessionListSuccess:(NSNotification*)notification{
    NSDictionary* userInfo = [notification userInfo];
    SessionsMeta* sessions = userInfo[kUserInfoKeySessions];
    self.dates = sessions.dates;
    if (self.selectedDate == nil && self.dates.count >0) {
        self.selectedDate = self.dates[0];
    }
    self.sessions = sessions.dateSessionsDic;
    [self.dateCollectionView reloadData];
    [self.sessionTableView reloadData];
}

- (void)drawNavigationBar{
    //navi bar
    self.navigationController.navigationBar.barTintColor = UI_COLOR_PINK;
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = self.cinema.cinemaName;
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


-(void)drawCinemaView{
    _cinemaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 60)];
    
    _cinemaName = [[UILabel alloc]init];
    _cinemaName.text = self.cinema.cinemaName;
    _cinemaName.textColor = UIColorFromRGB(0x000000);
    _cinemaName.font = [UIFont systemFontOfSize:15];
    CGSize size = [_cinemaName.text sizeWithAttributes:@{NSFontAttributeName:_cinemaName.font}];
    if (size.width < UI_SCREEN_WIDTH -30) {
        _cinemaName.frame = CGRectMake(10, 10, size.width, size.height);
    }else{
        _cinemaName.frame = CGRectMake(10, 10, UI_SCREEN_WIDTH -30, size.height);
    }
    [_cinemaView addSubview:_cinemaName];
    
    _cinemaAddress = [[UILabel alloc]init];
    _cinemaAddress.text = self.cinema.address;
    _cinemaAddress.textColor = UIColorFromRGB(0x6E6E6E);
    _cinemaAddress.font = [UIFont systemFontOfSize:13];
    size = [_cinemaAddress.text sizeWithAttributes:@{NSFontAttributeName:_cinemaAddress.font}];
    if (size.width < UI_SCREEN_WIDTH -30) {
        _cinemaAddress.frame = CGRectMake(10, 36, size.width, size.height);
    }else{
        _cinemaAddress.frame = CGRectMake(10, 36, UI_SCREEN_WIDTH -30, size.height);
    }
    [_cinemaView addSubview:_cinemaAddress];
    [_cinemaView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cinemaPressed:)]];
}

-(void)drawImageCollectionView{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _imageCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 60, UI_SCREEN_WIDTH, 115) collectionViewLayout:flowLayout];
    _imageCollectionView.backgroundColor = UIColorFromRGB(0x646464);
    _imageCollectionView.dataSource=self;
    _imageCollectionView.delegate=self;
    [_imageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MovieCoverImagesCollectionViewIdentifier"];
}

-(void)drawDateCollectionView{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _dateCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 221, UI_SCREEN_WIDTH, 46) collectionViewLayout:flowLayout];
    _dateCollectionView.backgroundColor = [UIColor whiteColor];
    _dateCollectionView.dataSource=self;
    _dateCollectionView.delegate=self;
    [_dateCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"SessionDateCollectionViewIdentifier"];
    CGFloat lineHeight = 1.0f/[UIScreen mainScreen].scale;
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 46 - lineHeight, UI_SCREEN_WIDTH, lineHeight)];
    line.backgroundColor = UIColorFromRGB(0xDCDCDC);
    [_dateCollectionView addSubview:line];
}

-(void)drawSessionTableView{
    _sessionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 267, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_STATUS_BAR_HEIGHT-267)];
    _sessionTableView.dataSource = self;
    _sessionTableView.delegate = self;
    _sessionTableView.tableFooterView = [[UIView alloc]init];
    _sessionTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
}

-(void)drawMovieView{
    _movieView = [[UIView alloc]initWithFrame:CGRectMake(0, 175, UI_SCREEN_WIDTH, 46)];
    
    _movieName = [[UILabel alloc]init];
    _movieName.font = [UIFont systemFontOfSize:18];
    _movieName.textColor = UIColorFromRGB(0x333333);
    [_movieView addSubview:_movieName];
    
    _movieVersion = [[UIImageView alloc]init];
    [_movieView addSubview:_movieVersion];
    
    _movieRate = [[UILabel alloc]init];
    _movieRate.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:18];
    _movieRate.textColor = UIColorFromRGB(0xFF7833);
    [_movieView addSubview:_movieRate];
    
    CGFloat lineHeight = 1.0f/[UIScreen mainScreen].scale;
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 46 - lineHeight, UI_SCREEN_WIDTH, lineHeight)];
    line.backgroundColor = UIColorFromRGB(0xDCDCDC);
    [_movieView addSubview:line];
    
}

-(void)refreshMoviewView{
    self.movieName.text = self.selectedMovie.chineseName;
    CGSize size = [self.movieName.text sizeWithAttributes:@{NSFontAttributeName:self.movieName.font}];
    self.movieName.frame = CGRectMake(10, (46-size.height)/2, size.width, size.height);
    
    self.movieVersion.image = [Utils versionImage:self.selectedMovie.version];
    size = self.movieVersion.image.size;
    self.movieVersion.frame = CGRectMake(CGRectGetMaxX(self.movieName.frame)+5, (46-size.height)/2, size.width, size.height);
    
    self.movieRate.text = [NSString stringWithFormat:@"%.1f", self.selectedMovie.rate ];
    size = [self.movieRate.text sizeWithAttributes:@{NSFontAttributeName: self.movieRate.font}];
    self.movieRate.frame = CGRectMake(CGRectGetMaxX(self.movieVersion.frame)+8, (46-size.height)/2, size.width, size.height);
    
    [[NetworkManager sharedInstance]sessionOfMovie:self.selectedMovie.movieID inCinema:self.cinema.cinemaID];
}

-(void)backToParentView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.imageCollectionView]) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCoverImagesCollectionViewIdentifier" forIndexPath:indexPath];
        if (!cell) {
            cell = [[UICollectionViewCell alloc]init];
        }
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 65, 85)];
        MovieMeta * movie = self.movies[indexPath.row];
        if (movie.movieID == self.selectedMovie.movieID) {
            imageView.layer.borderColor = [UIColor whiteColor].CGColor;
            imageView.layer.borderWidth = 2;
        }
        NSURL * url = [NSURL URLWithString:[URLManager fullImageURL:movie.coverImage]];
        __weak UIImageView* weakImageView = imageView;
        [imageView setImageWithURLRequest:[[NSURLRequest alloc]initWithURL:url] placeholderImage:[UIImage imageNamed:@"defult_img1"]success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            weakImageView.image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            weakImageView.image = [UIImage imageNamed:@"defult_img1"];
        }];
        [cell addSubview:imageView];
        return cell;
    }else{
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SessionDateCollectionViewIdentifier" forIndexPath:indexPath];
        if (!cell) {
            cell = [[UICollectionViewCell alloc]init];
        }else{
            [[cell viewWithTag:1] removeFromSuperview];
            [[cell viewWithTag:2] removeFromSuperview];
        }
        
        UILabel* dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 83, 46)];

        NSDate* date = self.dates[indexPath.row];
        dateLabel.text = [self stringOfDate:date];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.font = [UIFont systemFontOfSize:13];
        UIImageView* selectedDateBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"museum_date_select"]];
        selectedDateBackground.frame = CGRectMake(0, 7, 83, 31);
        if ([date isEqual:self.selectedDate]) {
            [cell addSubview:selectedDateBackground];
            [cell sendSubviewToBack:selectedDateBackground];
            dateLabel.textColor = [UIColor whiteColor];
        }else{
            dateLabel.textColor = UIColorFromRGB(0x6E6E6E);
        }
        dateLabel.tag = 1;
        selectedDateBackground.tag = 2;
        [cell addSubview:dateLabel];
        return cell;
    }
}

-(NSString*)stringOfDate:(NSDate*)date{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString* dateStr = [formatter stringFromDate:date];
    
    NSString* today = [formatter stringFromDate:[NSDate date]];
    NSString* tomorrow = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:60*60*24]];
    NSString* dayAfterTomorrow = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:60*60*24*2]];

    if ([dateStr isEqualToString:today]) {
        dateStr = [NSString stringWithFormat:@"今天%@",dateStr];
    }else if ([dateStr isEqualToString:tomorrow]){
        dateStr = [NSString stringWithFormat:@"明天%@",dateStr];
    }else if ([dateStr isEqualToString:dayAfterTomorrow]){
        dateStr = [NSString stringWithFormat:@"后天%@",dateStr];
    }else{
        dateStr = [NSString stringWithFormat:@"%@%@",[self weekdayStringFromDate:date],dateStr];
    }
    return dateStr;
}

- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if ([collectionView isEqual:self.imageCollectionView]) {
        return self.movies.count;
    }else{
        return self.dates.count;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.imageCollectionView]) {
        return CGSizeMake(65, 85);
    }else{
        return CGSizeMake(83, 46);
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if ([collectionView isEqual:self.imageCollectionView]) {
        return UIEdgeInsetsMake(15, 5, 15, 5);
    }else{
        return UIEdgeInsetsMake(0, 10, 0, 0);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.imageCollectionView]) {
        self.selectedMovie = self.movies[indexPath.row];
        self.selectedDate = nil;
        [self refreshMoviewView];
        [self.imageCollectionView reloadData];
    }else{
        self.selectedDate = self.dates[indexPath.row];
        [self.dateCollectionView reloadData];
        [self.sessionTableView reloadData];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *const identifier = @"SessionListTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    SessionMeta * session = self.sessions[self.selectedDate][indexPath.row];
    
    UILabel* startTimeLabel = [[UILabel alloc]init];
    startTimeLabel.text = [self stringOfTime:session.startTime];
    startTimeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:18];
    startTimeLabel.textColor = UIColorFromRGB(0x000000);
    CGSize size = [startTimeLabel.text sizeWithAttributes:@{NSFontAttributeName:startTimeLabel.font}];
    startTimeLabel.frame = CGRectMake(15, 20, size.width, size.height);
    
    UILabel* endTimeLabel = [[UILabel alloc]init];
    endTimeLabel.text = [NSString stringWithFormat:@"%@散场", [self stringOfTime:session.endTime]];
    endTimeLabel.font = [UIFont systemFontOfSize:13];
    endTimeLabel.textColor = UIColorFromRGB(0x6E6E6E);
    size = [endTimeLabel.text sizeWithAttributes:@{NSFontAttributeName: endTimeLabel.font}];
    endTimeLabel.frame = CGRectMake(15, 44, size.width, size.height);
    
    UILabel* movieLabel = [[UILabel alloc]init];
    movieLabel.text = [NSString stringWithFormat:@"%@/%@", [Utils versionString:session.version],session.language];
    movieLabel.font = [UIFont systemFontOfSize:13];
    movieLabel.textColor = UIColorFromRGB(0x6E6E6E);
    size = [movieLabel.text sizeWithAttributes:@{NSFontAttributeName:movieLabel.font}];
    movieLabel.frame = CGRectMake((UI_SCREEN_WIDTH-size.width)/2, 23, size.width, size.height);
    
    UILabel* roomLabel = [[UILabel alloc]init];
    roomLabel.text = session.room;
    roomLabel.font = [UIFont systemFontOfSize:13];
    roomLabel.textColor = UIColorFromRGB(0x6E6E6E);
    size = [roomLabel.text sizeWithAttributes:@{NSFontAttributeName:roomLabel.font}];
    roomLabel.frame = CGRectMake((UI_SCREEN_WIDTH-size.width)/2, 44, size.width, size.height);
    
    UILabel* priceLabel = [[UILabel alloc]init];
    if (session.minPrice == session.maxPrice) {
        priceLabel.text = [NSString stringWithFormat:@"%lld", session.minPrice];
    }else{
        priceLabel.text = [NSString stringWithFormat:@"%lld-%lld", session.minPrice, session.maxPrice];
    }
    priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:18];
    priceLabel.textColor = UIColorFromRGB(0xFF7833);
    size = [priceLabel.text sizeWithAttributes:@{NSFontAttributeName:priceLabel.font}];
    priceLabel.frame = CGRectMake(UI_SCREEN_WIDTH-size.width-15, 30, size.width, size.height);
    
    UILabel* rmbLabel = [[UILabel alloc]init];
    rmbLabel.text = @"¥";
    rmbLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:14];
    rmbLabel.textColor = UIColorFromRGB(0xFF7833);
    size = [rmbLabel.text sizeWithAttributes:@{NSFontAttributeName:rmbLabel.font}];
    rmbLabel.frame = CGRectMake(CGRectGetMinX(priceLabel.frame)-size.width-5, 32, size.width, size.height);
    
    [cell addSubview:startTimeLabel];
    [cell addSubview:endTimeLabel];
    [cell addSubview:movieLabel];
    [cell addSubview:roomLabel];
    [cell addSubview:priceLabel];
    [cell addSubview:rmbLabel];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TicketViewController* vc = [[TicketViewController alloc]initWIthSession:self.sessions[self.selectedDate][indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSString*)stringOfTime:(NSDate*)date{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString* dateStr = [formatter stringFromDate:date];
    return dateStr;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sessions[self.selectedDate] count];
}

-(MovieMeta*)movieOfMovieID:(int64_t)movieID{
    for (MovieMeta* movie in self.movies) {
        if (movie.movieID == movieID) {
            return movie;
        }
    }
    return nil;
}

-(void)cinemaPressed:(id)sender{
    CinemaViewController* vc = [[CinemaViewController alloc]initWithCinemaID:self.cinema.cinemaID];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
