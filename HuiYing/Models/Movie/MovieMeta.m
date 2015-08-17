//
//  MovieMeta.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/8.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "MovieMeta.h"
#import "Constraits.h"

@implementation MovieMeta
-(id)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        _movieID = [[dict objectForKey:kJSONKeyMovieID]intValue];
        _chineseName = [dict objectForKey:kJSONKeyMovieCName];
        _englishName = [dict objectForKey:kJSONKeyMovieEName];
        _subtitle = [dict objectForKey:kJSONKeyMovieSubtitle];
        _version = [MovieMeta translateMovieVersion:[dict objectForKey:kJSONKeyMovieVersions]];
        _rate = [[dict objectForKey:kJSONKeyMovieRate]floatValue];
        _coverImage = [dict objectForKey:kJSONKeyMovieCoverImage];
        _cinemaNum = [[dict objectForKey:kJSONKeyMovieCinemaNum]intValue];
        _sessionNum = [[dict objectForKey:kJSONKeyMovieSessionNum]intValue];
    }
    return self;
}

+(MovieVersion) translateMovieVersion:(NSString *) version{
    if ([version isEqualToString:@"2D"]) {
        return kMovieVersion2D;
    }else if([version isEqualToString:@"2DIMAX"]){
        return kMovieVersion2DIMAX;
    }else if ([version isEqualToString:@"3D"]){
        return kMovieVersion3D;
    }else if ([version isEqualToString:@"3DIMAX"]){
        return kMovieVersion3DIMAX;
    }else{
        return kMovieVersionUnknown;
    }
}

-(NSString *)description{
    return [NSString stringWithFormat:@"MovieMeta{\n\tmovieID : %lld,\n\tchineseName : %@,\n\tenglishName : %@,\n\tsubtitle : %@,\n\tversion : %d,\n\trate : %f,\n\tcoverImage : %@\n}",_movieID,_chineseName,_englishName,_subtitle,_version,_rate,_coverImage];
}

@end
