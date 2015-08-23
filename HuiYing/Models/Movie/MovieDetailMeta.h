//
//  MovieDetailMeta.h
//  HuiYing
//
//  Created by Jin Xin on 15/5/8.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "MovieMeta.h"

@interface MovieDetailMeta : MovieMeta
@property (nonatomic,strong) NSString* type;
@property (nonatomic,strong) NSDate * date;
@property (nonatomic,strong) NSString* nation;
@property (nonatomic,strong) NSString* language;
@property (nonatomic) int64_t duration;
@property (nonatomic,strong) NSString* movieDescription;
@property (nonatomic,strong) NSArray* images;
@property (nonatomic,strong) NSArray* videos;
@property (nonatomic,strong) NSString* director;
@property (nonatomic,strong) NSString* actors;
-(id)initWithDict:(NSDictionary *)dict;
@end
