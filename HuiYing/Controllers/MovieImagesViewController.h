//
//  MovieImagesViewController.h
//  HuiYing
//
//  Created by 金鑫 on 15/9/21.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieImagesViewController : UIViewController

@property (nonatomic,strong) NSArray * imageUrls;

-(id)initWithImageUrls:(NSArray*) imageUrls;

@end
