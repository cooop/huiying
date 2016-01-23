//
//  TicketMeta.h
//  HuiYing
//
//  Created by Jin Xin on 15/5/8.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum TicketAccessMethod{
    kTicketAccessMethodWeb = 0,
    kTicketAccessMethodApp
}TicketAccessMethod;

@interface TicketMeta : NSObject
@property (nonatomic) NSString* source;
@property (nonatomic) NSString* cname;
@property (nonatomic) float originalPrice;
@property (nonatomic) float currentPrice;
@property (nonatomic) TicketAccessMethod accessMethod;
@property (nonatomic) int64_t sessionID;
@property (nonatomic) NSString* url;
@property (nonatomic) NSString* iconUrl;

-(id) initWithDict:(NSDictionary*)dict ofSession:(int64_t)sessionID;
+(TicketAccessMethod) translateTicketAccessMethod:(NSString*)method;

@end
