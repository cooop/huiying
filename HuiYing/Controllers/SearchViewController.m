//
//  SearchViewController.m
//  惠影
//
//  Created by 金鑫 on 16/3/18.
//  Copyright © 2016年 huiying. All rights reserved.
//

#import "SearchViewController.h"
#import "Constraits.h"
#import "HMSegmentedControl.h"
#import "MovieTableViewController.h"
#import "CinemaListViewController.h"

@interface SearchViewController ()<UISearchBarDelegate>
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITableView *searchHistoryTableView;
@property (strong, nonatomic) UITableView *searchResultTableView;
@property (strong, nonatomic) UIButton *clearSearchHistoryButton;
@property (strong, nonatomic) UIAlertView *searchingAlertView;
@property (strong, nonatomic) UIView *noSearchResultView;

@property (strong, nonatomic) UIGestureRecognizer *cancelSearchGestureRecognizer;

@property (strong, nonatomic) NSArray *searchHistoryArray;
@property (strong, nonatomic) NSMutableArray *searchResultArray;

@property (strong, nonatomic) NSIndexPath *indexPathOfShowingMenu;
@property (strong, nonatomic) NSIndexPath *tryToDeletePath;

@property (strong, nonatomic) UIButton *searchInAllNotesButton;
@property (assign, nonatomic) BOOL shouldShowHeaderAndFooter;

//edit
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) NSIndexPath *chooseIndexPathInTableView;
@property (nonatomic, strong) UIAlertView *renameGroupAlert;
@property (nonatomic, strong) UIAlertView *exeptionAlertView;


@property (nonatomic, strong) MovieTableViewController * movieTableViewController;
@property (nonatomic, strong) CinemaListViewController * cinemaListViewController;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, assign) int64_t cityID;

@end

@implementation SearchViewController

- (id) initWithCityID:(int64_t)cityID{
    self = [super init];
    if (self) {
        _cityID = cityID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // navigation bar
    UIImage * image = [UIImage imageNamed:@"nav_back"];
    UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, UI_STATUS_BAR_HEIGHT+UI_NAVIGATION_BAR_HEIGHT/2-image.size.height/2, image.size.width * 2, image.size.height)];
    [view addSubview:imageView];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToMovieListView)]];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backToMovieListView)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = UI_COLOR_PINK;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44)];
    self.searchBar.delegate = self;
    self.searchBar.barTintColor = UI_COLOR_PINK;
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.tintColor = UI_COLOR_PINK;
    self.shouldShowHeaderAndFooter = YES;
    
    UITextField *searchField = [self.searchBar valueForKey:@"_searchField"];
    [searchField setFont:[UIFont systemFontOfSize:14]];
    searchField.textColor = UIColorFromRGB(0x999999);
    [searchField setBackgroundColor: [UIColor whiteColor]];
    searchField.layer.borderWidth = .5f;
    searchField.layer.borderColor = UI_COLOR_PINK.CGColor;
    searchField.layer.cornerRadius = 4;
    searchField.clipsToBounds = YES;
    
    self.searchBar.placeholder = @"请输入关键词";
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"搜电影", @"搜影院"]];
    segmentedControl.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 40);
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.selectionIndicatorColor = UI_COLOR_PINK;
    segmentedControl.selectionIndicatorHeight = 2;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor blackColor]};
    segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:UI_COLOR_PINK};
    [segmentedControl addTarget:self action:@selector(switchBetweenMovieAndCinema) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    self.segmentedControl = segmentedControl;
    
    if (!_movieTableViewController) {
        _movieTableViewController = [[MovieTableViewController alloc]initWithCityId:self.cityID isSearch:YES];
        _movieTableViewController.tableView.hidden =YES;
        [self addChildViewController:_movieTableViewController];
    }
    [self.view addSubview:self.movieTableViewController.tableView];
    
    if (!_cinemaListViewController) {
        _cinemaListViewController = [[CinemaListViewController alloc]initWithCityId:self.cityID isSearch:YES];
        _cinemaListViewController.view.hidden = YES;
        [self addChildViewController:_cinemaListViewController];
    }
    [self.view addSubview:self.cinemaListViewController.view];
    _movieTableViewController.tableView.frame = CGRectMake(0, 40, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT-40);
    _cinemaListViewController.view.frame = CGRectMake(0, 40, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT-40);
    _cinemaListViewController.tableView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT-40);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hideKeyBoard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backToMovieListView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)switchBetweenMovieAndCinema{
    [self hideKeyBoard];
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        self.movieTableViewController.tableView.hidden = YES;
        self.cinemaListViewController.view.hidden = NO;
        [self.cinemaListViewController search:self.searchBar.text];
    }else{
        self.cinemaListViewController.view.hidden = YES;
        self.movieTableViewController.tableView.hidden = NO;
        [self.movieTableViewController search:self.searchBar.text];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self switchBetweenMovieAndCinema];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoard) name:kNotifyHideKeyboard object:nil];
}

- (void)hideKeyBoard{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.searchBar endEditing:NO];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifyHideKeyboard object:nil];
    });
}

@end
