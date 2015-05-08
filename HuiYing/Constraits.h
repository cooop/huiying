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
#define kJSONKeyCityName  @"region_name"

#define kJSONKeyDistrictID @"id"
#define kJSONKeyDistrictName @"region_name"

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

#define kJSONKeyMovieID @"id"
#define kJSONKeyMovieCName @"c_name"
#define kJSONKeyMovieEName @"e_name"
#define kJSONKeyMovieSubtitle @"subtitle"
#define kJSONKeyMovieVersions @"versions"
#define kJSONKeyMovieRate @"rate"
#define kJSONKeyMovieCoverImage @"cover_image"
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
#define kJSONKeySessionTime @"s_time"
#define kJSONKeySessionRoom @"room"

#define kJSONKeyTicketSource @"source"
#define kJSONKeyTicketOriginalPrice @"yuanjia"
#define kJSONKeyTicketCurrentPrice @"xianjia"
#define kJSONKeyTicketAccessMethod @"method"

#pragma mark - Notification UserInfo Keys
#define kUserInfoKeyCities @"cities"

#define kUserInfoKeyCityID @"city_id"
#define kUserInfoKeyDistricts @"districts"

#define kUserInfoKeyCinemas @"cinemas"
#define kUserInfoKeyDistrictID @"district_id"

#define kUserInfoKeyMovies @"movies"
#define kUserInfoKeyMovieDetail @"movie"

#define kUserInfoKeyMovieID @"movie_id"
#define kUserInfoKeyCinemaID @"cinema_id"
#define kUserInfoKeySessions @"sessions"

#define kUserInfoKeySessionID @"session_id"
#define kUserInfoKeyTickets @"tickets"

#define KUserInfoKeyError @"error"

#pragma mark - Notification Names

#define kCityListSuccessNotification @"kCityListSuccessNotification"
#define kCityListFailedNotification @"kCityListFailedNotification"
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
#define kMovieDetailListFailedNotification @"kMovieDetailListFailedNotification"
#define kSessionListSuccessNotification @"kSessionListSuccessNotification"
#define kSessionListFailedNotification @"kSessionListFailedNotification"
#define kTicketListSuccessNotification @"kTicketListSuccessNotification"
#define kTicketListFailedNotification @"kTicketListFailedNotification"

#endif
