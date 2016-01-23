//
//  MovieMeta.h
//  HuiYing
//
//  Created by Jin Xin on 15/5/8.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieMeta : NSObject
@property (nonatomic,assign) int64_t movieID;
@property (nonatomic,strong) NSString* chineseName;
@property (nonatomic,strong) NSString* englishName;
@property (nonatomic,strong) NSString * subtitle;
@property (nonatomic,strong) NSString * version;
@property (nonatomic,strong) NSString * coverImage;
@property (nonatomic,assign) float rate;
@property (nonatomic,assign) NSUInteger cinemaNum;
@property (nonatomic,assign) NSUInteger sessionNum;

-(id)initWithDict:(NSDictionary *)dict;
@end
