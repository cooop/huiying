//
//  MovieDetailMeta.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/8.
//  Copyright (c) 2015年 huiying. All rights reserved.
//

#import "MovieDetailMeta.h"
#import "Constraits.h"
#import "Utils.h"

@implementation MovieDetailMeta
-(id)initWithDict:(NSDictionary *)dict{
    if (self = [super initWithDict:dict]) {
        _date = [Utils formatDate:[dict objectForKey:kJSONKeyMovieDate]];
        if ([dict objectForKey:kJSONKeyMovieImages] != [NSNull null]) {
            _images = [[dict objectForKey:kJSONKeyMovieImages] componentsSeparatedByString:@","];
        }
        if ([dict objectForKey:kJSONKeyMovieVideos] != [NSNull null]) {
            _videos= [[dict objectForKey:kJSONKeyMovieVideos] componentsSeparatedByString:@","];
        }
        _type = [dict objectForKey:kJSONKeyMovieType];
        _nation = [dict objectForKey:kJSONKeyMovieNation];
        _language = [dict objectForKey:kJSONKeyMovieLanguage];
        _duration = [[dict objectForKey:kJSONKeyMovieDuration]intValue];
        _movieDescription = [dict objectForKey:kJSONKeyMovieDescription];
        _director = [dict objectForKey:kJSONKeyMovieDirector];
//        NSMutableString* actorStr = [@"主演： " mutableCopy];
//        if ([dict objectForKey:kJSONKeyMovieActors] != [NSNull null]) {
//            NSArray* actors = [[dict objectForKey:kJSONKeyMovieActors] componentsSeparatedByString:@","];
//            for(NSString* actor in actors){
//                [actorStr appendFormat:@"%@ ", actor];
//            }
//        }
        _actors = [dict objectForKey:kJSONKeyMovieActors];
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"MovieDetailMeta{\n\tmovieID : %lld,\n\tchineseName : %@,\n\tenglishName : %@,\n\tsubtitle : %@,\n\tversion : %d,\n\trate : %f,\n\tcoverImage : %@\n\tdate : %@,\n\ttype : %@,\n\tnation : %@,\n\tlanguage : %@,\n\tduration : %lld,\n\tdescription : %@,\n\timages : %@,\n\tvideos : %@\n}",self.movieID,self.chineseName,self.englishName,self.subtitle,self.version,self.rate,self.coverImage,_date,_type,_nation,_language,_duration,_movieDescription,_images,_videos];
}

@end
