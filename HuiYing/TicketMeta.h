//
//  TicketMeta.h
//  HuiYing
//
//  Created by Jin Xin on 15/5/8.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum TicketSource{
    kTicketSourceUnknown = 0,
    kTicketSourceTaobao,
    kTicketSourceMaoyan,
    kTicketSourceGewara
}TicketSource;

typedef enum TicketAccessMethod{
    kTicketAccessMethodWeb = 0,
    kTicketAccessMethodApp
}TicketAccessMethod;

@interface TicketMeta : NSObject
@property (nonatomic) TicketSource source;
@property (nonatomic) float originalPrice;
@property (nonatomic) float currentPrice;
@property (nonatomic) TicketAccessMethod accessMethod;
@property (nonatomic) int64_t sessionID;

-(id) initWithDict:(NSDictionary*)dict ofSession:(int64_t)sessionID;
+(TicketSource) translateTicketSource:(NSString*)source;
+(TicketAccessMethod) translateTicketAccessMethod:(NSString*)method;

@end
