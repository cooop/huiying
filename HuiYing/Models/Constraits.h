//
//  Constraits.h
//  HuiYing
//
//  Created by Jin Xin on 15/5/8.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#ifndef HuiYing_Constraits_h
#define HuiYing_Constraits_h

#pragma mark - JSON Keys

#define kJSONKeyCityID   @"id"
#define kJSONKeyCityName  @"name"

#define kJSONKeyDistrictID @"id"
#define kJSONKeyDistrictName @"name"

#define kJSONKeyCinemaID @"id"
#define kJSONKeyCinemaName @"name"
#define kJSONKeyCinemaCityID @"city_id"
#define kJSONKeyCinemaDistrictID @"district_id"
#define kJSONKeyCinemaAddress @"address"
#define kJSONKeyCinemaPhone @"phone"
#define kJSONKeyCinemaLongitude @"longitude"
#define kJSONKeyCinemaLatitude @"latitude"
#define kJSONKeyCinemaService @"service"
#define kJSONKeyCinemaRate @"rate"
#define kJSONKeyCinemaDistance @"distance"
#define kJSONKeyCinemaComing @"coming"
#define kJSONKeyCinemaMovieNum @"movie_num"

#define kJSONKeyMovieID @"id"
#define kJSONKeyMovieCName @"c_name"
#define kJSONKeyMovieEName @"e_name"
#define kJSONKeyMovieSubtitle @"subtitle"
#define kJSONKeyMovieVersions @"versions"
#define kJSONKeyMovieRate @"rate"
#define kJSONKeyMovieCoverImage @"cover_image"
#define kJSONKeyMovieCinemaNum @"cinema_num"
#define kJSONKeyMovieSessionNum @"session_num"
#define kJSONKeyMovieDate @"r_date"
#define kJSONKeyMovieType @"type"
#define kJSONKeyMovieNation @"nation"
#define kJSONKeyMovieLanguage @"language"
#define kJSONKeyMovieDuration @"duration"
#define kJSONKeyMovieDescription @"description"
#define kJSONKeyMovieImages @"images"
#define kJSONKeyMovieVideos @"videos"

#define kJSONKeySessionID @"id"
#define kJSONKeySessionVersion @"version"
#define kJSONKeySessionStartTime @"s_time"
#define kJSONKeySessionEndTime @"e_time"
#define kJSONKeySessionMaxPrice @"price_max"
#define kJSONKeySessionMinPrice @"price_min"
#define kJSONKeySessionRoom @"room"

#define kJSONKeyTicketSource @"source"
#define kJSONKeyTicketOriginalPrice @"yuanjia"
#define kJSONKeyTicketCurrentPrice @"xianjia"
#define kJSONKeyTicketAccessMethod @"method"
#define kJSONKeyTicketImageUrl @"url"

#pragma mark - Notification UserInfo Keys
#define kUserInfoKeyPage @"page"
#define kUserInfoKeyCities @"cities"
#define kUserInfoKeyCityVersion @"city_version"

#define kUserInfoKeyCityID @"city_id"
#define kUserInfoKeyDistricts @"districts"

#define kUserInfoKeyCinemas @"cinemas"
#define kUserInfoKeyDistrictID @"district_id"

#define kUserInfoKeyMovies @"movies"
#define kUserInfoKeyMovieDetail @"movie"

#define kUserInfoKeyMovieID @"movie_id"
#define kUserInfoKeyCinemaID @"cinema_id"
#define kUserInfoKeyCinemaDetail @"cinema"
#define kUserInfoKeySessions @"sessions"

#define kUserInfoKeySessionID @"session_id"
#define kUserInfoKeyTickets @"tickets"

#define kUserInfoKeyMethodLocation  @"methodLocation"
#define kUserInfoKeyError @"error"

#pragma mark - Notification Names

#define kCityListSuccessNotification @"kCityListSuccessNotification"
#define kCityListFailedNotification @"kCityListFailedNotification"
#define kCityVersionSuccessNotification @"kCityVersionSuccessNotification"
#define kCityVersionFailedNotification @"kCityVersionFailedNotification"
#define kDistrictListInCitySuccessNotification @"kDistrictListInCitySuccessNotification"
#define kDistrictListInCityFailedNotification @"kDistrictListInCityFailedNotification"
#define kCinemaListSuccessNotification @"kCinemaListSuccessNotification"
#define kCinemaListFailedNotification @"kCinemaListFailedNotification"
#define kCinemaListInCitySuccessNotification @"kCinemaListInCitySuccessNotification"
#define kCinemaListInCityFailedNotification @"kCinemaListInCityFailedNotification"
#define kCinemaListInDistrictSuccessNotification @"kCinemaListInDistrictSuccessNotification"
#define kCinemaListInDistrictFailedNotification @"kCinemaListInDistrictFailedNotification"
#define kMovieListSuccessNotification @"kMovieListSuccessNotification"
#define kMovieListFailedNotification @"kMovieListFailedNotification"
#define kMovieDetailListSuccessNotification @"kMovieDetailListSuccessNotification"
#define kCinemaDetailListSuccessNotification @"kCinemaDetailListSuccessNotification"
#define kMovieDetailListFailedNotification @"kMovieDetailListFailedNotification"
#define kCinemaDetailListFailedNotification @"kCinemaDetailListFailedNotification"
#define kSessionListSuccessNotification @"kSessionListSuccessNotification"
#define kSessionListFailedNotification @"kSessionListFailedNotification"
#define kTicketListSuccessNotification @"kTicketListSuccessNotification"
#define kTicketListFailedNotification @"kTicketListFailedNotification"
#define kCinemaOrderTypeChangeNotification @"kCinemaOrderTypeChangeNotification"
#define kLocationDidChangeNotification @"kLocationDidChangeNotification"

#pragma mark - Utils

//获取界面字符串
#define UI_STRING(key)                  NSLocalizedString(key, nil)

// 声明一个单例方法
#define DECLARE_SHARED_INSTANCE(className)  \
+ (className *)sharedInstance;

// 实现一个单例方法
#define IMPLEMENT_SHARED_INSTANCE(className)  \
+ (className *)sharedInstance \
{ \
static dispatch_once_t onceToken; \
static className *sharedInstance = nil; \
dispatch_once(&onceToken, ^{ \
sharedInstance = [[self alloc] init]; \
}); \
return sharedInstance; \
}

#pragma mark - UI
// 颜色
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 \
green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0 \
blue:((float)((rgbValue) & 0xFF))/255.0 \
alpha:1.0]

#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 \
green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0 \
blue:((float)((rgbValue) & 0xFF))/255.0 \
alpha:(alphaValue)]

#define UI_COLOR_PINK            UIColorFromRGB(0xFE6F80)

#define UI_NAVIGATION_BAR_HEIGHT    44
#define UI_STATUS_BAR_HEIGHT        20

#define UI_SCREEN_WIDTH            ((IOS8 || !IsLandscape) ?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height)
#define UI_SCREEN_HEIGHT           ((IOS8 || !IsLandscape) ?[UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].bounds.size.width)

// 获取版本号CFBundleShortVersionString
#define APP_BUILD_VERSION   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define APP_VERSION         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#pragma mark - 系统定义
#define IOS8            ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)

#define IS_IPHONE4     (fabs(UI_SCREEN_HEIGHT - 480) < 0.01)
#define IS_IPHONE5     (fabs(UI_SCREEN_HEIGHT - 568) < 0.01)
#define IS_IPHONE6     (fabs(UI_SCREEN_HEIGHT - 667) < 0.01)
#define IS_IPHONE6PLUS (fabs(UI_SCREEN_HEIGHT - 736) < 0.01)

#define UIScreenScale   ([[UIScreen mainScreen] scale])
#define IsLandscape     (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))

#endif
