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
@property (nonatomic) int64_t movieID;
@property (nonatomic,strong) NSString* chineseName;
@property (nonatomic,strong) NSString* englishName;
@property (nonatomic,strong) NSString * subtitle;
@property (nonatomic) MovieVersion version;
@property (nonatomic,strong) NSString * coverImage;
@property (nonatomic) float rate;
-(id)initWithDict:(NSDictionary *)dict;
+(MovieVersion) translateMovieVersion:(NSString *) version;
@end
