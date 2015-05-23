//
//  ApplicationSettings.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/23.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "ApplicationSettings.h"

@implementation ApplicationSettings
IMPLEMENT_SHARED_INSTANCE(ApplicationSettings)

- (void)loadSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.city = [defaults stringForKey:@"city"];
}

- (void)saveSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.city forKey:@"city"];
}
@end
