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
#import "Constraits.h"

@implementation NetworkManager

-(void)cityList{
    __block NSMutableArray * cityMetas = [[NSMutableArray alloc]init];
    [self GET:[URLManager cityList] parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          for(id dict in (NSArray *)responseObject){
              CityMeta * cityMeta = [[CityMeta alloc] initWithDict:(NSDictionary *)dict];
              [cityMetas addObject:cityMeta];
          }
          
          NSDictionary * userInfo = @{kUserInfoKeyCities:cityMetas};
          [[NSNotificationCenter defaultCenter] postNotificationName:kCityListSuccessNotification object:self userInfo:userInfo];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSDictionary * userInfo  = @{KUserInfoKeyError:error.description};
          [[NSNotificationCenter defaultCenter] postNotificationName:kCityListFailedNotification object:self userInfo:userInfo];
      }];
}

-(void)districtListInCity:(int64_t)cityID{
    __block NSMutableArray * districtMetas = [[NSMutableArray alloc]init];
    [self GET:[URLManager districtListInCity:cityID] parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          for(id dict in (NSArray *)responseObject){
              DistrictMeta * cityMeta = [[DistrictMeta alloc] initWithDict:(NSDictionary *)dict inCity:cityID];
              [districtMetas addObject:cityMeta];
          }
          
          NSDictionary * userInfo = @{kUserInfoKeyCityID:@(cityID) ,kUserInfoKeyDistricts:districtMetas};
          [[NSNotificationCenter defaultCenter] postNotificationName:kDistrictListInCitySuccessNotification object:self userInfo:userInfo];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSDictionary * userInfo  = @{kUserInfoKeyCityID:@(cityID),KUserInfoKeyError:error.description};
          [[NSNotificationCenter defaultCenter] postNotificationName:kDistrictListInCityFailedNotification object:self userInfo:userInfo];
      }];
}

@end
