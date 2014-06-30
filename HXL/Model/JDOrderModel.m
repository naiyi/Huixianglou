//
//  JDOArrayModel.m
//  JiaodongOnlineNews
//
//  Created by zhang yi on 13-7-15.
//  Copyright (c) 2013年 胶东在线. All rights reserved.
//

#import "JDOrderModel.h"

@implementation JDOrderModel

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.detail = [aDecoder decodeObjectForKey:@"detail"];
        self.diner_name = [aDecoder decodeObjectForKey:@"diner_name"];
        self.hotel = [aDecoder decodeObjectForKey:@"hotel"];
        self.hotel_id = [aDecoder decodeObjectForKey:@"hotel_id"];
        self.hotel_mpic = [aDecoder decodeObjectForKey:@"hotel_mpic"];
        self.order_id = [aDecoder decodeObjectForKey:@"order_id"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.detail forKey:@"detail"];
    [aCoder encodeObject:self.diner_name forKey:@"diner_name"];
    [aCoder encodeObject:self.hotel forKey:@"hotel"];
    [aCoder encodeObject:self.hotel_id forKey:@"hotel_id"];
    [aCoder encodeObject:self.hotel_mpic forKey:@"hotel_mpic"];
    [aCoder encodeObject:self.order_id forKey:@"order_id"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.time forKey:@"time"];
}

@end
