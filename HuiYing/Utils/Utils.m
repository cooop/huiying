//
//  Utils.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(NSDate*)formatDate:(NSString*)dateString{
    return [Utils formatDate:dateString format:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
}

+(NSDate*)formatDate:(NSString*)dateString format:(NSString*)format{
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    NSDate* date =  [dateFormatter dateFromString:dateString];
    return date;
}

+(NSString*)formatDateToString:(NSDate*)date format:(NSString*)format{
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString* dateString =  [dateFormatter stringFromDate:date];
    return dateString;
}


@end
