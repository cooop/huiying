//
//  Utils.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/10.
//  Copyright (c) 2015年 huiying. All rights reserved.
//

#import "Utils.h"
#import "UIImage+ImageEffects.h"

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

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

+(UIImage*)defaultBlurImage:(UIImage*)image{
    return [image applyBlurWithRadius:5.0f tintColor:[UIColor colorWithWhite:0.85f alpha:0.75f] saturationDeltaFactor:1.8f maskImage:nil];
}

+(UIImage*)versionImage:(NSString *)versionString{
    NSArray* versions = [versionString componentsSeparatedByString:@"/"];
    NSString* highestQuality = @"";
    for (NSString* version in versions) {
        NSString *versionStr = [version stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([versionStr isEqualToString:@"IMAX"]) {
            highestQuality = @"list_movie_ico_imax3d";
            break;
        }
        if([versionStr isEqualToString:@"3D"]){
            highestQuality = @"list_movie_ico_3d";
        }
    }
    if ([highestQuality isEqualToString:@""]) {
        return nil;
    }
    return [UIImage imageNamed:highestQuality];

}

+(NSString*)versionString:(NSString *)versionString{
    NSArray* versions = [versionString componentsSeparatedByString:@"/"];
    NSString* highestQuality = @"2D";
    for (NSString* version in versions) {
        NSString *versionStr = [version stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([versionStr containsString:@"IMAX"]) {
            highestQuality = @"IMAX";
            break;
        }
        if([versionStr containsString:@"3D"]){
            highestQuality = @"3D";
        }
    }
    return highestQuality;
}


@end
