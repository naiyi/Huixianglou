//
//  JDOArrayModel.m
//  JiaodongOnlineNews
//
//  Created by zhang yi on 13-7-15.
//  Copyright (c) 2013年 胶东在线. All rights reserved.
//

#import "JDOrderDetailModel.h"

@implementation JDOrderDetailModel

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.price = [aDecoder decodeObjectForKey:@"price"];
        self.count = [aDecoder decodeObjectForKey:@"count"];
        self.dish_id = [aDecoder decodeObjectForKey:@"dish_id"];
        self.dish_name = [aDecoder decodeObjectForKey:@"dish_name"];
        self.good_bad = [aDecoder decodeObjectForKey:@"good_bad"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.price forKey:@"price"];
    [aCoder encodeObject:self.count forKey:@"count"];
    [aCoder encodeObject:self.dish_id forKey:@"dish_id"];
    [aCoder encodeObject:self.dish_name forKey:@"dish_name"];
    [aCoder encodeObject:self.good_bad forKey:@"good_bad"];
}

@end
