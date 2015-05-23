//
//  ApplicationSettings.h
//  HuiYing
//
//  Created by Jin Xin on 15/5/23.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constraits.h"

@interface ApplicationSettings : NSObject
DECLARE_SHARED_INSTANCE(ApplicationSettings)
@property (nonatomic, assign) NSString* city;
- (void)loadSettings;
- (void)saveSettings;
@end
