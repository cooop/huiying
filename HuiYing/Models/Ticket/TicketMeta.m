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
        _source = [TicketMeta translateTicketSource:[dict objectForKey:kJSONKeyTicketSource]];
        _originalPrice = [[dict objectForKey:kJSONKeyTicketOriginalPrice]floatValue];
        _currentPrice = [[dict objectForKey:kJSONKeyTicketCurrentPrice]floatValue];
        _accessMethod = [TicketMeta translateTicketAccessMethod:[dict objectForKey:kJSONKeyTicketAccessMethod]];
        _sessionID = sessionID;
    }
    return self;
}

+(TicketSource)translateTicketSource:(NSString *)source{
    if ([source isEqualToString:@"taobao"]) {
        return kTicketSourceTaobao;
    }else if([source isEqualToString:@"maoyan"]){
        return kTicketSourceMaoyan;
    }else if([source isEqualToString:@"gewara"]){
        return kTicketSourceGewara;
    }else{
        return kTicketSourceUnknown;
    }
}

+(TicketAccessMethod)translateTicketAccessMethod:(NSString *)method{
    if ([method isEqualToString:@"app"]) {
        return kTicketAccessMethodApp;
    }else{
        return kTicketAccessMethodWeb;
    }
}

-(NSString *)description{
    return [NSString stringWithFormat:@"TicketMeta{\n\tsource : %d,\n\toriginalPrice : %f,\n\tcurrentPrice : %f,\n\taccessMethod : %d,\n\tsessionID : %lld\n}",_source,_originalPrice,_currentPrice,_accessMethod,_sessionID];
}

@end
