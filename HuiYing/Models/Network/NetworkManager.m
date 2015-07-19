//
//  NetworkManager.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/8.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NetworkManager.h"
#import "URLManager.h"
#import "CityMeta.h"
#import "DistrictMeta.h"
#import "CinemaMeta.h"
#import "MovieMeta.h"
#import "MovieDetailMeta.h"
#import "SessionMeta.h"
#import "SessionsMeta.h"
#import "TicketMeta.h"

@implementation NetworkManager

IMPLEMENT_SHARED_INSTANCE(NetworkManager);

#pragma mark - location queries
-(void)cityList{
    [self GET:[URLManager cityList] parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSMutableArray * cityMetas = [[NSMutableArray alloc]init];
          for(id dict in (NSArray *)responseObject){
              CityMeta * cityMeta = [[CityMeta alloc] initWithDict:(NSDictionary *)dict];
              [cityMetas addObject:cityMeta];
          }
          
          for(CityMeta* cityMeta in cityMetas){
              NSLog(@"%@",cityMeta);
          }
          NSDictionary * userInfo = @{kUserInfoKeyMethodLocation:@"cityList",kUserInfoKeyCities:cityMetas};
          [[NSNotificationCenter defaultCenter] postNotificationName:kCityListSuccessNotification object:self userInfo:userInfo];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSDictionary * userInfo  = @{kUserInfoKeyMethodLocation:@"cityList",kUserInfoKeyError:error.description};
          [[NSNotificationCenter defaultCenter] postNotificationName:kCityListFailedNotification object:self userInfo:userInfo];
      }];
}

-(void)districtListInCity:(int64_t)cityID{
    [self GET:[URLManager districtListInCity:cityID] parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSMutableArray * districtMetas = [[NSMutableArray alloc]init];
          for(id dict in (NSArray *)responseObject ){
              DistrictMeta * cityMeta = [[DistrictMeta alloc] initWithDict:(NSDictionary *)dict inCity:cityID];
              [districtMetas addObject:cityMeta];
          }
          for(DistrictMeta* districtMeta in districtMetas){
              NSLog(@"%@",districtMeta);
          }
          NSDictionary * userInfo = @{kUserInfoKeyMethodLocation:@"districtListInCity",kUserInfoKeyCityID:@(cityID) ,kUserInfoKeyDistricts:districtMetas};
          [[NSNotificationCenter defaultCenter] postNotificationName:kDistrictListInCitySuccessNotification object:self userInfo:userInfo];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSDictionary * userInfo  = @{kUserInfoKeyMethodLocation:@"districtListInCity",kUserInfoKeyCityID:@(cityID),kUserInfoKeyError:error.description};
          [[NSNotificationCenter defaultCenter] postNotificationName:kDistrictListInCityFailedNotification object:self userInfo:userInfo];
      }];
}

#pragma mark - cinema queries

-(void)cinemaList{
    [self GET:[URLManager cinemaList] parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSMutableArray *cinemaMetas = [[NSMutableArray alloc]init];
          for(id dict in (NSArray*)responseObject){
              CinemaMeta *cinemaMeta =[[CinemaMeta alloc]initWithDict:dict];
              [cinemaMetas addObject:cinemaMeta];
          }
          for (CinemaMeta* cinemaMeta in cinemaMetas) {
              NSLog(@"%@",cinemaMeta);
          }
          
          NSDictionary * userInfo =@{kUserInfoKeyMethodLocation:@"cinemaList",kUserInfoKeyCinemas:cinemaMetas};
          [[NSNotificationCenter defaultCenter] postNotificationName:kCinemaListSuccessNotification object:self userInfo:userInfo];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSDictionary * userInfo  = @{kUserInfoKeyMethodLocation:@"cinemaList",kUserInfoKeyError:error.description};
          [[NSNotificationCenter defaultCenter] postNotificationName:kCinemaListFailedNotification object:self userInfo:userInfo];
      }];
}

-(void)cinemaListInCity:(int64_t)cityID{
    [self GET:[URLManager cinemaListInCity:cityID] parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSMutableArray *cinemaMetas = [[NSMutableArray alloc]init];
          for(id dict in (NSArray*)[responseObject objectForKey:@"results"]){
              CinemaMeta *cinemaMeta =[[CinemaMeta alloc]initWithDict:dict];
              [cinemaMetas addObject:cinemaMeta];
          }
          for (CinemaMeta* cinemaMeta in cinemaMetas) {
              NSLog(@"%@",cinemaMeta);
          }
          NSDictionary * userInfo =@{kUserInfoKeyMethodLocation:@"cinemaListInCity",kUserInfoKeyCityID: @(cityID),kUserInfoKeyCinemas:cinemaMetas};
          [[NSNotificationCenter defaultCenter] postNotificationName:kCinemaListInCitySuccessNotification object:self userInfo:userInfo];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSDictionary * userInfo  = @{kUserInfoKeyMethodLocation:@"cinemaListInCity",kUserInfoKeyCityID: @(cityID),kUserInfoKeyError:error.description};
          [[NSNotificationCenter defaultCenter] postNotificationName:kCinemaListInCityFailedNotification object:self userInfo:userInfo];
      }];
}

-(void)cinemaListInCity:(int64_t)cityID inDistrict:(int64_t)districtID{
    [self GET:[URLManager cinemaListInCity:cityID inDistrict:districtID] parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSMutableArray *cinemaMetas = [[NSMutableArray alloc]init];
          for(id dict in (NSArray*)[responseObject objectForKey:@"results"]){
              CinemaMeta *cinemaMeta =[[CinemaMeta alloc]initWithDict:dict];
              [cinemaMetas addObject:cinemaMeta];
          }
          for (CinemaMeta* cinemaMeta in cinemaMetas) {
              NSLog(@"%@",cinemaMeta);
          }
          NSDictionary * userInfo =@{kUserInfoKeyMethodLocation:@"cinemaListInDistrict",kUserInfoKeyCityID: @(cityID),kUserInfoKeyDistrictID: @(districtID),kUserInfoKeyCinemas:cinemaMetas};
          [[NSNotificationCenter defaultCenter] postNotificationName:kCinemaListInDistrictSuccessNotification object:self userInfo:userInfo];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSDictionary * userInfo  = @{kUserInfoKeyMethodLocation:@"cinemaListInDistrict",kUserInfoKeyCityID: @(cityID),kUserInfoKeyDistrictID: @(districtID),kUserInfoKeyError:error.description};
          [[NSNotificationCenter defaultCenter] postNotificationName:kCinemaListInDistrictFailedNotification object:self userInfo:userInfo];
      }];
}

#pragma mark - movie queries

-(void)movieListInCity:(int64_t)cityID{
    [self GET:[NSString stringWithFormat:@"%@&page=%d",[URLManager movieListInCity:cityID],1] parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSMutableArray *movieMetas = [[NSMutableArray alloc]init];
          for(id dict in (NSArray*)[responseObject objectForKey:@"results"]){
              MovieMeta *movieMeta =[[MovieMeta alloc]initWithDict:dict];
              [movieMetas addObject:movieMeta];
          }
          for(MovieMeta *movieMeta in movieMetas){
              NSLog(@"%@",movieMeta);
          }
          NSDictionary * userInfo =@{kUserInfoKeyMethodLocation:@"movieList",kUserInfoKeyMovies:movieMetas};
          [[NSNotificationCenter defaultCenter] postNotificationName:kMovieListSuccessNotification object:self userInfo:userInfo];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSDictionary * userInfo  = @{kUserInfoKeyMethodLocation:@"movieList",kUserInfoKeyError:error.description};
          [[NSNotificationCenter defaultCenter] postNotificationName:kMovieListFailedNotification object:self userInfo:userInfo];
      }];
}

-(void)movieListDetailWithID:(int64_t)movieID{
    [self GET:[URLManager movieListDetailWithID:movieID] parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSDictionary* dict =(NSDictionary*)responseObject;
          MovieDetailMeta *movieDetail = [[MovieDetailMeta alloc]initWithDict:dict];
          NSLog(@"%@",movieDetail);
          NSDictionary * userInfo =@{kUserInfoKeyMethodLocation:@"movieListDetailWithID",kUserInfoKeyMovieID:@(movieID),kUserInfoKeyMovieDetail:movieDetail};
          [[NSNotificationCenter defaultCenter] postNotificationName:kMovieDetailListSuccessNotification object:self userInfo:userInfo];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSDictionary * userInfo  = @{kUserInfoKeyMethodLocation:@"movieListDetailWithID",kUserInfoKeyMovieID:@(movieID),kUserInfoKeyError:error.description};
          [[NSNotificationCenter defaultCenter] postNotificationName:kMovieDetailListFailedNotification object:self userInfo:userInfo];
      }];
}

-(void)movieListInCinema:(int64_t)cinemaID{
    [self GET:[NSString stringWithFormat:@"%@",[URLManager movieListInCinema:cinemaID]] parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSMutableArray *movieMetas = [[NSMutableArray alloc]init];
          for(id dict in (NSArray*)[responseObject objectForKey:@"results"]){
              MovieMeta *movieMeta =[[MovieMeta alloc]initWithDict:dict];
              [movieMetas addObject:movieMeta];
          }
          for(MovieMeta *movieMeta in movieMetas){
              NSLog(@"%@",movieMeta);
          }
          NSDictionary * userInfo =@{kUserInfoKeyMethodLocation:@"movieList",kUserInfoKeyMovies:movieMetas};
          [[NSNotificationCenter defaultCenter] postNotificationName:kMovieListSuccessNotification object:self userInfo:userInfo];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSDictionary * userInfo  = @{kUserInfoKeyMethodLocation:@"movieList",kUserInfoKeyError:error.description};
          [[NSNotificationCenter defaultCenter] postNotificationName:kMovieListFailedNotification object:self userInfo:userInfo];
      }];
}

#pragma mark - session queries
-(void)sessionOfMovie:(int64_t)movieID inCinema:(int64_t)cinemaID{
    [self GET:[URLManager sessionOfMovie:movieID inCinema:cinemaID] parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          SessionsMeta *sessionsMeta = [[SessionsMeta alloc]initWithArray:(NSArray*)responseObject ofMovie:movieID inCinema:cinemaID];
          NSDictionary * userInfo =@{kUserInfoKeyMethodLocation:@"sessionOfMovieInCinema",kUserInfoKeyMovieID: @(movieID),kUserInfoKeyCinemaID: @(cinemaID),kUserInfoKeySessions:sessionsMeta};
          [[NSNotificationCenter defaultCenter] postNotificationName:kSessionListSuccessNotification object:self userInfo:userInfo];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSDictionary * userInfo  = @{kUserInfoKeyMethodLocation:@"cinemaListInDistrict",kUserInfoKeyMovieID: @(movieID),kUserInfoKeyCinemaID: @(cinemaID),kUserInfoKeyError:error.description};
          [[NSNotificationCenter defaultCenter] postNotificationName:kSessionListFailedNotification object:self userInfo:userInfo];
      }];
}

#pragma mark - ticket queries
-(void)ticketPriceOfSession:(int64_t)sessionID{
    [self GET:[URLManager ticketPriceOfSession:sessionID] parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSMutableArray *ticketMetas = [[NSMutableArray alloc]init];
          for(id dict in (NSArray*)responseObject){
              TicketMeta *ticketMeta =[[TicketMeta alloc]initWithDict:dict ofSession:sessionID];
              [ticketMetas addObject:ticketMeta];
          }
          for (TicketMeta* ticketMeta in ticketMetas) {
              NSLog(@"%@",ticketMeta);
          }
          NSDictionary * userInfo =@{kUserInfoKeyMethodLocation:@"ticketPriceOfSession",kUserInfoKeySessionID: @(sessionID),kUserInfoKeyTickets:ticketMetas};
          [[NSNotificationCenter defaultCenter] postNotificationName:kTicketListSuccessNotification object:self userInfo:userInfo];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSDictionary * userInfo  = @{kUserInfoKeyMethodLocation:@"ticketPriceOfSession",kUserInfoKeySessionID: @(sessionID),kUserInfoKeyError:error.description};
          [[NSNotificationCenter defaultCenter] postNotificationName:kTicketListFailedNotification object:self userInfo:userInfo];
      }];
}

@end
