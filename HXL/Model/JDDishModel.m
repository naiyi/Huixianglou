//
//  JDDishModel.m
//  HXL
//
//  Created by 刘斌 on 14-6-10.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDDishModel.h"

@implementation JDDishModel
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self=[super init]) {
        self.id = [aDecoder decodeIntForKey:@"id"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.img_small = [aDecoder decodeObjectForKey:@"img_small"];
        self.img_big = [aDecoder decodeObjectForKey:@"img_big"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.desc = [aDecoder decodeObjectForKey:@"desc"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.status_reason = [aDecoder decodeObjectForKey:@"status_reason"];
        self.taste = [aDecoder decodeObjectForKey:@"taste"];
        self.price = [aDecoder decodeIntForKey:@"price"];
        self.weight = [aDecoder decodeIntForKey:@"weight"];
        self.show = [aDecoder decodeIntForKey:@"show"];
        self.count = [aDecoder decodeIntForKey:@"count"];
        self.onep = [aDecoder decodeIntForKey:@"onep"];
        self.recommend = [aDecoder decodeIntForKey:@"recommend"];
        self.zan = [aDecoder decodeIntForKey:@"zan"];
        self.order_number = [aDecoder decodeIntForKey:@"order_number"];
        self.price_type = [aDecoder decodeIntForKey:@"price_type"];
        self.sort = [aDecoder decodeIntForKey:@"sort"];
        self.checked_fenliang = [aDecoder decodeIntForKey:@"checked_fenliang"];
        self.checked_weight = [aDecoder decodeIntForKey:@"checked_weight"];
        self.price_show = [aDecoder decodeIntForKey:@"price_show"];
        self.ifOrdered = [aDecoder decodeBoolForKey:@"ifOrdered"];
        self.price_list = [aDecoder decodeObjectForKey:@"price_list"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:self.id forKey:@"id"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.img_small forKey:@"img_small"];
    [aCoder encodeObject:self.img_big forKey:@"img_big"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.status_reason forKey:@"status_reason"];
    [aCoder encodeObject:self.taste forKey:@"taste"];
    [aCoder encodeInt:self.price forKey:@"price"];
    [aCoder encodeInt:self.weight forKey:@"weight"];
    [aCoder encodeInt:self.show forKey:@"show"];
    [aCoder encodeInt:self.count forKey:@"count"];
    [aCoder encodeInt:self.onep forKey:@"onep"];
    [aCoder encodeInt:self.recommend forKey:@"recommend"];
    [aCoder encodeInt:self.zan forKey:@"zan"];
    [aCoder encodeInt:self.order_number forKey:@"order_number"];
    [aCoder encodeInt:self.price_type forKey:@"price_type"];
    [aCoder encodeInt:self.sort forKey:@"sort"];
    [aCoder encodeInt:self.checked_fenliang forKey:@"checked_fenliang"];
    [aCoder encodeInt:self.checked_weight forKey:@"checked_weight"];
    [aCoder encodeInt:self.price_show forKey:@"price_show"];
    [aCoder encodeBool:self.ifOrdered forKey:@"ifOrdered"];
    [aCoder encodeObject:self.price_list forKey:@"price_list"];
}
@end
