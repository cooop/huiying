//
//  Utils.h
//  HuiYing
//
//  Created by Jin Xin on 15/5/10.
//  Copyright (c) 2015年 huiying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

+(NSDate*)formatDate:(NSString*)date;
+(NSDate*)formatDate:(NSString*)dateString format:(NSString*)format;
+(NSString*)formatDateToString:(NSDate*)date format:(NSString*)format;
+(UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
+(UIImage*)defaultBlurImage:(UIImage*)image;

+(UIImage*)versionImage:(NSString*)version;
+(NSString*)versionString:(NSString *)versionString;

@end
