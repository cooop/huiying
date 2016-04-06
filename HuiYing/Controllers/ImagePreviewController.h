//
//  ImagePreviewController.h
//  HuiYing
//
//  Created by 金鑫 on 15/9/21.
//  Copyright © 2015年 huiying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePreviewController : UIViewController
@property (nonatomic, assign) int64_t startIndex;
@property (nonatomic, strong) NSArray* images;
- (id)initWithImages:(NSArray*)images startIndex:(int64_t)index;
@end
