//
//  ImageViewController.h
//  HuiYing
//
//  Created by 金鑫 on 15/9/21.
//  Copyright © 2015年 huiying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

@property (nonatomic, assign) NSUInteger pageIndex;

- (instancetype)initWithURL:(NSString *)url;

@end
