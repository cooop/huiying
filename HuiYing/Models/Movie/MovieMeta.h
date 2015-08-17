//
//  MovieMeta.h
//  HuiYing
//
//  Created by Jin Xin on 15/5/8.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum MovieVersion{
    kMovieVersionUnknown = 0,
    kMovieVersion2D,
    kMovieVersion2DIMAX,
    kMovieVersion3D,
    kMovieVersion3DIMAX
} MovieVersion;

@interface MovieMeta : NSObject
@property (nonatomic,assign) int64_t movieID;
@property (nonatomic,strong) NSString* chineseName;
@property (nonatomic,strong) NSString* englishName;
@property (nonatomic,strong) NSString * subtitle;
@property (nonatomic,assign) MovieVersion version;
@property (nonatomic,strong) NSString * coverImage;
@property (nonatomic,assign) float rate;
@property (nonatomic,assign) NSUInteger cinemaNum;
@property (nonatomic,assign) NSUInteger sessionNum;

-(id)initWithDict:(NSDictionary *)dict;
+(MovieVersion) translateMovieVersion:(NSString *) version;
@end
