//
//  MovieDetailMeta.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/8.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "MovieDetailMeta.h"
#import "Constraits.h"

@implementation MovieDetailMeta
-(id)initWithDict:(NSDictionary *)dict{
    if (self = [super initWithDict:dict]) {
        //TODO:初始化
        //_date =
        //_images =
        //_video =
        
        _type = [dict objectForKey:kJSONKeyMovieType];
        _nation = [dict objectForKey:kJSONKeyMovieNation];
        _language = [dict objectForKey:kJSONKeyMovieLanguage];
        _duration = [[dict objectForKey:kJSONKeyMovieDuration]intValue];
        _movieDescription = [dict objectForKey:kJSONKeyMovieDescription];
    }
    return self;
}
@end
