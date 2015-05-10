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
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate* date =  [dateFormatter dateFromString:dateString];
    return date;
}

@end
