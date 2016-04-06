//
//  ApplicationSettings.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/23.
//  Copyright (c) 2015年 huiying. All rights reserved.
//

#import "ApplicationSettings.h"

@implementation ApplicationSettings
IMPLEMENT_SHARED_INSTANCE(ApplicationSettings)

- (void)loadSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.cityID = [defaults integerForKey:@"cityID"];
    self.cityName = [defaults stringForKey:@"cityName"];
    self.timestamp = [defaults integerForKey:@"timestamp"];
    self.cityList = [defaults objectForKey:@"cityList"];
}

- (void)saveSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.cityID forKey:@"cityID"];
    [defaults setObject:self.cityName forKey:@"cityName"];
    [defaults setInteger:self.timestamp forKey:@"timestamp"];
    [defaults setObject:self.cityList forKey:@"cityList"];
}
@end
