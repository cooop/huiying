//
//  TicketMeta.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/8.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "TicketMeta.h"
#import "Constraits.h"

@implementation TicketMeta
-(id)initWithDict:(NSDictionary *)dict ofSession:(int64_t)sessionID{
    if (self =[super init]) {
        _source = [dict objectForKey:kJSONKeyTicketSource];
        _cname = [self translateSource:self.source];
        _url = [dict objectForKey:kJSONKeyTicketImageUrl];
        _originalPrice = [[dict objectForKey:kJSONKeyTicketOriginalPrice]floatValue];
        _currentPrice = [[dict objectForKey:kJSONKeyTicketCurrentPrice]floatValue];
        _accessMethod = [TicketMeta translateTicketAccessMethod:[dict objectForKey:kJSONKeyTicketAccessMethod]];
        _sessionID = sessionID;
    }
    return self;
}

+(TicketAccessMethod)translateTicketAccessMethod:(NSString *)method{
    if ([method isEqualToString:@"app"]) {
        return kTicketAccessMethodApp;
    }else{
        return kTicketAccessMethodWeb;
    }
}

-(NSString*)translateSource:(NSString*)ename{
    NSString* cname = ename;
    if ([ename isEqualToString:@"taobao"]) {
        cname =  @"淘宝电影";
    }else if([ename isEqualToString:@"netease"]){
        cname = @"网易电影";
    }
    return cname;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"TicketMeta{\n\tsource : %d,\n\toriginalPrice : %f,\n\tcurrentPrice : %f,\n\taccessMethod : %d,\n\tsessionID : %lld\n}",_source,_originalPrice,_currentPrice,_accessMethod,_sessionID];
}

@end
